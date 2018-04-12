//
//  HostCellViewModel.swift
//  PingLatency
//
//  Created by Javid Sheikh on 11/04/2018.
//  Copyright © 2018 Javid Sheikh. All rights reserved.
//

import Foundation
import UIKit

class HostCellViewModel {
    let hostNameText: String
    let urlText: String
    let iconURL: String
    let apiService: APIService
    var iconImage: UIImage = UIImage() {
        didSet {
            self.updateIconImage?()
        }
    }
    var latency: Double?
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var updateLatency: ((Double) -> Void)?
    var latencyError: ((PingError) -> Void)?
    var updateLoadingStatus: (() -> Void)?
    var updateIconImage: (() -> Void)?

    init(hostNameText: String, urlText: String, iconURL: String, apiService: APIService = APIService(session: URLSession.shared)) {
        self.hostNameText = hostNameText
        self.urlText = urlText
        self.iconURL = iconURL
        self.apiService = apiService
    }

    func fetchAverageLatency() {
        isLoading = true
        PingService.pingHostName(urlText) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let latency):
                self?.latency = latency
                self?.updateLatency?(latency)
            case .failure(let error):
                self?.latencyError?(error)
            }
        }
    }

    func startIconImageDownload() {
        DispatchQueue.global(qos: .utility).async {
            self.apiService.fetchImage(fromURL: self.iconURL, completion: { image in
                self.iconImage = image
            })
        }
    }
}
