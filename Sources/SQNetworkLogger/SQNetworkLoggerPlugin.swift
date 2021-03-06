import Moya
import Foundation

/// Moya plugin for saving all server requests and responses in UserDefaults
public class SQNetworkLoggerPlugin: PluginType {

    private var isActive: Bool
    private var limit: Int
    private var logCurl: Bool
    
    private var logger: SQNetworkError?
    private var cURL: String?

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
    }

    public func willSend(_ request: RequestType, target: TargetType) {
        _ = request.cURLDescription { [weak self] output in
            guard let self = self else { return }

            self.cURL = output
            if self.logCurl {
                print("Request: \(output)")
            }

        }
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {        
        switch result {
        case .success(let response):
            if let request = response.request {
                logger = SQNetworkError(
                    withRequest: request,
                    cURL: cURL,
                    response: response.response,
                    responseBody: response.data
                )
                
                saveLog()
            }
        case .failure(let error):
            if let request = error.response?.request {
                logger = SQNetworkError(
                    withRequest: request,
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
            saveLog()
        }
    }
    
    func saveLog() {
        guard let logger = logger,
              isActive else { return }

        SQNetworkError.saveLog(logger, limit: limit)
    }
}
