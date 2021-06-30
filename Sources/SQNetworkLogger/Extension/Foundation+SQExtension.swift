//
//  File.swift
//  
//
//  Created by Ivan Mikhailovskii on 23.06.2021.
//

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
