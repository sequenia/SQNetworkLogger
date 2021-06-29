import UIKit

class SQNetworkError: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case url
        case httpBody
        case method
        case headers
        case response
        case statusCode
        case cURL
    }

    enum ResponseType {
        case unknown
        case success
        case warning
        case error

        public var color: UIColor {
            switch self {
            case .unknown:
                return UIColor.lightGray

            case .success:
                return UIColor.green

            case .warning:
                return UIColor.yellow

            case .error:
                return UIColor.red
            }
        }
    }

    var id = UUID().uuidString
    var date = Date()

    var url: String?
    var method: String?
    var headers: String?
    var httpBody: String?

    var statusCode: Int?
    var response: String?

    var cURL: String?

    public var type: ResponseType {
        guard let statusCode = self.statusCode else { return .unknown }

        if statusCode >= 200 && statusCode <= 299 { return .success }

        if statusCode >= 300 && statusCode <= 399 { return .warning }

        return .error
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.date = try container.decode(Date.self, forKey: .date)

        self.url = try container.decode(String?.self, forKey: .url)
        self.method = try container.decode(String?.self, forKey: .method)
        self.headers = try container.decode(String?.self, forKey: .headers)
        self.httpBody = try container.decode(String?.self, forKey: .httpBody)

        self.statusCode = try container.decode(Int?.self, forKey: .statusCode)
        self.response = try container.decode(String?.self, forKey: .response)

        self.cURL = try container.decode(String?.self, forKey: .cURL)
    }

    init(withRequest request: URLRequest,
         cURL: String? = nil,
         response: HTTPURLResponse? = nil,
         responseBody: Data? = nil
    ) {
        self.url = request.url?.absoluteString
        self.method = request.method?.rawValue
        self.headers = request.headers.map { "\($0.name): \($0.value)" }.joined(separator: "\n")
        if let data = request.httpBody {
            self.httpBody = String(decoding: data, as: UTF8.self)
        }

        if let statusCode = response?.statusCode {
            self.statusCode = statusCode
        }

        if let data = responseBody {
            self.response = String(decoding: data, as: UTF8.self)
        }

        self.cURL = cURL
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.date, forKey: .date)

        try container.encode(self.url, forKey: .url)
        try container.encode(self.method, forKey: .method)
        try container.encode(self.headers, forKey: .headers)
        try container.encode(self.httpBody, forKey: .httpBody)

        try container.encode(self.response, forKey: .response)
        try container.encode(self.statusCode, forKey: .statusCode)


        try container.encode(self.cURL, forKey: .cURL)
        
    }
    
    func description() -> String {
        """
        \(self.date.formattedDate)

        \(self.method ?? "-"): \(self.url ?? "-")
        
        Headers:
        \(self.headers ?? "-")

        HttpBody:
        \(self.httpBody ?? "-")

        cURL:
        \(self.cURL ?? "-")

        Status code: \(self.statusCode ?? 0)

        Response:
        \(self.response ?? "-")
        """
    }
}

extension SQNetworkError {

    static func saveLog(_ log: SQNetworkError, limit: Int) {
        var currentErrors = SQNetworkError.savedLogs
        currentErrors.insert(log, at: 0)
        currentErrors = Array(currentErrors.prefix(limit))
        
        let errorsToSave = currentErrors.compactMap { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(errorsToSave, forKey: .networkErrorsKey)
        UserDefaults.standard.synchronize()
    }

    static var savedLogs: [SQNetworkError] {
        guard let networkErrorArray = UserDefaults.standard.array(forKey: .networkErrorsKey) as? [Data] else {
            return []
        }

        return networkErrorArray.compactMap { try? JSONDecoder().decode(SQNetworkError.self, from: $0) }
                                .sorted(by: { $0.date > $1.date })
    }
}

private extension String {

    static let networkErrorsKey = "network_errors"
}
