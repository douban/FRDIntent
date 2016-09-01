//
//  URLRouterTests.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/31/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import XCTest
@testable import FRDIntent

class URLRouterTests: XCTestCase {

  func testURLRouter() {
    let router = URLRouter.sharedInstance

    router.register(url: NSURL(string: "/user/:userId")!) { (params: [String: Any]) in
      XCTAssert(params["userId"] as! String == "12", "userId is 12")
      XCTAssert(params[URLRouter.URLRouterURL] as? NSURL == NSURL(string:  "/user/12"), "")
    }

    router.route(url: NSURL(string: "/user/12")!)

    router.register(url: NSURL(string: "/story/:storyId")!) { (params: [String: Any]) in
      XCTAssert(params["storyId"] as! String == "21", "userId is 12")
      XCTAssert(params["key1"] as! String == "value1", "key1 is value1")
      XCTAssert(params["key2"] as! String == "value2", "key2 is value2")
      XCTAssert(params["fragment"] as! String == "ref", "fragment is ref")
    }
    router.route(url: NSURL(string: "/story/21/?key1=value1&key2=value2#ref")!)

  }

}
