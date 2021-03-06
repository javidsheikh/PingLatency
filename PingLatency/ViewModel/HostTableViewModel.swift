//
//  HostTableViewModel.swift
//  PingLatency
//
//  Created by Javid Sheikh on 11/04/2018.
//  Copyright © 2018 Javid Sheikh. All rights reserved.
//

import Foundation

class HostTableViewModel {

    var hostList: [Host]?
    let apiService: APIService
    var cellViewModels: [HostCellViewModel] = [] {
        didSet {
            self.reloadTableView?()
        }
    }
    var isLoading: Bool = true {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var numberOfRows: Int {
        return cellViewModels.count
    }
    var reloadTableView: (() -> Void)?
    var reloadTableViewRow: ((Int) -> Void)?
    var updateLoadingStatus: (() -> Void)?
    var displayErrorAlert: ((String) -> Void)?

    init(apiService: APIService) {
        self.apiService = apiService
        initModel(withURL: HostList.urlString)
    }

    func getCellViewModel(forIndexPath indexPath: IndexPath) -> HostCellViewModel {
        return cellViewModels[indexPath.row]
    }

    func sortByLatency() {
        cellViewModels.sort { ($0.latency ?? 5000.0).isLess(than: ($1.latency ?? 5000.0)) }
        reloadTableView?()
    }

    // Needs refactoring - having to chain callbacks because the ping service only works as a singleton. Ideally, each cell view model would be initialised with its own instance of PingService but that doesn't seem to work!
    func pingAllHosts() {
        isLoading = true
        PingService.pingHostName(cellViewModels[0].urlText) { [weak self] result in
            switch result {
            case .success(let latency):
                self?.cellViewModels[0].latency = latency
                self?.reloadTableViewRow?(0)
            case .failure:
                break
            }
            PingService.pingHostName((self?.cellViewModels[1].urlText)!) { [weak self] result in
                switch result {
                case .success(let latency):
                    self?.cellViewModels[1].latency = latency
                    self?.reloadTableViewRow?(1)
                case .failure:
                    break
                }
                PingService.pingHostName((self?.cellViewModels[2].urlText)!) { [weak self] result in
                    switch result {
                    case .success(let latency):
                        self?.cellViewModels[2].latency = latency
                        self?.reloadTableViewRow?(2)
                    case .failure:
                        break
                    }
                    PingService.pingHostName((self?.cellViewModels[3].urlText)!) { [weak self] result in
                        switch result {
                        case .success(let latency):
                            self?.cellViewModels[3].latency = latency
                            self?.reloadTableViewRow?(3)
                        case .failure:
                            break
                        }
                        PingService.pingHostName((self?.cellViewModels[4].urlText)!) { [weak self] result in
                            switch result {
                            case .success(let latency):
                                self?.cellViewModels[4].latency = latency
                                self?.reloadTableViewRow?(4)
                            case .failure:
                                break
                            }
                            PingService.pingHostName((self?.cellViewModels[5].urlText)!) { [weak self] result in
                                switch result {
                                case .success(let latency):
                                    self?.cellViewModels[5].latency = latency
                                    self?.reloadTableViewRow?(5)
                                case .failure:
                                    break
                                }
                                PingService.pingHostName((self?.cellViewModels[6].urlText)!) { [weak self] result in
                                    switch result {
                                    case .success(let latency):
                                        self?.cellViewModels[6].latency = latency
                                        self?.reloadTableViewRow?(6)
                                    case .failure:
                                        break
                                    }
                                    self?.isLoading = false
                                    self?.reloadTableView?()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    fileprivate func initModel(withURL urlString: String) {
        isLoading = true
        apiService.fetchHostList(withURL: urlString) { [weak self] result in
            switch result {
            case .success(let list):
                guard let hosts = list as? [Host] else {
                    return
                }
                self?.processFetchedHostList(hosts)
            case .failure:
                self?.displayErrorAlert?("Unable to fetch host list from server")
            }
        }
    }

    fileprivate func processFetchedHostList(_ hostList: [Host]) {
        self.hostList = hostList
        cellViewModels = hostList.map {
            HostCellViewModel(hostNameText: $0.name, urlText: $0.url, iconURL: $0.icon)
        }
        isLoading = false
    }

}
