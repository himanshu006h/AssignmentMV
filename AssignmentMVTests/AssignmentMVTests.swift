//
//  AssignmentMVTests.swift
//  AssignmentMVTests
//
//  Created by Himanshu Saraswat on 20/08/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import XCTest
@testable import AssignmentMV

class AssignmentMVTests: XCTestCase {
    
    struct Constants {
        static let StatusCodeDict = "Status code : 200"
        static let completionHandlerMsg = "Call completes immediately by invoking completion handler"
        static let testURL = "http://pastebin.com/raw/wgkJgazE"
    }
    
    var sessionUnderTest : URLSession!
    
    override func setUp() {
        sessionUnderTest = URLSession(configuration : URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
    }
    
    func testValidCallToInfoAPIGetsStatusCode200() {
        guard let request = URL(string: Constants.testURL) else {
            return
        }

        let promise = expectation(description: Constants.StatusCodeDict)
        
        // when
        sessionUnderTest.dataTask(with: request) { (data, response, error) in
            // then
            if let error = error{
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else{
                    XCTFail("Status code = \(statusCode)")
                }
            }
            }.resume()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
