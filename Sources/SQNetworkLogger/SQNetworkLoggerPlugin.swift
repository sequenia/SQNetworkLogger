import Moya
import Foundation

/// Moya plugin for saving all server requests and responses in UserDefaults
public actor SQNetworkLoggerPlugin: PluginType {

    private var isActive: Bool
    private var limit: Int
    private var logCurl: Bool
    private var dictionaryRequests: NSMutableDictionary

    /// Creates a plugin instance
    ///
    /// - Parameters:
    ///   - isActive: will be the plugin active?
    ///   - limit: length of requests log history (100 by default)
    ///   - logCurl: need log cURL representations in console
    public init(isActive: Bool = true, limit: Int = 100, logCurl: Bool = true) {
        self.isActive = isActive
        self.limit = limit
        self.logCurl = logCurl
        self.dictionaryRequests = [:]
    }

    nonisolated public func willSend(_ request: RequestType, target: TargetType) {
        _Concurrency.Task { await self.asyncWillSend(request, target: target) }
    }

    nonisolated private func asyncWillSend(_ request: RequestType, target: TargetType) async {
        guard await self.isActive, let urlRequest = request.request else { return }

        await self.dictionaryRequests[urlRequest] = urlRequest.cURL(pretty: true)
        if await self.logCurl {
            print("Request: \(urlRequest.cURL(pretty: true))")
        }
    }

    nonisolated public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        _Concurrency.Task { await self.asyncDidReceive(result, target: target) }
    }

    private func asyncDidReceive(_ result: Result<Response, MoyaError>, target: TargetType) async {
        if !self.isActive { return }

        var logger: SQNetworkRequestLog?
        switch result {
        case .success(let response):
            if let request = response.request {
                logger = SQNetworkRequestLog(
                    withRequest: request,
                    cURL: self.dictionaryRequests[request] as? String,
                    response: response.response,
                    responseBody: response.data
                )

                await saveLog(logger)
            }
        case .failure(let error):
            if let request = error.response?.request {
                var curl: String? = nil
                if let urlRequest = request.urlRequest {
                    curl = self.dictionaryRequests[urlRequest] as? String
                }

                logger = SQNetworkRequestLog(
                    withRequest: request,
                    cURL: curl,
                    response: error.response?.response,
                    responseBody: error.response?.data
                )
            }
            switch error {
            case .underlying(let underlyingError, _):
                let nsError = NSError.error(from: underlyingError)
                logger?.statusCode = nsError.code
            default:
                break
            }
            await saveLog(logger)
        }
    }

    private func saveLog(_ logger: SQNetworkRequestLog?) async {
        guard let logger = logger, isActive else { return }

        await SQNetworkRequestLog.saveLog(logger, limit: limit)
    }
}
