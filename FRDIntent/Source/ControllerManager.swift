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

  private var map = Dictionary<NSURL, IntentReceivableController.Type>()
  private var mapForResult = Dictionary<NSURL, IntentForResultReceivableController.Type>()

  public func startController(source source: UIViewController, intent: Intent) {

    var controllerClazz: IntentReceivableController.Type?

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

  public func registerController(uri: NSURL, clazz: IntentReceivableController.Type) {
    map[uri] = clazz
  }

  public func startForResultController<T: UIViewController where T: IntentForResultSendableController>(source source: T, intent: Intent, requestCode: Int) {

    var controllerClazz: IntentReceivableController.Type?

    if let clazz = intent.receiveClass {
      controllerClazz = clazz
    }

    if let uri = intent.uri {
      controllerClazz = map[uri]!
    }

    if let controllerClazz = controllerClazz {
      let display = PresentationDisplay()
      var destination = controllerClazz.init(extra: intent.extra) as! IntentForResultReceivableController

      destination.requestCode = requestCode
      destination.delegate = source

      let destinationController = destination as! UIViewController

      display.displayViewController(source: source, destination: destinationController)
    }

  }

  public func registerController(uri: NSURL, clazz: IntentForResultReceivableController.Type) {
    map[uri] = clazz
  }

}
