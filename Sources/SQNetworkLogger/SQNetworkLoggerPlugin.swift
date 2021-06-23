import Moya
import SwiftyJSON
import Foundation

public class SQNetworkLoggerPlugin: PluginType {
    
    var logger: SQNetworkError?
    private var isDebug: Bool
    
    public init(isDebug: Bool = true) {
        self.isDebug = isDebug
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        self.logger = SQNetworkError()
        if let headers = target.headers {
            self.logger?.headers = ""
            headers.forEach { (key, value) in
                self.logger?.headers! += "\(key) : \(value)\n"
            }
        }
    
        self.logger?.method = target.method.rawValue
        
        switch result {
        case .success(let response):
            self.logger?.url = response.request?.url?.absoluteString
            if let httpBody = response.request?.httpBody {
                self.logger?.httpBody = try? JSON.init(data: httpBody).description
            }
            
            do {
                let json = JSON(try response.mapJSON())
                self.logger?.responseJSON = json.description
                self.logger?.statusCode = String(response.statusCode)
                
                if json["error_code"].string != nil ||
                    response.statusCode >= 400 ||
                    response.statusCode <= 0 {
                    
                    self.saveLog()
                    return
                }
                
                if self.isDebug {
                    self.saveLog()
                    return
                }
                
            } catch {
                self.logger?.statusCode = String(response.statusCode)
                self.saveLog()
            }
        case .failure(let moyaError):
            self.logger?.url = moyaError.response?.request?.url?.absoluteString
            switch moyaError {
            case .underlying(let underlyingError, _):
                let error = NSError.error(from: underlyingError)
                self.logger?.statusCode = String(error.code)
            default:
                break
            }
            self.saveLog()
        }
    }
    
    func saveLog() {
        guard let logger = self.logger else { return }
        
        let userDefaults = UserDefaults.standard
        
        if let encoded = try? JSONEncoder().encode(logger) {
            var networkErrors = userDefaults.array(forKey: "network_errors") ?? [Data]()
            networkErrors.append(encoded)
            UserDefaults.standard.set(networkErrors, forKey: "network_errors")
            userDefaults.synchronize()
        }
    }
}
