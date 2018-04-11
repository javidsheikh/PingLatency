//
//  MainTableViewController.swift
//  PingLatency
//
//  Created by Javid Sheikh on 11/04/2018.
//  Copyright © 2018 Javid Sheikh. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    var viewModel: HostTableViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortCellsByLatency))
        navigationItem.leftBarButtonItem = sortButton

        let retestAllButton = UIBarButtonItem(title: "Retest All", style: .plain, target: self, action: #selector(retestAll))
        navigationItem.rightBarButtonItem = retestAllButton

        let service = APIService(session: URLSession.shared)
        viewModel = HostTableViewModel(apiService: service)
        bindViewModel()
    }

    // MARK: - Table view data source

    fileprivate func bindViewModel() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HostTableViewCell.reuseIdentifier, for: indexPath) as! HostTableViewCell

        let cellViewModel = viewModel.getCellViewModel(forIndexPath: indexPath)
        cell.setUpCell(withViewModel: cellViewModel)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HostTableViewCell.cellHeight
    }

    @objc func sortCellsByLatency() {

    }

    @objc func retestAll() {

    }


}
