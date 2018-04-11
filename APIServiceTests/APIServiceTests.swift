//
//  APIServiceTests.swift
//  APIServiceTests
//
//  Created by Javid Sheikh on 11/04/2018.
//  Copyright © 2018 Javid Sheikh. All rights reserved.
//

import XCTest
@testable import PingLatency

class APIServiceTests: XCTestCase {

    var sut: APIService!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = APIService(session: URLSession.shared)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }

    func testFetchJSONAndInitHostList() {
        let urlString = "https://gist.githubusercontent.com/anonymous/290132e587b77155eebe44630fcd12cb/raw/777e85227d0c1c16e466475bb438e0807900155c/sk_hosts"
        weak var promise = expectation(description: "Completion handler called")
        var result: Result<Any>?

        sut.fetchHostList(withURL: urlString, completion: { res in
            result = res
            promise?.fulfill()
        })

        waitForExpectations(timeout: 5.0, handler: nil)

        guard let res = result else { return XCTFail() }
        switch res {
        case .success(let hostList):
            XCTAssert((hostList as Any) is [Host], "Host list init from json response")
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    
}
