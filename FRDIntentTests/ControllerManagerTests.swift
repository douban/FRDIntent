//
//  ControllerManagerTests.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/30/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import XCTest
@testable import FRDIntent

class ControllerManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test() {
      let controllerManager = ControllerManager.sharedInstance
      controllerManager.registerController(NSURL(string: "douban://douban.com/frodo/firstViewController")!, clazz: MockUserController.self)


    }


}
