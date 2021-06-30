//
//  NetworkErrorInfoViewController.swift
//
//  Created by Ivan Mikhailovskii on 13.10.2020.
//  Copyright © 2020 Sequenia OOO. All rights reserved.
//

import UIKit

/// Screen for displaying full info about request and that's response
class NetworkErrorInfoViewController: UIViewController {
    
    @IBOutlet private weak var infoTextView: UITextView!
    
    public var networkError: SQNetworkError?

    @IBAction private func onShareRequestClicked(_ sender: UIButton) {
        var shareItems = [String]()
        if let cURL = self.networkError?.cURL {
            shareItems = ["```\n\(cURL)\n```"]
        } else if let requestInfo = self.networkError?.requestInfo() {
            shareItems = ["```\n\(requestInfo)\n```"]
        }
        self.share(items: shareItems, sender: sender)
    }

    @IBAction private func onShareResponseClicked(_ sender: UIButton) {
        var shareItems = [String]()
        if let responseInfo = self.networkError?.responseInfo() {
            shareItems = ["```\n\(responseInfo)\n```"]
        }
        self.share(items: shareItems, sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Error info"
        self.infoTextView.text = self.networkError?.description()
    }
    
    func share(items: [String], sender: UIView) {
        if items.isEmpty { return }

        let message = items
        let activityVC = UIActivityViewController(activityItems: message, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = sender
        self.navigationController?.present(activityVC, animated: true, completion: nil)
    }
}
