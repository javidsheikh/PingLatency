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
    var overlay: UIView!
    var activityIndicator: UIActivityIndicatorView!
    var sortButton: UIBarButtonItem?
    var pingAllButton: UIBarButtonItem?
    lazy var overlayFrame = CGRect(x: view.bounds.width / 2 - 25, y: view.bounds.height / 2 - 60, width: 50, height: 50)

    override func viewDidLoad() {
        super.viewDidLoad()

        let service = APIService(session: URLSession.shared)
        viewModel = HostTableViewModel(apiService: service)
        bindViewModel()

        tableView.allowsSelection = false
        updateLoadingStatus()
        addNavigationItems()
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
        viewModel.reloadTableViewRow = { [weak self] row in
            let indexPath = IndexPath(row: row, section: 0)
            DispatchQueue.main.async {
                self?.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }

    fileprivate func addNavigationItems() {
        sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortCellsByLatency))
        navigationItem.leftBarButtonItem = sortButton

        pingAllButton = UIBarButtonItem(title: "Ping All", style: .plain, target: self, action: #selector(pingAllHosts))
        navigationItem.rightBarButtonItem = pingAllButton
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HostTableViewCell.reuseIdentifier, for: indexPath) as! HostTableViewCell

        let cellViewModel = viewModel.getCellViewModel(forIndexPath: indexPath)
        cell.delegate = self
        cell.setUpCell(withViewModel: cellViewModel)
        cellViewModel.startIconImageDownload()

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HostTableViewCell.cellHeight
    }

    fileprivate func updateLoadingStatus() {
        if viewModel.isLoading {
            tableView.isUserInteractionEnabled = false
            sortButton?.isEnabled = false
            pingAllButton?.isEnabled = false
            overlay = UIView(frame: overlayFrame)
            overlay.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            activityIndicator = UIActivityIndicatorView()
            activityIndicator?.frame = CGRect(x: overlay.bounds.width / 2 - 15, y: overlay.bounds.height / 2 - 15, width: 30, height: 30)
            overlay.addSubview(activityIndicator)
            navigationController?.view.insertSubview(overlay, aboveSubview: tableView)
            activityIndicator?.startAnimating()
        } else {
            tableView.isUserInteractionEnabled = true
            sortButton?.isEnabled = true
            pingAllButton?.isEnabled = true
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
            overlay.removeFromSuperview()
            overlay = nil
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

    @objc func pingAllHosts() {
        viewModel.pingAllHosts()
    }

}
