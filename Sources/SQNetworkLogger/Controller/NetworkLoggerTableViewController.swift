//
//  NetworkLoggerTableViewController.swift
//
//  Created by Ivan Mikhailovskii on 13.10.2020.
//  Copyright © 2020 Sequenia OOO. All rights reserved.
//

import UIKit

public class NetworkLoggerTableViewController: UITableViewController {
    
    private var data = [SQNetworkError]()
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Errors list"
        self.registerCell()
        self.getNetworkErrors()
        self.tableView.reloadData()
    }
    
    func registerCell() {
        self.tableView.sq_register(NLInfoTableCell.self)
    }
    
    func getNetworkErrors() {
        self.data = SQNetworkError.savedLogs
    }

// MARK: - Table view data source
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.sq_dequeueReusableCell(NLInfoTableCell.self, indexPath: indexPath) else { return UITableViewCell() }

        cell.bind(entity: self.data[indexPath.row])
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = NetworkErrorInfoViewController(nibName: "NetworkErrorInfoViewController", bundle: Bundle.module)
        controller.networkError = self.data[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
