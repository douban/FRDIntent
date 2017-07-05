//
//  RouteManager.swfit
//  FRDIntent
//
//  Created by GUO Lin on 8/30/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import Foundation

/**
 RouteManager offers the public operation interface of route path search tree.

 We maintains two register systems in one trie tree for saving space.
 Every tree node's value is a tuple (clazz, handler). 
 The clazz is for FRDIntent's register.
 The handler is for URLRoute's register.
 */
class RouteManager {

  static let sharedInstance = RouteManager()
  fileprivate var routes = Trie<RoutePathNodeValueType>()

  // MARK: - Register

  /**
   Register url for save the clazz in the routes.
   
   - parameter url: The path for search the storage position.
   - parameter clazz: The clazz to be saved.
   */
  @discardableResult func register(_ url: URL, clazz: FRDIntentReceivable.Type) -> Bool {

    if let (_, handler) = routes.search(url) {
      routes.insert(url, withValue: (clazz, handler))
    } else {
      // not find it, insert
      routes.insert(url, withValue: (clazz, nil))
    }

    return true
  }

  /**
   Register url for save the handler in the routes.

   - parameter url: The path for search the storage position.
   - parameter hanlder: The handler to be saved.
  */
  @discardableResult func register(_ url: URL, handler: @escaping URLRoutesHandler) -> Bool {

    if let (clazz, _) = routes.search(url) {
      routes.insert(url, withValue: (clazz, handler))
    } else {
      // not find it, insert
      routes.insert(url, withValue: (nil, handler))
    }

    return true
  }

  // MARK: - Search

  /**
   Search the controller in in the routes whith the url.

   - parameter url: The url for search the clazz.

   - returns: A tuple with parameters and clazz.
   */
  func searchController(for url: URL) -> ([String: Any], FRDIntentReceivable.Type?) {
    let params = extractParameters(from: url)

    if let (clazz, _) = routes.searchNearestMatchedValue(with: url) {
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
  func searchHandler(for url: URL) -> ([String: Any], URLRoutesHandler?) {
    let params = extractParameters(from: url)

    if let (_, handler) = routes.searchNearestMatchedValue(with: url) {
      return (params, handler)
    } else {
      return (params, nil)
    }
  }

  // MARK: - Private Methods
  private func extractParameters(from url: URL) -> [String: Any] {

    // Extract placeholder parameters
    var params = routes.matchedPattern(for: url)

    // Add url to params
    params.updateValue(url, forKey: FRDRouteParameters.URLRouteURL)

    // Add queries to params
    if let queryItems = url.queryItems {
      for queryItem in queryItems {
        if let value = queryItem.value {
          params.updateValue(value, forKey: queryItem.name)
        }
      }
    }

    // Add fragment to params
    if let fragment = url.fragment {
      params.updateValue(fragment, forKey: "fragment")
    }

    return params
  }

}
