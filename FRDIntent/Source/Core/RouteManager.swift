//
//  RouteManager.swfit
//  FRDIntent
//
//  Created by GUO Lin on 8/30/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import Foundation

struct RouteParameters {

  static let URLRouteURL = "URLRouteURL"

}

/**
 RouteManager offer the public operation interface of route path search tree.

 For example, If we register three urls into the search tree:
 
 /user/:userId/profile
 /story/:storyId
 /subject/:subjectId

 We will find that the tree will be like this:

             "/"
         /    |      \
    "user" "story" "subject"
       /      |        \
  ":userId" ":storId" ":subjectId"
     /
 "profile"

 Every node have two values: clazz and handler.

 */
class RouteManager {

  static let sharedInstance = RouteManager()

  typealias URLRouterHandler = ([String: Any]) -> ()

  typealias RoutePathNodeValueType = (IntentReceivable.Type?, URLRouterHandler?)

  private var routes = RoutePathNode<RoutePathNodeValueType>(path: "/")

  /**
   Regiser url for save the value in the route path search tree.
   
   - parameter url: The path for search the storage position.
   - parameter value: The value to be saved.
   */
  func register(url url: NSURL, clazz: IntentReceivable.Type) -> Bool {

    guard let paths = url.pathComponentsWithoutSlash else {
      return false
    }

    let (_, node) = routes.search(paths)
    if node.path == paths.last {
      // find it, update
      let handler: URLRouterHandler?
      if let (_, oldHandler) = node.value {
        handler =  oldHandler
      } else {
        handler = nil
      }
      node.value = (clazz, handler)


    } else {
      // not find it, insert
      routes.insert(paths, value: (clazz, nil))
    }

    return true
  }

  func register(url url: NSURL, handler: ([String: Any]) -> ()) -> Bool {

    guard let paths = url.pathComponentsWithoutSlash else {
      return false
    }

    let (_, node) = routes.search(paths)
    if node.path == paths.last {
      // find it, update
      let clazz: IntentReceivable.Type?
      if let (oldClazz, _) = node.value {
        clazz =  oldClazz
      } else {
        clazz = nil
      }
      node.value = (clazz, handler)


    } else {
      // not find it, insert
      routes.insert(paths, value: (nil, handler))
    }

    return true

  }

  /**
   Search the value in in the route path search tree whith the url.

   - parameter url: The path for search the storage position.
   - returns: A tuple with parameters and value in the node searched.
   */
  func searchController(url url: NSURL) -> ([String: Any], IntentReceivable.Type?) {
    let (params, value) = search(url: url)

    if let (clazz, _) = value {
      return (params, clazz)
    } else {
      return (params, nil)
    }
  }


  func searchHandler(url url: NSURL) -> ([String: Any], (([String: Any]) -> ())?) {
    let (params, value) = search(url: url)

    if let (_, handler) = value {
      return (params, handler)
    } else {
      return (params, nil)
    }
  }

  private func search(url url: NSURL) -> ([String: Any], RoutePathNodeValueType?) {

    guard let paths = url.pathComponentsWithoutSlash else {
      return ([String: Any](), nil)
    }

    var (params, node) = routes.search(paths)

    decorateParams(&params, url: url)

    params.updateValue(url, forKey: RouteParameters.URLRouteURL)

    return (params, node.value)
  }

  private func decorateParams(inout params: [String: Any], url: NSURL) {

    // Add url to params
    params.updateValue(url, forKey: RouteParameters.URLRouteURL)

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
  }

}


// MARK: Private Data Structure

/**
 RoutePathNode is the data structure presenting a route path search tree node.
 */
private class RoutePathNode<T> {

  var path: String

  var value: T?

  var children: [String: RoutePathNode<T>]?

  init(path: String, value: T?, children: [String: RoutePathNode]?) {
    self.path = path
    self.value = value
    self.children = children
  }

  convenience init(path: String) {
    self.init(path: path, value: nil, children: nil)
  }

  convenience init(path: String, value: T) {
    self.init(path: path, value: value, children: nil)
  }


  var isPlaceHolder: Bool {
    return path.hasPrefix(":")
  }

  var placeHolderName: String? {
    if isPlaceHolder {
      let index = path.startIndex.advancedBy(1)
      return path.substringFromIndex(index)
    }
    return nil
  }

  var placeHolderChild: RoutePathNode? {

    guard let children = children else {
      return nil
    }

    for (_, node) in children {
      if node.isPlaceHolder {
        return node
      }
    }

    return nil
  }

  func addChildPathNode(node: RoutePathNode) {
    if let _ = children {
      children?[node.path] = node
    } else {
      children = [String: RoutePathNode]()
      children?[node.path] = node
    }
  }

  func containsChildPathNode(childNodePath: String) -> Bool {
    if let children = children {
      return children[childNodePath] != nil
    }
    return false
  }

  var description: String {
    return "path:\(self.path), value:\(self.value), children:\(self.children)"
  }

}

// MARK: Operations of Route Path Search Tree

extension RoutePathNode {

  func insert(paths: [String], value: T) -> RoutePathNode? {

    var node = self
    for path in paths {

      let childNode: RoutePathNode
      if node.containsChildPathNode(path) {
        childNode = node.children![path]!
      } else {
        childNode = RoutePathNode(path: path, value: value)
        node.addChildPathNode(childNode)
      }

      node = childNode

    }

    node.value = value
    return node

  }

  func search(paths: [String]) -> ([String: Any], RoutePathNode) {

    var params = [String: Any]()

    var node = self
    for path in paths {

      if node.containsChildPathNode(path) {
        node = node.children![path]!

      } else if let placeHolderChild = node.placeHolderChild {

        let placeHolderName = placeHolderChild.placeHolderName!
        params[placeHolderName] = path
        node = placeHolderChild
      }
      
    }

    return (params, node)
  }

}


// MARK: Private Helper Methods

private extension Array where Element: Equatable {

  mutating func removeObject(object: Element) {
    if let index = self.indexOf(object) {
      self.removeAtIndex(index)
    }
  }

}

private extension NSURL {

  var pathComponentsWithoutSlash: [String]? {
    guard let _ = pathComponents else {
      return nil
    }

    var array = pathComponents!
    array.removeObject("/")
    return array
  }

  var queryItems: [NSURLQueryItem]? {
    return NSURLComponents(URL: self, resolvingAgainstBaseURL: false)?.queryItems
  }

}

