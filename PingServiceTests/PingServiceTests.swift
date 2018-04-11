//
//  PingServiceTests.swift
//  PingServiceTests
//
//  Created by Javid Sheikh on 11/04/2018.
//  Copyright © 2018 Javid Sheikh. All rights reserved.
//

import XCTest
@testable import PingLatency

class PingServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPingForValidHostName() {
        let hostName = "www.google.com"
        let promise = expectation(description: "Completion handler called")
        var result: Result<Double>?

        PingService.pingHostName(hostName) { res in
            result = res
            promise.fulfill()
        }

        waitForExpectations(timeout: 3.0, handler: nil)

        guard let res = result else { return XCTFail() }
        switch res {
        case .success(let latency):
            XCTAssert((latency as Any) is Double, "Latency fetched successfully as Double")
        case .failure:
            XCTFail("Unable to fetch latency")
        }
    }

    func testPingForInvalidHostName() {
        let hostName = "abcdefg"
        let promise = expectation(description: "Completion handler called")
        var result: Result<Double>?

        PingService.pingHostName(hostName) { res in
            result = res
            promise.fulfill()
        }

        waitForExpectations(timeout: 3.0, handler: nil)

        guard let res = result else { return XCTFail() }
        switch res {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssert((error as Any) is Error, "Error returned for invalid hostname")
        }
    }
    
}
