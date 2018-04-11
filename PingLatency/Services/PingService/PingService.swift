//
//  PingService.swift
//  PingLatency
//
//  Created by Javid Sheikh on 11/04/2018.
//  Copyright © 2018 Javid Sheikh. All rights reserved.
//

import Foundation

public enum SimplePingError: Error {
    case unexpectedPacket
    case failedWithError(String)
}

class PingService: NSObject, SimplePingDelegate {

    typealias PingCompletionHandler = (Result<Double>) -> ()

    static let singleton = PingService()

    var pinger: SimplePing!
    var startTime: Date?
    lazy var aggregateLatency: Double = 0
    lazy var pingNumber: Int = 5
    var hostname: String?
    var resultCallback: PingCompletionHandler?

    static func pingHostName(_ hostname: String, pingNumber: Int = 5, completion: @escaping PingCompletionHandler) {
        singleton.pingHostName(hostname, pingNumber: pingNumber, completion: completion)
    }

    fileprivate func pingHostName(_ hostname: String, pingNumber: Int, completion: @escaping PingCompletionHandler) {
        self.pingNumber = pingNumber
        self.hostname = hostname
        resultCallback = completion
        ping(hostname)
    }

    private func ping(_ hostName: String) {
        pinger = SimplePing(hostName: hostName)
        pinger.delegate = self
        pinger.start()
    }

    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        pinger.send(with: nil)
    }

    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        pinger.stop()
        resultCallback?(Result.failure(SimplePingError.failedWithError(error.localizedDescription)))
    }

    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        pinger.stop()
        resultCallback?(Result.failure(SimplePingError.unexpectedPacket))
    }

    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        startTime = Date()
    }

    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        pinger.stop()
        let latency = Date().timeIntervalSince(startTime!) * 1000
        aggregateLatency += latency
        pingNumber -= 1
        if pingNumber > 0 {
            ping(hostname!)
        } else {
            resultCallback?(Result.success(aggregateLatency / 5))
        }
    }
}
