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
    var latencyString: String? {
        didSet {
            updateLatency?()
        }
    }
    var updateLatency: (() -> Void)?
    var latencyError: (() -> Void)?

    init(hostNameText: String, urlText: String, imageUrl: String) {
        self.hostNameText = hostNameText
        self.urlText = urlText
        self.imageUrl = imageUrl
    }

    func fetchAverageLatency() {
        PingService.pingHostName(urlText) { [weak self] result in
            switch result {
            case .success(let latency) :
                print("Average latency for \(self?.hostNameText ?? "") is \(latency) ms")
                self?.latencyString = String(latency)
            case .failure(let error):
                print("Unable to fetch latency for \(self?.hostNameText ?? "") - \(error)")
                self?.latencyError?()
            }
        }
    }
}
