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
  public func register(url: URL, handler: @escaping URLRoutesHandler) -> Bool {
    return routeManager.register(url: url, handler: handler)
  }

  /**
   Routes a URL, calling handler blocks (for patterns that match URL) until one returns YES.
   
   - parameter url: The url for search.

   - returns: True if handler block is found and called, false if handler block is not found.
   */
  public func route(url: URL) -> Bool {
    let (params ,handler) = routeManager.searchHandler(url: url)
    if let handler = handler {
      handler(params)
      return true
    }
    return false
  }

}

public extension FRDURLRoutes {

  /**
   Registers a url for calling handler blocks.

   - parameter url: The url to be registered.
   - parameter clazz: The UIViewController's class to be registered, and this view controller will be started while routed.
   
   - returns: True if it registers successfully.
   */
  public func register(url: URL, clazz: FRDIntentReceivable.Type) -> Bool {

    let resultForIntent = FRDControllerManager.sharedInstance.register(url: url, clazz: clazz)
    let resultForRoute = register(url: url) { (params: URLRoutesHandlerParam) in
      let intent = FRDIntent(url: params[FRDRouteParameters.URLRouteURL] as! URL)
      if let topViewController = UIApplication.topViewController() {
        FRDControllerManager.sharedInstance.startController(source: topViewController, intent: intent)
      }
    }

    return (resultForRoute && resultForIntent)
  }

  /**
   Registers with a plist file.

   - parameter plistFile: The plistFile path.

   - returns: True if it registers successfully.
   */
  public func registers(plistFile: String) -> Bool {

    guard let registers: NSDictionary = NSDictionary(contentsOfFile: plistFile) else {
      return false
    }

    for (url, className) in registers {

      guard let url = url as? String, let className = className as? String else {
        return false
      }

      if let clazz = NSClassFromString(className) as? FRDIntentReceivable.Type {
        let result = register(url: URL(string: url)!, clazz: clazz)
        if !result {
          return false
        }
      }

    }
    return true
  }

}

fileprivate extension UIApplication {

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
