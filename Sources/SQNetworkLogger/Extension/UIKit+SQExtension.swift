//
//  UIKit+SQExtension.swift
//  SQNetworkLogger
//
//  Created by Ivan Mikhailovskii on 17.11.2023.
//

import UIKit

extension UIWindow {

    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {

        if Setting.isStart {
            let controller = NetworkLoggerTableViewController.loggerScreen
            self.rootViewController?.present(controller, animated: true, completion: nil)
        }

        super.motionEnded(motion, with: event)
    }
}

