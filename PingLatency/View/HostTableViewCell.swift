//
//  HostTableViewCell.swift
//  PingLatency
//
//  Created by Javid Sheikh on 11/04/2018.
//  Copyright © 2018 Javid Sheikh. All rights reserved.
//

import UIKit

class HostTableViewCell: UITableViewCell {

    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var latencyLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    static let cellHeight: CGFloat = 150.0
    static let reuseIdentifier = "HostTableViewCell"

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
        if let url = URL(string: viewModel.imageUrl) {
            do {
                let data = try Data(contentsOf: url)
                self.iconImageView.image = UIImage(data: data)
            } catch {
                // TODO - handle error
                print("Error retrieving icon image")
            }
        }
        bindViewModel()
    }

    fileprivate func bindViewModel() {
        viewModel.updateLatency = { [weak self] in
            let latencyText = self?.viewModel.latencyString ?? "Not Found"
            self?.latencyLabel.text = "Average Latency: \(latencyText) ms"
        }
        viewModel.latencyError = { [weak self] in
            self?.latencyLabel.text = "Unable to contact host"
        }
    }

    @IBAction func retestLatency(_ sender: Any) {
        viewModel.fetchAverageLatency()
    }
}
