//
//  URLRoutesTests.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/31/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import XCTest
@testable import FRDIntent

class URLRoutesTests: XCTestCase {

  func testURLRoutes() {
    let router = FRDURLRoutes.sharedInstance

    router.register(URL(string: "/user/:userId")!) { (params: [String: Any]) in
      XCTAssert(params["userId"] as! String == "12", "userId is 12")
      XCTAssert(params[FRDIntentParameters.URL] as? NSURL == NSURL(string:  "/user/12"), "")
    }

    _ = router.route(URL(string: "/user/12")!)

    router.register(URL(string: "/story/:storyId")!) { (params: [String: Any]) in
      XCTAssert(params["storyId"] as! String == "21", "userId is 12")
      XCTAssert(params["key1"] as! String == "value1", "key1 is value1")
      XCTAssert(params["key2"] as! String == "value2", "key2 is value2")
      XCTAssert(params["fragment"] as! String == "ref", "fragment is ref")
    }
    _ = router.route(URL(string: "/story/21/?key1=value1&key2=value2#ref")!)

  }

  func testNearestNoMatch() {

    let router = FRDURLRoutes.sharedInstance

    router.register(URL(string: "/a/b/c/e")!) { (params: [String: Any]) in
      XCTAssert(params[FRDIntentParameters.URL] as? NSURL == NSURL(string:  "/a/b/c/e"), "")
    }

    router.register(URL(string: "/a/b")!) { (params: [String: Any]) in
      XCTAssert(params[FRDIntentParameters.URL] as? NSURL == NSURL(string:  "/a/b/c"), "")
    }

    let result = router.route(URL(string: "/a/b/c")!)
    XCTAssert(result, "can rout")
  }


  func testPlaceholder() {

    let router = FRDURLRoutes.sharedInstance

    router.register(URL(string: "/a/x/c/d")!) { (params: [String: Any]) in
      XCTAssert(params[FRDIntentParameters.URL] as? NSURL == NSURL(string:  "/a/x/c/d"), "")
    }

    router.register(URL(string: "/a/:b/c")!) { (params: [String: Any]) in
      XCTAssert(params[FRDIntentParameters.URL] as? NSURL == NSURL(string:  "/a/x/c"), "")
    }

    let result = router.route(URL(string: "/a/x/c")!)
    XCTAssert(result, "/a/x/c can route by pattern /a/:b/c")
  }



  func testCanRoute() {
    let router = FRDURLRoutes.sharedInstance

    router.register(URL(string: "/aaa/ddd")!) { (params) in

    }
    XCTAssert(router.canRoute(URL(string: "/aaa/ddd")!))
    XCTAssertFalse(router.canRoute(URL(string: "/aaa/dddd")!))
  }

}
