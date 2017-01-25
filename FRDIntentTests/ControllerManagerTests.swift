//
//  FRDControllerManagerTests.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/30/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import XCTest
@testable import FRDIntent

class FRDControllerManagerTests: XCTestCase {

  func testNormalSearch() {

    let controllerManager = FRDControllerManager.sharedInstance
    controllerManager.register(URL(string: "/user/:userId")!, clazz: MockUserViewController.self)
    controllerManager.register(URL(string: "/story/:storyId")!, clazz: MockStoryViewController.self)
    controllerManager.register(URL(string: "/user/:userId/profile")!, clazz: MockProfileViewController.self)
  }

}


