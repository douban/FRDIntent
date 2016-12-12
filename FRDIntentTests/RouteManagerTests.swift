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

  var routeManager: RouteManager!

  override func setUp() {
    super.setUp()
    routeManager = RouteManager()
  }

  func testNormalSearch() {

    let _ = routeManager.register(url: URL(string: "/user/:userId")!, clazz: MockUserViewController.self)
    let _ = routeManager.register(url: URL(string: "/user/:userId/profile")!, clazz: MockProfileViewController.self)
    let _ = routeManager.register(url: URL(string: "/user/:userId/story/:storyId")!, clazz: MockStoryViewController.self)
    let _ = routeManager.register(url: URL(string: "/story/:storyId")!, clazz: MockStoryViewController.self)

    let (params, clazz) = routeManager.searchController(url: URL(string: "/user/12")!)
    XCTAssert(params["userId"] as! String == "12", "userId is 12")
    XCTAssert(clazz == MockUserViewController.self, "mock is user")

    let (params2, value2) = routeManager.searchController(url: URL(string: "/user/123/profile")!)
    XCTAssert(params2["userId"] as! String == "123", "userId is 123")
    XCTAssert(value2 == MockProfileViewController.self, "value is profile")

    let (params3, value3) = routeManager.searchController(url: URL(string: "/user/123/story/1234")!)
    XCTAssert(params3["userId"] as! String == "123", "userId is 123")
    XCTAssert(params3["storyId"] as! String == "1234", "storyId is 1234")
    XCTAssert(value3 == MockStoryViewController.self, "value is story")

    let (params4, value4) = routeManager.searchController(url: URL(string: "/story/1234/")!)
    XCTAssert(params4["storyId"] as! String == "1234", "storyId is 1234")
    XCTAssert(value4 == MockStoryViewController.self, "value is story")

  }

  func testNoMatchSearch() {

    let handler1 = {(params: [String: AnyObject]) in

    }

    let _ = routeManager.register(url: URL(string: "/story/:storyId")!, handler: handler1)
    let _ = routeManager.register(url: URL(string: "/normal/")!, handler: handler1)

    let (params5, value5) = routeManager.searchHandler(url: URL(string: "/story/12345/error")!)
    XCTAssert(params5["storyId"] as! String == "12345", "storyId is 1234")
    XCTAssert(value5 != nil, "value is not nil")


    let (params6, value6) = routeManager.searchHandler(url: URL(string: "/error")!)
    XCTAssert(params6[FRDRouteParameters.URLRouteURL] as? URL == URL(string:  "/error"), "")
    XCTAssert(value6 == nil, "value is nil")
  }

  func testQueryFragmentParameter() {

    let _ = routeManager.register(url: URL(string: "/paramss")!, clazz: MockStoryViewController.self)

    let (params7, value7) = routeManager.searchController(url: URL(string: "/paramss?key1=value1&key2=value2#ref")!)
    XCTAssert(params7["key1"] as! String == "value1", "params key1 is value1")
    XCTAssert(params7["key2"] as! String == "value2", "params key2 is value2")
    XCTAssert(params7["fragment"] as! String == "ref", "params fragment is ref")
    XCTAssert(value7 == MockStoryViewController.self, "value is nil")
  }

}
