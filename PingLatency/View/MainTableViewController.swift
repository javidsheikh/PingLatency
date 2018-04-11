//
//  MainTableViewController.swift
//  PingLatency
//
//  Created by Javid Sheikh on 11/04/2018.
//  Copyright © 2018 Javid Sheikh. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, HostTableViewCellDelegate {

    var viewModel: HostTableViewModel!
    var activityIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()


        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortCellsByLatency))
        navigationItem.leftBarButtonItem = sortButton

        let service = APIService(session: URLSession.shared)
        viewModel = HostTableViewModel(apiService: service)
        bindViewModel()

        tableView.allowsSelection = false
        updateLoadingStatus()
    }

    // MARK: - Table view data source

    fileprivate func bindViewModel() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.displayErrorAlert = { [weak self] message in
            DispatchQueue.main.async {
                self?.displayErrorAlert(withMessage: message)
            }
        }
        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                self?.updateLoadingStatus()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HostTableViewCell.reuseIdentifier, for: indexPath) as! HostTableViewCell

        let cellViewModel = viewModel.getCellViewModel(forIndexPath: indexPath)
        cell.delegate = self
        cell.setUpCell(withViewModel: cellViewModel)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HostTableViewCell.cellHeight
    }

    fileprivate func updateLoadingStatus() {
        if viewModel.isLoading {
            activityIndicator = UIActivityIndicatorView()
            activityIndicator?.frame = CGRect(x: self.view.bounds.width / 2 - 15, y: self.view.bounds.width / 2 - 15, width: 30, height: 30)
            view.insertSubview(activityIndicator!, aboveSubview: tableView)
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
        }
    }

    func displayErrorAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    @objc func sortCellsByLatency() {
        viewModel.sortByLatency()
    }


}
