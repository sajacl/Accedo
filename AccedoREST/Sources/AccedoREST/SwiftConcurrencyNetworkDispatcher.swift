import Foundation
import AccedoLogging

extension REST {
    @available(iOS 13.0, *)
    final class SwiftConcurrencyNetworkDispatcher<Success> {
        private let name: String

        private let requestHandler: RESTRequestHandler
        private let responseHandler: AnyResponseHandler<Success>

        private let logger: any Logging

        private let _taskIdentifier: String

        var taskIdentifier: String {
            "\(name).\(_taskIdentifier)"
        }

        init(
            name: String,
            requestHandler: RESTRequestHandler,
            responseHandler: AnyResponseHandler<Success>
        ) {
            self.name = name
            self.requestHandler = requestHandler
            self.responseHandler = responseHandler

            _taskIdentifier = getTaskIdentifier(name: name)

            if #available(iOS 14.0, *) {
                logger = OSLog.networkLogger
            } else {
                logger = CustomLogger.networkLogger
            }
        }

        func start() async throws -> Result<Success, Swift.Error> {
            try Task.checkCancellation()

            let host = REST.apiHost

            do {
                let request = try requestHandler.createURLRequest(host: host)

                return try await didReceiveURLRequest(request, host: host)
            } catch {
                let wrappedError = Error.createURLRequest(error)

                logger.error(
                    metadata: taskIdentifier,
                    error: wrappedError,
                    message: "Failed to create URLRequest."
                )

                return .failure(wrappedError)
            }
        }

        private func didReceiveURLRequest(
            _ restRequest: REST.Request,
            host: AnyHost
        ) async throws -> Result<Success, Swift.Error> {
            try Task.checkCancellation()

            logger.debug(
                metadata: taskIdentifier,
                message: "Send request to \(restRequest.pathTemplate.templateString)"
            )

            let transport = REST.makeURLSession()

            do {
                let (data, response) = try await transport.data(for: restRequest.urlRequest)

                let httpResponse = response as! HTTPURLResponse

                return self.didReceiveURLResponse(
                    httpResponse,
                    data: data,
                    host: host
                )
            } catch {
                self.didReceiveError(
                    error,
                    host: host
                )

                return .failure(error)
            }
        }

        private func didReceiveError(
            _ error: Swift.Error,
            host: AnyHost
        ) {
            guard !error.isCancellationError else {
                return
            }

            if let urlError = error as? URLError {
                switch urlError.code {
                    case .notConnectedToInternet, .internationalRoamingOff, .callIsActive:
                        break

                    default:
                        break
                }

                let wrappedError = Error.network(urlError)

                logger.error(
                    metadata: taskIdentifier,
                    error: wrappedError,
                    message: "Failed to perform request to \(host)."
                )
            } else {
                logger.error(
                    metadata: taskIdentifier,
                    error: error,
                    message: "Failed to perform request to \(host)."
                )
            }
        }

        private func didReceiveURLResponse(
            _ response: HTTPURLResponse,
            data: Data,
            host: AnyHost
        ) -> Result<Success, Swift.Error> {
            logger.debug(
                metadata: taskIdentifier,
                message: "Response: \(response.statusCode)."
            )

            let handlerResult = responseHandler.handleURLResponse(response, data: data)

            switch handlerResult {
                case let .success(output):
                    // Response handler produced value.
                    return .success(output)

                case let .decoding(decoderBlock):
                    // Response handler returned a block decoding value.
                    let decodeResult = Result { try decoderBlock() }
                        .mapError { error -> REST.Error in
                            return .decodeResponse(error)
                        }

                    return decodeResult.mapError { $0 }

                case let .unhandledResponse(serverErrorResponse):
                    return .failure(
                        REST.Error.unhandledResponse(response.statusCode, serverErrorResponse)
                    )
            }
        }
    }
}

@available(iOS 13.0, *)
extension Error {
    fileprivate var isCancellationError: Bool {
        self is CancellationError || (self as? URLError.Code) == URLError.cancelled
    }
}
