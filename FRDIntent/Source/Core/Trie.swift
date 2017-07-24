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

 This trie supports url pattern match with prefix ":", and nearest node match.

*/
final class Trie<T> {

  private var root: TrieNode<T>

  init() {
    root = TrieNode<T>(key: "")
  }

  /**
   Insert the url into the trie.

   - parameter value: the value for inserting.
   - parameter url: the url.
   */
  func insert(_ value: T, with url: URL) -> Bool {
    guard let paths = url.pathComponentsWithoutSlash, !paths.isEmpty else {
      return false
    }

    var currentNode = root
    for path in paths {
      if let child = currentNode.children[path] {
        currentNode = child
      } else {
        if path.hasPrefix(":") {
          // check if any child is placeholder.
          if let child = currentNode.children.values.first(where: { $0.isPlaceholder }) {
            NSLog("Already have placeholder \(child.key), can't insert another placeholder \(path).")
            return false
          }
        }
        currentNode.addChild(nil, withKey: path)
        currentNode = currentNode.children[path]!
      }
    }
    currentNode.value = value
    return true
  }

  /**
   Remove node from Trie

   - parameter node: a node in the Trie
   */
  func remove(_ node: TrieNode<T>) {
    var currentNode = node
    while let parent = currentNode.parent {
      if currentNode.isLeaf && !currentNode.isTerminating {
        parent.children[currentNode.key] = nil
      }
      currentNode = parent
    }
  }

  /**
   This search method's behavior is different with classical trie's search.
   When it can not find the node it will try to find the nearest parent node which is isTerminating.

   - parameter url: the url.

   - returns: the matched node. If trie has this paths, return this node.
              If trie has not this paths, return the nearest registered url parent.
   */
  func search(with url: URL) -> TrieNode<T>? {
    guard let paths = url.pathComponentsWithoutSlash, !paths.isEmpty else {
      return nil
    }

    if let (node, _) = search(with: paths, rootNode: root) {
      return node
    }
    return nil
  }

  func search(with paths: [String], rootNode: TrieNode<T>) -> (TrieNode<T>, Int)? {
    var resultNode: TrieNode<T>? = rootNode.isTerminating ? rootNode : nil
    var resultNodeDistanceToLastPath: Int = paths.count

    if let path = paths.first {
      var childrenPaths = paths
      childrenPaths.removeFirst()
      let children = rootNode.matchedChildren(forKey: path)
      for childNode in children {
        if let (node, stepLeft) = search(with: childrenPaths, rootNode: childNode), stepLeft < resultNodeDistanceToLastPath {
          resultNode = node
          resultNodeDistanceToLastPath = stepLeft
        }
        if resultNodeDistanceToLastPath == 0 {
          break
        }
      }
    }

    if resultNode != nil {
      return (resultNode!, resultNodeDistanceToLastPath)
    } else {
      return nil
    }
  }

  /**
   Find the node for given url, considering placeholder such as ":id".

   - parameter url: the url.
   - return the match node. Otherwise nil.
   */
  func searchNodeWithMatchPlaceholder(with url: URL) -> TrieNode<T>? {
    guard let paths = url.pathComponentsWithoutSlash, !paths.isEmpty else {
      return nil
    }

    if let (node, stepLeft) = search(with: paths, rootNode: root), stepLeft == 0 {
      return node
    }
    return nil
  }

  /**
   Find the node for given url without considering placeholder such as ":id".

   - parameter url: the url.
   - return the match node. Otherwise nil.
   */
  func searchNodeWithoutMatchPlaceholder(with url: URL) -> TrieNode<T>? {
    guard let paths = url.pathComponentsWithoutSlash, !paths.isEmpty else {
      return nil
    }
    var currentNode = root
    for path in paths {
      if let child = currentNode.children[path] {
        currentNode = child
      } else {
        return nil
      }
    }

    if currentNode.isTerminating {
      return currentNode
    }
    return nil
  }

  /**
   This trie support url pattern match. The url with prefix ":" is the url pattern, for example ":userId".
   This method extracts all the patterns in the url.
   
   - parameter url: the url for finding the pattern match.
   
   - parameter resultNode: the url search result node.

   - returns: dictionary for the pattern match result.
   */
  func extractMatchedPattern(from url: URL, resultNode: TrieNode<T>) -> [String: Any] {
    guard let paths = url.pathComponentsWithoutSlash, !paths.isEmpty else {
      return [:]
    }

    var params: [String: Any] = [:]
    var nodes: [TrieNode<T>] = []
    var currentNode: TrieNode<T>? = resultNode
    while let node = currentNode, node.parent != nil {
      nodes.append(node)
      currentNode = node.parent
    }
    for path in paths {
      if let matchNode = nodes.popLast() {
        if matchNode.isPlaceholder && matchNode.key != path {
          params[matchNode.placeholder!] = path
        }
      } else {
        break
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
  var parent: TrieNode<T>?

  var isTerminating: Bool {
    return value != nil
  }

  var isLeaf: Bool {
    return children.isEmpty
  }

  convenience init(key: String) {
    self.init(key: key, value: nil)
  }

  init(key: String, value: T?) {
    self.key = key
    self.value = value
  }

  func addChild(_ value: T?, withKey key: String) {
    guard children[key] == nil else {
      return
    }
    let node = TrieNode(key: key, value: value)
    node.parent = self
    children[key] = node
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

  func matchedChildren(forKey key: String) -> [TrieNode] {
    var matchedChildren: [TrieNode] = []
    if let child = children[key] {
      matchedChildren.append(child)
    }

    if let placeholderChild = children.values.first(where: {$0.isPlaceholder}) {
      matchedChildren.append(placeholderChild)
    }
    return matchedChildren
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
