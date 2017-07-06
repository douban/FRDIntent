//
//  FRDURLRoutes.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/31/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit

/**
 FRDURLRoutes is a way to manage URL routes and invoke them from a URL.
 */
public class FRDURLRoutes: NSObject {

  /// Singleton instance of URLRoutes.
  public static let sharedInstance = FRDURLRoutes()

  private let routeManager = RouteManager.sharedInstance

  /**
   Registers a url for calling handler blocks.
   
   - parameter url: The url to be registered.
   - parameter handler: The handler to be registered, and will be called while routed.
   
   - returns: True if it registers successfully.
   */
  @discardableResult public func register(_ url: URL, handler: @escaping URLRoutesHandler) -> Bool {
    return routeManager.register(url, handler: handler)
  }

  /**
   Routes a URL, calling handler blocks (for patterns that match URL) until one returns YES.
   
   - parameter url: The url for search.

   - returns: True if handler block is found and called, false if handler block is not found.
   */
  public func route(_ url: URL) -> Bool {
    let (params, handler) = routeManager.searchHandler(for: url)
    if let handler = handler {
      handler(params)
      return true
    }
    return false
  }

  /**
   Tells if FRDURLRoutes can route a given url.

   - parameter url: The url for search.

   - returns: True if a handler can be found for the given url.
   */
  public func canRoute(_ url: URL) -> Bool {
    let (_, handler) = routeManager.searchHandler(for: url)
    return handler != nil
  }
}

public extension FRDURLRoutes {

  /**
   Registers a url for calling handler blocks.

   - parameter url: The url to be registered.
   - parameter clazz: The UIViewController's class to be registered, 
                      and this view controller will be started while routed.
   
   - returns: True if it registers successfully.
   */
  @discardableResult public func register(_ url: URL, clazz: FRDIntentReceivable.Type) -> Bool {

    let resultForIntent = FRDControllerManager.sharedInstance.register(url, clazz: clazz)
    let resultForRoute = register(url) { (params: [String: Any]) in
      guard let url = params[FRDRouteParameters.URLRouteURL] as? URL else { return }
      let intent = FRDIntent(url: url)
      if let topViewController = UIApplication.topViewController() {
        FRDControllerManager.sharedInstance.startController(from: topViewController, withIntent: intent)
      }
    }

    return (resultForRoute && resultForIntent)
  }

  /**
   Registers with a plist file.

   - parameter path: The plistFile path.

   - returns: True if it registers successfully.
   */
  @discardableResult public func register(contentsOfFile path: String) -> Bool {

    guard let registers: NSDictionary = NSDictionary(contentsOfFile: path) else {
      return false
    }

    for (url, className) in registers {

      guard let url = url as? String, let className = className as? String else {
        return false
      }

      if let clazz = NSClassFromString(className) as? FRDIntentReceivable.Type {
        let result = register(URL(string: url)!, clazz: clazz)
        if !result {
          return false
        }
      }

    }
    return true
  }

}

fileprivate extension UIApplication {

  class func topViewController(from base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController)
    -> UIViewController? {

    if let nav = base as? UINavigationController {
      return topViewController(from: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return topViewController(from: selected)
      }
    }
    if let presented = base?.presentedViewController {
      return topViewController(from: presented)
    }
    return base

  }

}
