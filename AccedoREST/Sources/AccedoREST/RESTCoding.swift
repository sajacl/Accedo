import Foundation

extension REST {
    enum Coding {}
}

extension REST.Coding {
    /// Returns a JSON encoder used by REST API.
    static func makeJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        encoder.dataEncodingStrategy = .deferredToData
        return encoder
    }

    /// Returns a JSON decoder used by REST API.
    static func makeJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        decoder.dataDecodingStrategy = .deferredToData
        return decoder
    }
}
