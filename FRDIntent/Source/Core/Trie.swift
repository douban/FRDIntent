//
//  Trie.swift
//  FRDIntent
//
//  Created by GUO Lin on 06/12/2016.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import Foundation

/**
 The trie data structure to store and search with url.

 About trie: https://en.wikipedia.org/wiki/Trie

 Insert these three urls into an empty trie:
 
 ```
 /user/:userId/profile
 /story/:storyId
 /subject/:subjectId
 ```
 
 We will get a trie like this:
 
 ```
             ""
         /    |     \
    "user" "story" "subject"
      /       |        \
  ":userId" ":storId" ":subjectId"
    /
 "profile"
 ```

 This trie supports url pattern match with prefix ":" and nearest node match.

*/
final class Trie<T> {

  private var root: TrieNode<T>

  init() {
    root = TrieNode<T>(key: "")
  }

  /**
   Insert the url into the trie.

   - parameter url: the url.
   - parameter value: the value for inserting.
   */
  func insert(url: URL, value: T) {
    guard let paths = url.pathComponentsWithoutSlash else {
      return
    }
    insert(paths: paths, value: value)
  }

  private func insert(paths: [String], value: T) {
    guard !paths.isEmpty else {
      return
    }

    var currentNode = root
    for path in paths {
      if let child = currentNode.children[path] {
        currentNode = child
      } else {
        currentNode.addChild(key: path, value: value)
        currentNode = currentNode.children[path]!
      }
    }
    currentNode.value = value
  }

  /**
   Search the value with url key.
   
   - parameter url: the url.

   - returns: the node's value.
   */
  func search(url: URL) -> T? {
    guard let paths = url.pathComponentsWithoutSlash else {
      return nil
    }
    return search(paths: paths)
  }

  private func search(paths: [String]) -> T? {
    guard !paths.isEmpty else {
      return nil
    }

    var currentNode = root
    for path in paths {
      if let child = currentNode.children[path] {
        currentNode = child
      } else {
        if let child = currentNode.childOrFirstPlaceholder(key: path) {
          currentNode = child
        } else {
          return nil
        }
      }
    }
    return currentNode.value
  }

  /**
   This search method's behavior is different with classical trie's search.

   - parameter url: the url.

   - returns: the node's value. If trie has this paths, return the value in this node. If trie has not this paths, return the nearest registered url parent.
   */
  func searchWithNearestMatch(url: URL) -> T? {
    guard let paths = url.pathComponentsWithoutSlash else {
      return nil
    }
    return searchWithNearestMatch(paths: paths)
  }

  private func searchWithNearestMatch(paths: [String]) -> T? {
    guard !paths.isEmpty else {
      return nil
    }

    var currentNode = root
    var nearestUrlParent = root
    for path in paths {
      if let child = currentNode.children[path] {
        currentNode = child
        if currentNode.isTerminating {
          nearestUrlParent = currentNode
        }
      } else {
        if let child = currentNode.childOrFirstPlaceholder(key: path) {
          currentNode = child
          if currentNode.isTerminating {
            nearestUrlParent = currentNode
          }
        } else {
          // not find
          return nearestUrlParent.value
        }
      }
    }
    return currentNode.value
  }

  /**
   This trie support url pattern match. The url with prefix ":" is the url pattern, for example ":userId".
   This method extract all the patterns in the url.
   
   - parameter url: the url for find the pattern match.

   - returns: dictionary for the pattern match result.
   */
  func matchUrlPattern(url: URL) -> URLRoutesHandlerParam {
    guard let paths = url.pathComponentsWithoutSlash else {
      return [:]
    }

    guard !paths.isEmpty else {
      return [:]
    }

    var params: [String: AnyObject] = [:]
    var currentNode = root
    for path in paths {
      if let child = currentNode.children[path] {
        currentNode = child
      } else {
        if let child = currentNode.childOrFirstPlaceholder(key: path) {
          if child.isPlaceholder {
            params[child.placeholder!] = path as AnyObject
          }
          currentNode = child
        } else {
          // not find
          return params
        }
      }
    }
    return params
  }
}


// MARK: - TrieNode

final class TrieNode<T> {

  var key: String
  var value: T?
  var children: [String: TrieNode<T>] = [:]

  var isTerminating: Bool {
    return value != nil
  }

  convenience init(key: String) {
    self.init(key: key, value: nil)
  }

  init(key: String, value: T?) {
    self.key = key
    self.value = value
  }

  func addChild(key: String, value: T) {
    guard children[key] == nil else {
      return
    }

    children[key] = TrieNode(key: key, value: value)
  }

}

extension TrieNode {

  var isPlaceholder: Bool {
    return key.hasPrefix(":")
  }

  var placeholder: String? {
    if isPlaceholder {
      return key.substring(from: key.index(key.startIndex, offsetBy: 1))
    }
    return nil
  }

  func childOrFirstPlaceholder(key: String) -> TrieNode? {
    if let child = children[key] {
      return child
    } else {
      for child in children.values where child.isPlaceholder {
        return child
      }
    }
    return nil
  }

}


// MARK: - URL extension

extension URL {

  /**
   The path components without the first slash.
   
   - returns: array of path components without slash.
   */
  var pathComponentsWithoutSlash: [String]? {
    var array = pathComponents
    if let first = array.first, first == "/" {
      array.removeFirst()
    }
    return array
  }

  var queryItems: [URLQueryItem]? {
    return URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems
  }
}
