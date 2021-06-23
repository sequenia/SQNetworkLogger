//
//  NetworkErrorInfoViewController.swift
//  Wilgood-iOS
//
//  Created by Ivan Mikhailovskii on 13.10.2020.
//  Copyright © 2020 Sequenia OOO. All rights reserved.
//

import UIKit

class NetworkErrorInfoViewController: UIViewController {
    
    @IBOutlet private weak var infoTextView: UITextView!
    
    public var networkError: SQNetworkError?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addButtonNavBar()
        self.title = "Ошибка"
        self.infoTextView.text = self.networkError?.description()
    }
    
    func addButtonNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.share))
    }
    
    @objc func share() {
        let message = ["```\n\(self.networkError?.description() ?? "")\n```"]
        let activityVC = UIActivityViewController(activityItems: message, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.mail, .message, .airDrop, .copyToPasteboard]
        activityVC.popoverPresentationController?.sourceView = self.view
        self.navigationController?.present(activityVC, animated: true, completion: nil)
    }
}
