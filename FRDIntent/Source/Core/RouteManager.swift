//
//  RouteManager.swfit
//  FRDIntent
//
//  Created by GUO Lin on 8/30/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import Foundation

/**
 RouteManager offer the public operation interface of route path search tree.
 */
class RouteManager {

  static let sharedInstance = RouteManager()
  fileprivate var routes = Trie<RoutePathNodeValueType>()

  // MARK: - Register

  /**
   Regiser url for save the clazz in the routes.
   
   - parameter url: The path for search the storage position.
   - parameter clazz: The clazz to be saved.
   */
  func register(url: URL, clazz: FRDIntentReceivable.Type) -> Bool {

    if let (_, handler) = routes.search(url: url) {
      routes.insert(url: url, value: (clazz, handler))
    } else {
      // not find it, insert
      routes.insert(url: url, value: (clazz, nil))
    }

    return true
  }

  /**
   Regiser url for save the handler in the routes.

   - parameter url: The path for search the storage position.
   - parameter hanlder: The handler to be saved.
  */
  func register(url: URL, handler: @escaping URLRoutesHandler) -> Bool {

    if let (clazz, _) = routes.search(url: url) {
      routes.insert(url: url, value: (clazz, handler))
    } else {
      // not find it, insert
      routes.insert(url: url, value: (nil, handler))
    }

    return true
  }

  // MARK: - Search

  /**
   Search the controller in in the routes whith the url.

   - parameter url: The url for search the clazz.

   - returns: A tuple with parameters and clazz.
   */
  func searchController(url: URL) -> ([String: AnyObject], FRDIntentReceivable.Type?) {
    let params = extractParameters(url: url)

    if let (clazz, _) = routes.searchWithNearestMatch(url: url) {
      return (params, clazz)
    } else {
      return (params, nil)
    }

  }

  /**
   Search the handler in in the route whith the url.

   - parameter url: The url for search the handler.

   - returns: A tuple with parameters and handler.
   */
  func searchHandler(url: URL) -> ([String: AnyObject], URLRoutesHandler?) {
    let params = extractParameters(url: url)

    if let (_, handler) = routes.searchWithNearestMatch(url: url) {
      return (params, handler)
    } else {
      return (params, nil)
    }
  }

  // MARK: - Private Methods
  private func extractParameters(url: URL) -> [String: AnyObject] {

    // Extract placeholder parameters
    var params = routes.matchUrlPattern(url: url)

    // Add url to params
    params.updateValue(url as AnyObject, forKey: FRDRouteParameters.URLRouteURL)

    // Add queries to params
    if let queryItems = url.queryItems {
      for queryItem in queryItems {
        if let value = queryItem.value {
          params.updateValue(value as AnyObject, forKey: queryItem.name)
        }
      }
    }

    // Add fragment to params
    if let fragment = url.fragment {
      params.updateValue(fragment as AnyObject, forKey: "fragment")
    }

    return params
  }

}

