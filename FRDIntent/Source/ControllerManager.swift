//
//  ControllerManager.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit

public class ControllerManager {

  public static let sharedInstance = ControllerManager()

  private var map = Dictionary<NSURL, IntentReceivable.Type>()

  public func startController(source source: UIViewController, intent: Intent) {

    var controllerClazz: IntentReceivable.Type?

    if let clazz = intent.receiveClass {
      controllerClazz = clazz
    }

    if let uri = intent.uri {
      controllerClazz = map[uri]!
    }

    if let controllerClazz = controllerClazz {
      let display = intent.controllerDisplay
      let destination = controllerClazz.init(extra: intent.extra) as! UIViewController
      display.displayViewController(source: source, destination: destination)
    }

  }

  public func registerController(uri: NSURL, clazz: IntentReceivable.Type) {
    map[uri] = clazz
  }

}
