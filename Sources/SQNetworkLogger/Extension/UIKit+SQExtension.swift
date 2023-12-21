//
//  UIKit+SQExtension.swift
//  SQNetworkLogger
//
//  Created by Ivan Mikhailovskii on 17.11.2023.
//

import UIKit

@available(iOS 13.0, *)
private extension UIScene.ActivationState {
    var sortPriority: Int {
        switch self {
        case .foregroundActive: return 1
        case .foregroundInactive: return 2
        case .background: return 3
        case .unattached: return 4
        @unknown default: return 5
        }
    }
}

extension UIWindow {

    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .sorted { $0.activationState.sortPriority < $1.activationState.sortPriority }
                .compactMap { $0 as? UIWindowScene }
                .compactMap { $0.windows.first { $0.isKeyWindow } }
                .first
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    fileprivate var presentingViewController: UIViewController? {
        var rootViewController = UIWindow.keyWindow?.rootViewController
        while let controller = rootViewController?.presentedViewController {
            rootViewController = controller
        }
        return rootViewController
    }

    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {

        if Setting.isStart {
            let controller = NetworkLoggerTableViewController.loggerScreen
            self.presentingViewController?.present(controller, animated: true, completion: nil)
        }

        super.motionEnded(motion, with: event)
    }
}

