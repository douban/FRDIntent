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
public class URLRouter: NSObject {

  /// The key to get the url from parameters of block handler.
  public static let URLRouterURL = RouteParameters.URLRouteURL

  /// Singleton instance of URLRouter.
  public static let sharedInstance = URLRouter()

  /// The type of block handler to be registered.
  public typealias URLRouterHandler = ([String: AnyObject]) -> ()

  private let routeManager = RouteManager.sharedInstance

  /**
   Registers a url for calling handler blocks.
   
   - parameter url: The url to be registered.
   - parameter handler: The handler to be registered, and will be called while routed.
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

   - parameter url: The url to be registered.
   - parameter clazz: The UIViewController's class to be registered, and this view controller will be started while routed.
   */
  public func register(url url: NSURL, clazz: IntentReceivable.Type) {

    ControllerManager.sharedInstance.register(url: url, clazz: clazz)
    register(url: url) { (params: [String: AnyObject]) in
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
