//
//  PysakkiKelloTests.swift
//  PysakkiKelloTests
//
//  Created by Mortti Aittokoski on 30.3.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import XCTest

class PysakkiKelloTests: XCTestCase {

    func testGetFormattedTime() {
        XCTAssertEqual(getFormattedTime(seconds: 500), "00:08")
        XCTAssertEqual(getFormattedTime(seconds: 10000), "02:46")
        XCTAssertEqual(getFormattedTime(seconds: 100), "00:01")
        XCTAssertEqual(getFormattedTime(seconds: 0), "00:00")
        XCTAssertEqual(getFormattedTime(seconds: 86340), "23:59")
        XCTAssertEqual(getFormattedTime(seconds: 86400), "00:00")
        XCTAssertEqual(getFormattedTime(seconds: 54059), "15:00")
        XCTAssertEqual(getFormattedTime(seconds: 60*60*24+60*5), "00:05")
    }

}
