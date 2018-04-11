//
//  HostCellViewModel.swift
//  PingLatency
//
//  Created by Javid Sheikh on 11/04/2018.
//  Copyright © 2018 Javid Sheikh. All rights reserved.
//

import Foundation

class HostCellViewModel {
    let hostNameText: String
    let urlText: String
    let imageUrl: String
    var latency: Double?
    var updateLatency: ((Double) -> Void)?
    var latencyError: ((PingError) -> Void)?

    init(hostNameText: String, urlText: String, imageUrl: String) {
        self.hostNameText = hostNameText
        self.urlText = urlText
        self.imageUrl = imageUrl
    }

    func fetchAverageLatency() {
        PingService.pingHostName(urlText) { [weak self] result in
            switch result {
            case .success(let latency):
                self?.latency = latency
                self?.updateLatency?(latency)
            case .failure(let error):
                self?.latencyError?(error)
            }
        }
    }
}
