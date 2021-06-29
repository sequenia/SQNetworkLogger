//
//  NetworkErrorInfoViewController.swift
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
        self.title = "Error info"
        self.infoTextView.text = self.networkError?.description()
    }
    
    func addButtonNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.share))
    }
    
    @objc func share() {
        let message = ["```\n\(self.networkError?.description() ?? "")\n```"]
        let activityVC = UIActivityViewController(activityItems: message, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.navigationController?.present(activityVC, animated: true, completion: nil)
    }
}
