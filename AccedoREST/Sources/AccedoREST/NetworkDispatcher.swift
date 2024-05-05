import Foundation
import AccedoLogging

extension REST {
    final class NetworkOperationDispatcher<Success>: Operation {
        private let resultCompletionHandler: (Result<Success, Swift.Error>) -> Void

        private let requestHandler: RESTRequestHandler
        private let responseHandler: AnyResponseHandler<Success>

        private let logger: Logging

        private let _taskIdentifier: String

        private var task: URLSessionDataTask?

        override var isAsynchronous: Bool{
            true
        }

        override var isConcurrent: Bool {
            true
        }

        override var isReady: Bool {
            dependencies.allSatisfy(\.isReady)
        }

        var taskIdentifier: String {
            "\(name!).\(_taskIdentifier)"
        }

        init(
            name: String,
            requestHandler: RESTRequestHandler,
            responseHandler: AnyResponseHandler<Success>,
            resultCompletionHandler: @escaping (Result<Success, Swift.Error>) -> Void
        ) {
            self.requestHandler = requestHandler
            self.responseHandler = responseHandler

            _taskIdentifier = getTaskIdentifier(name: name)

            if #available(iOS 14.0, *) {
                logger = OSLog.networkLogger
            } else {
                logger = CustomLogger.networkLogger
            }

            self.resultCompletionHandler = resultCompletionHandler

            super.init()

            self.name = name
        }

        private var _isFinished : Bool = false

        private var _isExecuting : Bool = false

        override var isFinished: Bool {
            get {
                return _isFinished
            }

            set {
                willChangeValue(for: \.isFinished)
                _isFinished = newValue
                didChangeValue(for: \.isFinished)
            }
        }

        override var isExecuting: Bool {
            get {
                return _isExecuting
            }

            set {
                willChangeValue(for: \.isExecuting)
                _isExecuting = newValue
                didChangeValue(for: \.isExecuting)
            }
        }

        override func main() {
            guard !isCancelled else {
                return tryFinish(with: .failure(URLError(.cancelled)))
            }

            let host = REST.apiHost

            do {
                let request = try requestHandler.createURLRequest(host: host)

                didReceiveURLRequest(request, host: host)
            } catch {
                let wrappedError = Error.createURLRequest(error)

                logger.error(
                    metadata: taskIdentifier,
                    error: wrappedError,
                    message: "Failed to create URLRequest."
                )

                resultCompletionHandler(.failure(wrappedError))
            }
        }

        override func cancel() {
            task?.cancel()

            super.cancel()
        }

        private func didReceiveURLRequest(
            _ restRequest: REST.Request,
            host: AnyHost
        ) {
            guard !isCancelled else {
                return tryFinish(with: .failure(URLError(.cancelled)))
            }

            logger.debug(
                metadata: taskIdentifier,
                message: "Send request to \(restRequest.pathTemplate.templateString)"
            )

            let transport = REST.makeURLSession()

            let _task = transport.dataTask(with: restRequest.urlRequest) { [weak self] data, response, error in
                guard let self else {
                    // ?
                    return
                }

                if let error {
                    self.didReceiveError(
                        error,
                        host: host
                    )
                }

                let httpResponse = response as! HTTPURLResponse

                self.didReceiveURLResponse(
                    httpResponse,
                    data: data ?? Data(),
                    host: host
                )
            }

            _task.resume()

            self.task = _task
        }

        private func didReceiveError(
            _ error: Swift.Error,
            host: AnyHost
        ) {
            guard !error.isCancellationError else {
                return tryFinish(with: .failure(URLError(.cancelled)))
            }

            if let urlError = error as? URLError {
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

            tryFinish(with: .failure(error))
        }

        private func didReceiveURLResponse(
            _ response: HTTPURLResponse,
            data: Data,
            host: AnyHost
        ) {
            logger.debug(
                metadata: taskIdentifier,
                message: "Response: \(response.statusCode)."
            )

            let handlerResult = responseHandler.handleURLResponse(response, data: data)

            switch handlerResult {
                case let .success(output):
                    // Response handler produced value.
                    tryFinish(with: .success(output))

                case let .decoding(decoderBlock):
                    // Response handler returned a block decoding value.
                    let decodeResult = Result { try decoderBlock() }
                        .mapError { error -> REST.Error in
                            return .decodeResponse(error)
                        }

                    tryFinish(with: decodeResult.mapError { $0 })

                case let .unhandledResponse(serverErrorResponse):
                    tryFinish(
                        with: .failure(
                            REST.Error.unhandledResponse(response.statusCode, serverErrorResponse)
                        )
                    )
            }
        }

        private func tryFinish(with result: Result<Success, Swift.Error>) {
            isExecuting = false

            resultCompletionHandler(result)

            isFinished = true
        }
    }
}

extension Error {
    fileprivate var isCancellationError: Bool {
        (self as? URLError.Code) == URLError.cancelled
    }
}
