//
//  RouteManager.swfit
//  FRDIntent
//
//  Created by GUO Lin on 8/30/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import Foundation

public class RouteManager {

  private var routes: RouteSearchPathNode = RouteSearchPathNode(value: "/", children: nil, clazz: nil)

  public func registerRoute(uri uri: NSURL, clazz: IntentReceivableController.Type) -> Bool {

    guard let pathComponents = uri.pathComponentsWithoutSlash else {
      return false
    }

    var node = routes
    for (index, path) in pathComponents.enumerate() {

      if node.containsChildPathNode(path) {
        node = node.children![path]!
      } else {
        if index < pathComponents.count - 1 {
          let childNode = RouteSearchPathNode(value:path)
          node.addChildPathNode(childNode)
          node = childNode
        } else if (index == pathComponents.count - 1){
          node.addChildPathNode(RouteSearchPathNode(value: path, clazz: clazz))
        }
      }

    }

    return true
  }

  public func searchRoute(uri uri: NSURL) -> ([String: Any], IntentReceivableController.Type?) {

    var params = [String: Any]()

    guard let pathComponents = uri.pathComponentsWithoutSlash else {
      return (params, nil)
    }

    var node = routes
    for path in pathComponents {

      if node.containsChildPathNode(path) {
        node = node.children![path]!

      } else if let placeHolderChild = node.placeHolderChild() {

        let placeHolderName = placeHolderChild.placeHolderName()!
        params[placeHolderName] = path
        node = placeHolderChild
      }

    }

    // Add queries to params
    if let queryItems = uri.queryItems {
      for queryItem in queryItems {
        if let value = queryItem.value {
          params.updateValue(value, forKey: queryItem.name)
        }
      }
    }

    // Add fragment to params
    if let fragment = uri.fragment {
      params.updateValue(fragment, forKey: "fragment")
    }

    return (params, node.clazz)

  }

}


// MARK: Private Data Structure

/**
 RouteSearchPathNode is data struct presenting a tree node.

 */
private class RouteSearchPathNode {

  typealias ControllerType = IntentReceivableController.Type

  var value: String
  var clazz: ControllerType?

  var children: [String: RouteSearchPathNode]?

  init(value: String,  children: [String: RouteSearchPathNode]?, clazz: ControllerType?) {
    self.value = value
    self.children = children
    self.clazz = clazz
  }

  convenience init(value: String) {
    self.init(value: value, children: nil, clazz: nil)
  }

  convenience init(value: String, clazz: ControllerType) {
    self.init(value: value, children: nil, clazz: clazz)
  }


  func isPlaceHolder() -> Bool {
    return value.hasPrefix(":")
  }

  func placeHolderName() -> String? {
    if isPlaceHolder() {
      let index = value.startIndex.advancedBy(1)
      return value.substringFromIndex(index)
    }
    return nil
  }

  func placeHolderChild() -> RouteSearchPathNode? {

    guard let children = children else {
      return nil
    }

    for (_, node) in children {
      if node.isPlaceHolder() {
        return node
      }
    }

    return nil
  }

  func addChildPathNode(node: RouteSearchPathNode) {
    if let _ = children {
      children?[node.value] = node
    } else {
      children = [String: RouteSearchPathNode]()
      children?[node.value] = node
    }
  }

  func containsChildPathNode(nodeValue: String) -> Bool {
    if let children = children {
      return children[nodeValue] != nil
    }
    return false
  }

  var description: String {
    return "value:\(self.value), children:\(self.children), clazz:\(self.clazz)"
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

