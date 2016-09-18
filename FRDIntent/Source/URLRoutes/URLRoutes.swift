//
//  URLRoutes.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/31/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit

/**
 URLRoutes is a way to manage URL routes and invoke them from a URL.
 */
open class URLRoutes: NSObject {

  /// The key to get the url from parameters of block handler.
  open static let URLRoutesURL = RouteParameters.URLRouteURL

  /// Singleton instance of URLRoutes.
  open static let sharedInstance = URLRoutes()

  /// The type of block handler to be registered.
  public typealias URLRoutesHandler = ([String: AnyObject]) -> ()

  private let routeManager = RouteManager.sharedInstance

  /**
   Registers a url for calling handler blocks.
   
   - parameter url: The url to be registered.
   - parameter handler: The handler to be registered, and will be called while routed.
   
   - returns: True if it registers successfully.
   */
  open func register(url: URL, handler: @escaping URLRoutesHandler) -> Bool {
    return routeManager.register(url: url, handler: handler)
  }

  /**
   Routes a URL, calling handler blocks (for patterns that match URL) until one returns YES.
   
   - parameter url: The url for search.

   - returns: True if handler block is found and called, false if handler block is not found.
   */
  open func route(url: URL) -> Bool {
    let (params ,handler) = routeManager.searchHandler(url: url)
    if let handler = handler {
      handler(params)
      return true
    }
    return false
  }

}

public extension URLRoutes {

  /**
   Registers a url for calling handler blocks.

   - parameter url: The url to be registered.
   - parameter clazz: The UIViewController's class to be registered, and this view controller will be started while routed.
   
   - returns: True if it registers successfully.
   */
  public func register(url: URL, clazz: IntentReceivable.Type) -> Bool {

    let resultForIntent = ControllerManager.sharedInstance.register(url: url, clazz: clazz)
    let resultForRoute = register(url: url) { (params: [String: AnyObject]) in
      let intent = Intent(url: params[URLRoutes.URLRoutesURL] as! URL)
      if let topViewController = UIApplication.topViewController() {
        ControllerManager.sharedInstance.startController(source: topViewController, intent: intent)
      }
    }

    return (resultForRoute && resultForIntent)
  }

}

private extension UIApplication {

  class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

    if let nav = base as? UINavigationController {
      return topViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return topViewController(base: selected)
      }
    }
    if let presented = base?.presentedViewController {
      return topViewController(base: presented)
    }
    return base

  }
  
}
