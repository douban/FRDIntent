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

  typealias URLRoutesHandler = ([String: AnyObject]) -> ()

  typealias RoutePathNodeValueType = (FRDIntentReceivable.Type?, URLRoutesHandler?)

  fileprivate var routes = RoutePathNode<RoutePathNodeValueType>(path: "/")

  /**
   Regiser url for save the value in the route path search tree.
   
   - parameter url: The path for search the storage position.
   - parameter value: The value to be saved.
   */
  func register(url: URL, clazz: FRDIntentReceivable.Type) -> Bool {

    guard let paths = url.pathComponentsWithoutSlash else {
      return false
    }

    let (_, node) = routes.search(paths: paths)
    if node.path == paths.last {
      // find it, update
      let handler: URLRoutesHandler?
      if let (_, oldHandler) = node.value {
        handler =  oldHandler
      } else {
        handler = nil
      }
      node.value = (clazz, handler)


    } else {
      // not find it, insert
      let _ = routes.insert(paths: paths, value: (clazz, nil))
    }

    return true
  }

  func register(url: URL, handler: @escaping ([String: AnyObject]) -> ()) -> Bool {

    guard let paths = url.pathComponentsWithoutSlash else {
      return false
    }

    let (_, node) = routes.search(paths: paths)
    if node.path == paths.last {
      // find it, update
      let clazz: FRDIntentReceivable.Type?
      if let (oldClazz, _) = node.value {
        clazz =  oldClazz
      } else {
        clazz = nil
      }
      node.value = (clazz, handler)

    } else {
      // not find it, insert
      let node = routes.insert(paths: paths, value: (nil, handler))
      guard let _ = node else {
        return false
      }
    }

    return true

  }

  /**
   Search the value in in the route path search tree whith the url.

   - parameter url: The path for search the storage position.
   - returns: A tuple with parameters and value in the node searched.
   */
  func searchController(url: URL) -> ([String: AnyObject], FRDIntentReceivable.Type?) {
    let (params, value) = search(url: url)

    if let (clazz, _) = value {
      return (params, clazz)
    } else {
      return (params, nil)
    }
  }


  func searchHandler(url: URL) -> ([String: AnyObject], (([String: AnyObject]) -> ())?) {
    let (params, value) = search(url: url)

    if let (_, handler) = value {
      return (params, handler)
    } else {
      return (params, nil)
    }
  }

  private func search(url: URL) -> ([String: AnyObject], RoutePathNodeValueType?) {

    guard let paths = url.pathComponentsWithoutSlash else {
      return ([String: AnyObject](), nil)
    }

    var (params, node) = routes.search(paths: paths)

    decorate(params: &params, url: url)

    params.updateValue(url as AnyObject, forKey: FRDRouteParameters.URLRouteURL)

    return (params, node.value)
  }

  private func decorate(params: inout [String: AnyObject], url: URL) {

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
      let index = path.characters.index(path.startIndex, offsetBy: 1)
      return path.substring(from: index)
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

  func add(childNode node: RoutePathNode) {
    if let _ = children {
      children?[node.path] = node
    } else {
      children = [String: RoutePathNode]()
      children?[node.path] = node
    }
  }

  func contain(childNodePath: String) -> Bool {
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
      if node.contain(childNodePath: path) {
        childNode = node.children![path]!
      } else {
        childNode = RoutePathNode(path: path, value: value)
        node.add(childNode: childNode)
      }

      node = childNode

    }

    node.value = value
    return node

  }

  func search(paths: [String]) -> ([String: AnyObject], RoutePathNode) {

    var params = [String: AnyObject]()

    var node = self
    for path in paths {

      if node.contain(childNodePath: path) {
        node = node.children![path]!

      } else if let placeHolderChild = node.placeHolderChild {

        let placeHolderName = placeHolderChild.placeHolderName!
        params[placeHolderName] = path as AnyObject?
        node = placeHolderChild
      }
      
    }

    return (params, node)
  }

}


// MARK: Private Helper Methods

private extension Array where Element: Equatable {

  mutating func remove(object: Element) {
    if let index = self.index(of: object) {
      self.remove(at: index)
    }
  }

}

private extension URL {

  var pathComponentsWithoutSlash: [String]? {

    var array = pathComponents
    array.remove(object: "/")
    return array
  }

  var queryItems: [URLQueryItem]? {
    return URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems
  }

}

