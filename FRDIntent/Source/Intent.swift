//
//  Intent.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import Foundation

public class Intent {

  public var uri: NSURL?
  public var receiveClass: IntentReceivableController.Type?
  public var controllerDisplay: ControllerDisplay = PushDisplay()

  public private(set) var extra = Dictionary<String, Any>()

  public init(clazz: IntentReceivableController.Type) {
    self.receiveClass = clazz
  }

  public init(uri: NSURL) {
    self.uri = uri
  }

  public func putExtra(name name: String, data: Any) {
    self.extra[name] = data
  }
}