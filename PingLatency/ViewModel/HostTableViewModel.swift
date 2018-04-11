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
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var numberOfRows: Int {
        return cellViewModels.count
    }
    var reloadTableView: (() -> Void)?
    var reloadRowAtIndexPath: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?
    var displayErrorAlert: ((String) -> Void)?

    init(apiService: APIService) {
        self.apiService = apiService
        initModel(withURL: HostList.urlString)
    }

    func getCellViewModel(forIndexPath indexPath: IndexPath) -> HostCellViewModel {
        return cellViewModels[indexPath.row]
    }

    fileprivate func initModel(withURL urlString: String) {
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
            HostCellViewModel(hostNameText: $0.name, urlText: $0.url, imageUrl: $0.icon)
        }
    }
}
