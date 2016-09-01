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

  func testNormalSearch() {

    let controllerManager = ControllerManager.sharedInstance
    controllerManager.register(url: NSURL(string: "frdintent://frdintent.com/user/:userId")!, clazz: MockUserViewController.self)
    controllerManager.register(url: NSURL(string: "frdintent://frdintent.com/story/:storyId")!, clazz: MockStoryViewController.self)
    controllerManager.register(url: NSURL(string: "frdintent://frdintent.com/user/:userId/profile")!, clazz: MockProfileViewController.self)

  }

}


