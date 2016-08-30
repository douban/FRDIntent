//
//  RouteSearchTests.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/30/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import XCTest
@testable import FRDIntent

class RouteSearch: XCTestCase {

  func testNormalSearch() {

    let routeManager = RouteManager()

    routeManager.registerRoute(uri: NSURL(string: "douban://www.douban.com/user/:userId")!, clazz: MockUserController.self)
    routeManager.registerRoute(uri: NSURL(string: "douban://www.douban.com/user/:userId/profile")!, clazz: MockProfileController.self)
    routeManager.registerRoute(uri: NSURL(string: "douban://www.douban.com/user/:userId/story/:storyId")!, clazz: MockStoryController.self)
    routeManager.registerRoute(uri: NSURL(string: "douban://www.douban.com/story/:storyId")!, clazz: MockStoryController.self)


    let (parameter, clazz) = routeManager.searchRoute(uri: NSURL(string: "douban://www.douban.com/user/12")!)
    XCTAssert(parameter["userId"] as! String == "12", "userId is 12")
    XCTAssert(clazz == MockUserController.self, "clazz is Mock")

    let (parameter2, clazz2) = routeManager.searchRoute(uri: NSURL(string: "douban://www.douban.com/user/123/profile")!)
    XCTAssert(parameter2["userId"] as! String == "123", "userId is 123")
    XCTAssert(clazz2 == MockProfileController.self, "clazz is Mock")

    let (parameter3, clazz3) = routeManager.searchRoute(uri: NSURL(string: "douban://www.douban.com/user/123/story/1234")!)
    XCTAssert(parameter3["userId"] as! String == "123", "userId is 123")
    XCTAssert(parameter3["storyId"] as! String == "1234", "storyId is 1234")
    XCTAssert(clazz3 == MockStoryController.self, "clazz is Mock")

    let (parameter4, clazz4) = routeManager.searchRoute(uri: NSURL(string: "douban://www.douban.com/story/1234/")!)
    XCTAssert(parameter4["storyId"] as! String == "1234", "storyId is 1234")
    XCTAssert(clazz4 == MockStoryController.self, "clazz is Mock")

  }

  func testNoMatchSearch() {
    let routeManager = RouteManager()
    routeManager.registerRoute(uri: NSURL(string: "douban://www.douban.com/story/:storyId")!, clazz: MockStoryController.self)
    routeManager.registerRoute(uri: NSURL(string: "douban://www.douban.com/normal/")!, clazz: MockUserController.self)

    let (parameter5, clazz5) = routeManager.searchRoute(uri: NSURL(string: "douban://www.douban.com/story/12345/error")!)
    XCTAssert(parameter5["storyId"] as! String == "12345", "storyId is 1234")
    XCTAssert(clazz5 == MockStoryController.self, "clazz is Mock")

    let (parameter6, clazz6) = routeManager.searchRoute(uri: NSURL(string: "douban://www.douban.com/error")!)
    XCTAssert(parameter6.isEmpty == true, "parameter is empty")
    XCTAssert(clazz6 == nil, "clazz is nil")
  }

  func testQueryFragmentParameter() {

    let routeManager = RouteManager()
    routeManager.registerRoute(uri: NSURL(string: "douban://www.douban.com/parameters")!, clazz: MockStoryController.self)

    let (parameter7, clazz7) = routeManager.searchRoute(uri: NSURL(string: "douban://www.douban.com/parameters?key1=value1&key2=value2#ref")!)
    XCTAssert(parameter7["key1"] as! String == "value1", "parameter key1 is value1")
    XCTAssert(parameter7["key2"] as! String == "value2", "parameter key2 is value2")
    XCTAssert(parameter7["fragment"] as! String == "ref", "parameter fragment is ref")
    XCTAssert(clazz7 == MockStoryController.self, "clazz is nil")
  }

}

