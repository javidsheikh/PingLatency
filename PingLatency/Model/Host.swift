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
