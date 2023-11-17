import Foundation

extension NSError {
    public static func error(from error: Swift.Error) -> Self {
        func cast<T: NSError>(_ error: Swift.Error) -> T {
            return error as! T
        }
        return cast(error)
    }
}

extension Date {

    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm, dd.MM.yyyy"

        return formatter.string(from: self)
    }
}

extension URLRequest {

    public func cURL(pretty: Bool = false) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"

        var cURL = "curl "
        var header = ""
        var data: String = ""

        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key,value) in httpHeaders {
                header += ("-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }

        if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8),  !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }

        cURL += method + url + header + data
        if pretty, data.isEmpty {
            cURL.removeLast(newLine.count)
        }

        return cURL
    }
}
