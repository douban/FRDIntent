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

  override func tearDown() {
    super.tearDown()
    routeManager = nil
  }

  func testNormalSearch() {

    routeManager.register(URL(string: "/user/:userId")!, clazz: MockUserViewController.self)
    routeManager.register(URL(string: "/user/:userId/profile")!, clazz: MockProfileViewController.self)
    routeManager.register(URL(string: "/user/:userId/story/:storyId")!, clazz: MockStoryViewController.self)
    routeManager.register(URL(string: "/story/:storyId")!, clazz: MockStoryViewController.self)

    let (params, clazz) = routeManager.searchController(with: URL(string: "/user/12")!)
    XCTAssert(params["userId"] as! String == "12", "userId is 12")
    XCTAssert(clazz == MockUserViewController.self, "mock is user")

    let (params2, value2) = routeManager.searchController(with: URL(string: "/user/123/profile")!)
    XCTAssert(params2["userId"] as! String == "123", "userId is 123")
    XCTAssert(value2 == MockProfileViewController.self, "value is profile")

    let (params3, value3) = routeManager.searchController(with: URL(string: "/user/123/story/1234")!)
    XCTAssert(params3["userId"] as! String == "123", "userId is 123")
    XCTAssert(params3["storyId"] as! String == "1234", "storyId is 1234")
    XCTAssert(value3 == MockStoryViewController.self, "value is story")

    let (params4, value4) = routeManager.searchController(with: URL(string: "/story/1234/")!)
    XCTAssert(params4["storyId"] as! String == "1234", "storyId is 1234")
    XCTAssert(value4 == MockStoryViewController.self, "value is story")

  }

  func testNoMatchSearch() {

    let handler1 = {(params: [String: Any]) in

    }

    routeManager.register(URL(string: "/story/:storyId")!, handler: handler1)
    routeManager.register(URL(string: "/normal/")!, handler: handler1)

    let (params5, value5) = routeManager.searchHandler(with: URL(string: "/story/12345/error")!)
    XCTAssert(value5 != nil, "value is not nil")
    XCTAssert(params5["storyId"] as! String == "12345", "storyId is 1234")

    let (params6, value6) = routeManager.searchHandler(with: URL(string: "/error")!)
    XCTAssert(params6[FRDIntentParameters.URL] as? URL == URL(string:  "/error"), "")
    XCTAssert(value6 == nil, "no match, value is nil")

    routeManager.register(URL(string: "/intent/paying")!, handler: handler1)

    let (params, value) = routeManager.searchHandler(with: URL(string: "/intent/profile")!)
    let url = params["URLRouteURL"] as! URL
    XCTAssert(url.absoluteString == "/intent/profile", "parent is return")
    XCTAssert(value == nil, "no match, value is nil")
  }

  func testNearestNoMatchSearch() {
    let handler1 = {(params: [String: Any]) in

    }

    routeManager.register(URL(string: "/intent/paying")!, handler: handler1)
    routeManager.register(URL(string: "/intent")!, handler: handler1)

    let (params, value) = routeManager.searchHandler(with: URL(string: "/intent/profile")!)
    let url = params["URLRouteURL"] as! URL
    XCTAssert(url.absoluteString == "/intent/profile", "parent is return")
    XCTAssert(value != nil, "match parent /intent, value is not nil")
  }

  func testQueryFragmentParameter() {

    routeManager.register(URL(string: "/paramss")!, clazz: MockStoryViewController.self)

    let (params7, value7) = routeManager.searchController(with: URL(string: "/paramss?key1=value1&key2=value2#ref")!)
    XCTAssert(params7["key1"] as! String == "value1", "params key1 is value1")
    XCTAssert(params7["key2"] as! String == "value2", "params key2 is value2")
    XCTAssert(params7["fragment"] as! String == "ref", "params fragment is ref")
    XCTAssert(value7 == MockStoryViewController.self, "value is nil")
  }

  func testRemoveURL() {
    let url = URL(string: "/param/to/:be/remove/:id")!
    routeManager.register(url, clazz: MockStoryViewController.self)
    let (_, value) = routeManager.searchController(with: url)
    XCTAssert(value != nil)
    routeManager.unregisterController(with: url)
    let (_, value2) = routeManager.searchController(with: url)
    XCTAssert(value2 == nil)
  }

  func testRemoveSamilarURL() {
    let url = URL(string: "/a/b")!
    routeManager.register(url, clazz: MockStoryViewController.self)
    let url2 = URL(string: "a/c")!
    routeManager.register(url2, clazz: MockStoryViewController.self)
    routeManager.unregisterController(with: url)
    let (_, value2) = routeManager.searchController(with: url2)
    XCTAssert(value2 != nil)
  }

  func testConflictWithPlaceholder() {

    let handler : URLRoutesHandler = { params in
      print("url: \(params[FRDIntentParameters.URL] as! String)")
    }

    let url = URL(string: "user/:id/reviews")!
    routeManager.register(url, clazz: MockUserViewController.self)

    let url2 = URL(string: "user/profile/reviews")!
    routeManager.register(url2, handler: handler)

    let (_, value2) = routeManager.searchHandler(with: url2)
    XCTAssert(value2 != nil)
  }

  func testInsertPlaceholder() {

    let url = URL(string: "user/:id/reviews")!
    let result1 = routeManager.register(url, clazz: MockUserViewController.self)
    XCTAssert(result1)

    let url2 = URL(string: "user/:number/reviews")!
    let result2 = routeManager.register(url2, clazz: MockStoryViewController.self)
    XCTAssert(result2 != true)
  }

}
