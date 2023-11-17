//
//  File.swift
//  SQNetworkLogger
//
//  Created by Ivan Mikhailovskii on 17.11.2023.
//

import Foundation

public struct Setting {

    internal static var isStart = false

    public static func start() {
        self.isStart = true
    }
}
