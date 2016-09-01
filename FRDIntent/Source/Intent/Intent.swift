//
//  Intent.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import Foundation

public class Intent {

  public var url: NSURL?
  public var receiveClass: IntentReceivable.Type?
  public var controllerDisplay: ControllerDisplay = PushDisplay()

  public private(set) var extra = [String: Any]()

  public init(clazz: IntentReceivable.Type) {
    self.receiveClass = clazz
  }

  public init(url: NSURL) {
    self.url = url
  }

  public func putExtra(name name: String, data: Any) {
    self.extra[name] = data
  }

}