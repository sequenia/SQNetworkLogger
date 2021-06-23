import Foundation

class SQNetworkError: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case url
        case httpBody
        case method
        case headers
        case responseJSON
        case statusCode
    }

    var id: String! = UUID().uuidString
    var date = Date()
    var url: String?
    var httpBody: String?
    var method: String?
    var headers: String?
    var responseJSON: String?
    var statusCode: String?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        
        self.date = try container.decode(Date.self, forKey: .date)
        self.url = try container.decode(String?.self, forKey: .url)
        self.httpBody = try container.decode(String?.self, forKey: .httpBody)
        self.method = try container.decode(String?.self, forKey: .method)
        self.headers = try container.decode(String?.self, forKey: .headers)
        self.responseJSON = try container.decode(String?.self, forKey: .responseJSON)
        self.statusCode = try container.decode(String?.self, forKey: .statusCode)
    }
    
    init(id: String!,
         date: Date!,
         url: String?,
         httpBody: String?,
         method: String?,
         headers: String?,
         responseJSON: String?,
         statusCode: String? ) {
        
        self.id = id
        self.url = url
        self.httpBody = httpBody
        self.method = method
        self.headers = headers
        self.responseJSON = responseJSON
        self.statusCode = statusCode
        self.date = date ?? Date()
    }
    
    init(){}
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.url, forKey: .url)
        try container.encode(self.method, forKey: .method)
        try container.encode(self.headers, forKey: .headers)
        try container.encode(self.responseJSON, forKey: .responseJSON)
        try container.encode(self.statusCode, forKey: .statusCode)
        try container.encode(self.httpBody, forKey: .httpBody)
        try container.encode(self.date, forKey: .date)
        
    }
    
    func description() -> String {
        
        return ("Date: \(self.date)\nURL: \(self.url ?? "nil")\nmethod: \(self.method ?? "nil")\nheaders: {\n\(self.headers ?? "nil")}\nhttpBody:\(self.httpBody ?? "nil")\nstatusCode: \(self.statusCode ?? "nil")\nresponseJSON: \(self.responseJSON ?? "nil")\n\n\ncURL:\n\(self.getCURL())")
    }
    
    func getCURL() -> String {
        var request = URLRequest(url: URL(string: self.url!)!)
        
        var newHeaders = [String: String]()
        
        for element in self.headers?.split(separator: "\n") ?? [] {
            let headers = element.split(separator: ":")
            let key = headers.first
            let value = headers.last
            newHeaders[String(key ?? "")] = String(value ?? "")
        }

        request.allHTTPHeaderFields = newHeaders
        request.httpMethod = self.method ?? "GET"
        request.httpBody = Data((self.httpBody ?? "").utf8)
        
        return request.cURL()
    }
}
