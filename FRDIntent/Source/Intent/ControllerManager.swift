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

  private var routeManager = RouteManager.sharedInstance

  public func register<C: UIViewController where C: IntentReceivable>(url url: NSURL, clazz: C.Type) {
    routeManager.register(url: url, clazz: clazz)
  }

  public func startController(source source: UIViewController, intent: Intent) {

    var parameters = [String: Any]()
    var controllerClazz: IntentReceivable.Type?

    if let url = intent.url {
      let (params, clazz) = routeManager.searchController(url: url)
      parameters = params
      controllerClazz = clazz
    }

    if let clazz = intent.receiveClass {
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

  public func startForResultController<C: UIViewController where C: IntentForResultSendable>(source source: C, intent: Intent, requestCode: Int) {

    typealias ControllerType = IntentForResultReceivable.Type

    var parameters = [String: Any]()
    var controllerClazz: ControllerType?

    if let url = intent.url {
      let (params, clazz) = routeManager.searchController(url: url)
      parameters = params
      controllerClazz = clazz as? ControllerType
    }

    if let clazz = intent.receiveClass as? ControllerType {
      controllerClazz = clazz
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

}
