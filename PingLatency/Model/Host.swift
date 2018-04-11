//
//  Host.swift
//  PingLatency
//
//  Created by Javid Sheikh on 11/04/2018.
//  Copyright © 2018 Javid Sheikh. All rights reserved.
//

import Foundation

struct Host: Codable {
    var name: String
    var url: String
    var icon: String
    var latency: Double?
}

class HostList {
    static let urlString = "https://gist.githubusercontent.com/anonymous/290132e587b77155eebe44630fcd12cb/raw/777e85227d0c1c16e466475bb438e0807900155c/sk_hosts"
}
