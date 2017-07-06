//
//  FRDIntent.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import Foundation

/**
 An intent is an abstract description of an operation to be performed. 
 It can be used with startController to launch a view controller.
 */
public class FRDIntent: NSObject {

  /**
   The url for identify the destination view controller.
   */
  public var url: URL?

  /**
   The destination view controller's class type.
  */
  public var receiveClass: FRDIntentReceivable.Type?

  /**
   The way of how to display the new view controller.
  */
  public var controllerDisplay: FRDControllerDisplay?

  /**
   The extra data to inform the destination view controller. Read-only.
   */
  public fileprivate(set) var extras = [String: Any]()

  /**
   Initializer with the destination view controller's class type.
   
   - parameter clazz: The destination view controller's class type.
   */
  public init(clazz: FRDIntentReceivable.Type) {
    self.receiveClass = clazz
  }

  /**
   Initializer with the url for identify the destination view controller.
   
   - parameter url: The url for identify the destination view controller.
  */
  public init(url: URL) {
    self.url = url
  }

  /**
   Initializer with the url for identify the destination view controller.

   - parameter pathIdentifier: The path identifier for identify the destination view controller. 
   The format is url path.
   */
  public convenience init(pathIdentifier: String) {
    self.init(url: URL(string: pathIdentifier)!)
  }

  /**
   Put the extra data into the intent.
   
   - parameter name: key
   - parameter value: value
  */
  public func putExtraName(_ name: String, withValue value: Any) {
    self.extras[name] = value
  }

  /**
   Put the extras datas into the intent.
   
   - parameter datas: the data dictionary.
   */
  public func putExtraDatas(_ datas: [String: Any]) {
    for (key, value) in datas {
      self.extras[key] = value
    }
  }

}
