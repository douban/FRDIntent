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

  static let URLRouteURL = "URLRouteURL"

  static let sharedInstance = RouteManager()
  fileprivate var routes = Trie<RoutePathNodeValueType>()

  // MARK: - Register

  /**
   Register url for save the clazz in the routes.
   
   - parameter url: The path for search the storage position.
   - parameter clazz: The clazz to be saved.
   */
  @discardableResult func register(_ url: URL, clazz: FRDIntentReceivable.Type) -> Bool {
    if let node = routes.searchNodeWithoutMatchPlaceholder(with: url), let (_, handler) = node.value {
      node.value = (clazz, handler)
      return true
    }
    // not find it, insert
    return routes.insert((clazz, nil), with: url)
  }

  /**
   Register url for save the handler in the routes.

   - parameter url: The path for search the storage position.
   - parameter hanlder: The handler to be saved.
  */
  @discardableResult func register(_ url: URL, handler: @escaping URLRoutesHandler) -> Bool {
    if let node = routes.searchNodeWithoutMatchPlaceholder(with: url), let (clazz, _) = node.value {
      node.value = (clazz, handler)
      return true
    }
      // not find it, insert
    return routes.insert((nil, handler), with: url)
  }

  // MARK: - Unregister

  /**
   Unregister url

   - parameter url: The url to be unregistered
   */
  func unregisterController(with url: URL) {
    guard let node = routes.searchNodeWithoutMatchPlaceholder(with: url) else { return }
    if let (_, handler) = node.value {
      if handler == nil {
        node.value = nil
        routes.remove(node)
      } else {
        node.value = (nil, handler)
      }
    }
  }

  func unregisterHandler(with url: URL) {
    guard let node = routes.searchNodeWithoutMatchPlaceholder(with: url) else { return }
    if let (clazz, _) = node.value {
      if clazz == nil {
        node.value = nil
        routes.remove(node)
      } else {
        node.value = (clazz, nil)
      }
    }
  }

  /**
   Check the url is registered or not.

   - parameter url: The url to be checked.
   */
  func hasRegisteredController(with url: URL) -> Bool {
    guard let node = routes.searchNodeWithtMatchPlaceholder(with: url) else { return false }
    if let (clazz, _) = node.value {
      if clazz == nil {
        return false
      }
    }
    return true
  }

  func hasRegisteredHandler(with url: URL) -> Bool {
    guard let node = routes.searchNodeWithtMatchPlaceholder(with: url) else { return false }
    if let (_, handler) = node.value {
      if handler == nil {
        return false
      }
    }
    return true
  }

  // MARK: - Search

  /**
   Search the controller in in the routes whith the url.

   - parameter url: The url for search the clazz.

   - returns: A tuple with parameters and clazz.
   */
  func searchController(with url: URL) -> ([String: Any], FRDIntentReceivable.Type?) {
    let params = extractParameters(from: url)

    if let (clazz, _) = routes.search(with: url) {
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
  func searchHandler(with url: URL) -> ([String: Any], URLRoutesHandler?) {
    let params = extractParameters(from: url)

    if let (_, handler) = routes.search(with: url) {
      return (params, handler)
    } else {
      return (params, nil)
    }
  }

  // MARK: - Private Methods
  private func extractParameters(from url: URL) -> [String: Any] {

    // Extract placeholder parameters
    var params = routes.extractMatchedPattern(from: url)

    // Add url to params
    params.updateValue(url, forKey: RouteManager.URLRouteURL)

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
