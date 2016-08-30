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

  private var routeManager = RouteManager()

  // MARK: Start controller without result

  public func startController(source source: UIViewController, intent: Intent) {

    var parameters = [String: Any]()
    var controllerClazz: IntentReceivableController.Type?

    if let clazz = intent.receiveClass {
      controllerClazz = clazz
    }

    if let uri = intent.uri {
      let (params, clazz) = routeManager.searchRoute(uri: uri)
      parameters = params
      controllerClazz = clazz
    }

    if let controllerClazz = controllerClazz {
      let display = intent.controllerDisplay

      for (key, value) in parameters {
        intent.putExtra(name: key, data: value)
      }
      let destination = controllerClazz.init(extra: intent.extra) as! UIViewController

      display.displayViewController(source: source, destination: destination)
    }

  }

  public func registerController<C: UIViewController where C: IntentReceivableController>(uri: NSURL, clazz: C.Type) {
    routeManager.registerRoute(uri: uri, clazz: clazz)
  }


  // MARK: Start controller for result

  public func startForResultController<C: UIViewController where C: IntentForResultSendableController>(source source: C, intent: Intent, requestCode: Int) {

    typealias ControllerType = IntentForResultReceivableController.Type

    var parameters = [String: Any]()
    var controllerClazz: ControllerType?

    if let clazz = intent.receiveClass as? ControllerType {
      controllerClazz = clazz
    }

    if let uri = intent.uri {
      let (params, clazz) = routeManager.searchRoute(uri: uri)
      parameters = params
      controllerClazz = clazz as? ControllerType
    }

    if let controllerClazz = controllerClazz {
      let display = PresentationDisplay()

      for (key, value) in parameters {
        intent.putExtra(name: key, data: value)
      }
      var destination = controllerClazz.init(extra: intent.extra)

      destination.requestCode = requestCode
      destination.delegate = source

      let destinationController = destination as! UIViewController

      display.displayViewController(source: source, destination: destinationController)
    }

  }

  public func registerController<C: UIViewController where C: IntentForResultReceivableController>(uri: NSURL, clazz: C.Type) {
    routeManager.registerRoute(uri: uri, clazz: clazz)
  }

}
