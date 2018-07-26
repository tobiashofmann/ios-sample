//
//  iOS_SampleTests.swift
//  iOS SampleTests
//
//  Created by Tobias Hofmann on 26.07.18.
//  Copyright © 2018 itsfullofstars. All rights reserved.
//

import XCTest
@testable import iOS_Sample

class iOS_SampleTests: XCTestCase {
    
    var sut: ViewController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "Home") as? ViewController else {
            XCTFail("cast error")
            return
        }
        sut = controller
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSum() {
        sut.viewDidLoad()

        let numberOne: Int = 1
        let numberTwo: Int = 13

        sut.doCalc(numberOne: numberOne, numberTwo: numberTwo)
        let result: Int = sut.getSum()

        XCTAssertTrue(result == 14)
    }
    
}
