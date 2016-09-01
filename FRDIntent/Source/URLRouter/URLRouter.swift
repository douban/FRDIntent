//
//  URLRouter.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/31/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit

/**
 URLRouter is a way to manage URL routes and invoke them from a URL.

 */
public class URLRouter {

  public static let URLRouterURL = RouteParameters.URLRouteURL

  public static let sharedInstance = URLRouter()

  public typealias URLRouterHandler = ([String: Any]) -> ()

  private let routeManager = RouteManager.sharedInstance

  /**
   Registers a url for calling handler blocks.
   
   - parameter url: The url for register.
   - parameter handler: The handler will be called when routing.
   */
  public func register(url url: NSURL, handler: URLRouterHandler) {
    routeManager.register(url: url, handler: handler)
  }

  /**
   Routes a URL, calling handler blocks (for patterns that match URL) until one returns YES.
   
   - parameter url: The url for search.

   - returns: True if handler block is found and called, false if handler block is not found.
   */
  public func route(url url: NSURL) -> Bool {
    let (params ,handler) = routeManager.searchHandler(url: url)
    if let handler = handler {
      handler(params)
      return true
    }
    return false
  }

}

public extension URLRouter {

  /**
   Registers a url for calling handler blocks.

   - parameter url:
   - parameter clazz:

   */
  public func register<C: UIViewController where C: IntentReceivable>(url url: NSURL, clazz: C.Type) {

    ControllerManager.sharedInstance.register(url: url, clazz: clazz)
    register(url: url) { (params: [String: Any]) in
      let intent = Intent(url: params[URLRouter.URLRouterURL] as! NSURL)
      if let topViewController = UIApplication.topViewController() {
        ControllerManager.sharedInstance.startController(source: topViewController, intent: intent)
      }
    }

  }

}

private extension UIApplication {

  class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {

    if let nav = base as? UINavigationController {
      return topViewController(nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return topViewController(selected)
      }
    }
    if let presented = base?.presentedViewController {
      return topViewController(presented)
    }
    return base

  }
  
}
