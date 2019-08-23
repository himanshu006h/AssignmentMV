//
//  MVServiceParsingTest.swift
//  AssignmentMVTests
//
//  Created by Himanshu Saraswat on 23/08/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import XCTest
@testable import AssignmentMV


class MVServiceParsingTest: XCTestCase {
    
    struct Constant {
        static let MindVList = "MindVList"
        static let json = "json"
        static let linkedURL = "http://pastebin.com/raw/wgkJgazE"
    }
    
    let decoder = JSONDecoder()
    var mvResponse: [VM_Base]!
    
    override func setUp() {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: Constant.MindVList, ofType: Constant.json)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        mvResponse = try! decoder.decode([VM_Base].self, from: data!)    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNumberOfNews() {
        let expectedRows = 10        
        XCTAssertEqual(mvResponse.count, expectedRows)
    }
}
