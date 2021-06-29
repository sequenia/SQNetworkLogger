import Moya
import SwiftyJSON
import Foundation

public class SQNetworkLoggerPlugin: PluginType {
    
    var logger: SQNetworkError?
    var cURL: String?

    private var isDebug: Bool
    private var limit: Int
    
    public init(isDebug: Bool = true, limit: Int = 100) {
        self.isDebug = isDebug
        self.limit = limit
    }

    public func willSend(_ request: RequestType, target: TargetType) {
        _ = request.cURLDescription { [weak self] output in
            self?.cURL = output
        }
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {        
        switch result {
        case .success(let response):
            if let request = response.request {
                self.logger = SQNetworkError(
                    withRequest: request,
                    cURL: self.cURL,
                    response: response.response,
                    responseBody: response.data
                )
                
                self.saveLog()
            }
        case .failure(let error):
            if let request = error.response?.request {
                self.logger = SQNetworkError(
                    withRequest: request,
                    response: error.response?.response,
                    responseBody: error.response?.data
                )
            }
            switch error {
            case .underlying(let underlyingError, _):
                let nsError = NSError.error(from: underlyingError)
                self.logger?.statusCode = nsError.code
            default:
                break
            }
            self.saveLog()
        }
    }
    
    func saveLog() {
        guard let logger = self.logger else { return }

        SQNetworkError.saveLog(logger, limit: self.limit)
    }
}
