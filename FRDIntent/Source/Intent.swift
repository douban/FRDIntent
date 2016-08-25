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
  public var receiveClass: IntentReceivable.Type?

  private(set) var extra: Dictionary<String, AnyObject>?

  public var controllerDisplay: ControllerDisplay = PushDisplay()

  public init(clazz: IntentReceivable.Type) {
    self.receiveClass = clazz
  }

  public init(uri: NSURL) {
    self.uri = uri
  }

  public func putExtra(extra: Dictionary<String, AnyObject>) {
    self.extra = extra
  }

}