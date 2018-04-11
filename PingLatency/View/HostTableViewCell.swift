//
//  HostTableViewCell.swift
//  PingLatency
//
//  Created by Javid Sheikh on 11/04/2018.
//  Copyright © 2018 Javid Sheikh. All rights reserved.
//

import UIKit

protocol HostTableViewCellDelegate: class {
    func displayErrorAlert(withMessage message: String)
}

class HostTableViewCell: UITableViewCell {

    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var latencyLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var loadingOverlay: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    static let cellHeight: CGFloat = 150.0
    static let reuseIdentifier = "HostTableViewCell"

    weak var delegate: HostTableViewCellDelegate?
    var viewModel: HostCellViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpCell(withViewModel viewModel: HostCellViewModel) {
        self.viewModel = viewModel
        hostNameLabel.text = viewModel.hostNameText
        urlLabel.text = viewModel.urlText
        if let latency = viewModel.latency {
            latencyLabel.text =  "Average Latency: \(latency) ms"
        } else {
            latencyLabel.text = "Average Latency: -"
        }
        bindViewModel()
    }

    fileprivate func bindViewModel() {
        viewModel.updateLatency = { [weak self] latency in
            DispatchQueue.main.async {
                self?.latencyLabel.text = "Average Latency: \(latency) ms"
            }
        }
        viewModel.latencyError = { [weak self] error in
            DispatchQueue.main.async {
                self?.delegate?.displayErrorAlert(withMessage: error.localizedDescription)
            }
        }
        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                self?.updateLoadingView()
            }
        }
        viewModel.updateIconImage = { [weak self] in
            DispatchQueue.main.async {
                self?.iconImageView.image = self?.viewModel.iconImage
            }
        }
    }

    fileprivate func updateLoadingView() {
        if viewModel.isLoading {
            activityIndicator.startAnimating()
            loadingOverlay.isHidden = false
        } else {
            activityIndicator.stopAnimating()
            loadingOverlay.isHidden = true
        }
    }

    @IBAction func retestLatency(_ sender: Any) {
        viewModel.fetchAverageLatency()
    }
}
