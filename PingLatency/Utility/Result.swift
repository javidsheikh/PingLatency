//
//  Result.swift
//  PingLatency
//
//  Created by Javid Sheikh on 11/04/2018.
//  Copyright © 2018 Javid Sheikh. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
