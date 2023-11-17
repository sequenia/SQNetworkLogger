//
//  NetworkLoggerTableViewController.swift
//
//  Created by Ivan Mikhailovskii on 13.10.2020.
//  Copyright © 2020 Sequenia OOO. All rights reserved.
//

import UIKit

/// Screen for displaying log of requests
public class NetworkLoggerTableViewController: UITableViewController {
    
    private var data = [SQNetworkRequestLog]()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.registerCell()
        self.getReuestList()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl

        self.tableView.reloadData()
    }
    
    @objc 
    func refresh(_ sender: AnyObject) {
        self.getReuestList()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    private func registerCell() {
        self.tableView.sq_register(NLInfoTableCell.self)
    }
    
    private func getReuestList() {
        self.data = SQNetworkRequestLog.savedLogs
    }

    private func setupNavigationBar() {
        self.title = "Request list"

        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem

        let closeItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.onCloseButtonClicked(_:)))

        let clearItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.onClearButtonClicked(_:)))

        self.navigationItem.leftBarButtonItem = closeItem
        self.navigationItem.rightBarButtonItem = clearItem
    }

    @objc
    private func onCloseButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    private func onClearButtonClicked(_ sender: UIBarButtonItem) {
        SQNetworkRequestLog.clearLoags()
        self.getReuestList()
        self.tableView.reloadData()
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

public extension NetworkLoggerTableViewController {

    static var loggerScreen: UIViewController {
        UINavigationController(rootViewController: NetworkLoggerTableViewController())
    }
}
