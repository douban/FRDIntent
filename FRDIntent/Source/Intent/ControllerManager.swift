//
//  ControllerManager.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit

/**
 ControllerManager is a way to manage view controllers and invoke view controllers from a URL or class name.
 */
public class ControllerManager: NSObject {

  /// Singleton instance of ControllerManager
  public static let sharedInstance = ControllerManager()

  private var routeManager = RouteManager.sharedInstance

  /**
   Registers a url for calling handler blocks.

   - parameter url: The url to be registered.
   - parameter clazz: The clazz to be registered, and the clazz's view controller object will be launched while routed.
   */
  public func register(url url: NSURL, clazz: AnyClass) {
    routeManager.register(url: url, clazz: clazz as! IntentReceivable.Type)
  }

  /**
   Launch a view controller from source view controller with a intent.
   
   - parameter source: The source view controller.
   - parameter intent: The intent for launch a new view controller.
   */
  public func startController(source source: UIViewController, intent: Intent) {

    var parameters = [String: AnyObject]()
    var controllerClazz: IntentReceivable.Type?

    if let url = intent.url {
      let (params, clazz) = routeManager.searchController(url: url)
      parameters = params
      controllerClazz = clazz
    }

    if let clazz = intent.receiveClass {
      controllerClazz = clazz as? IntentReceivable.Type
    }

    if let controllerClazz = controllerClazz {
      let display = intent.controllerDisplay

      for (key, value) in parameters {
        intent.putExtra(name: key, data: value)
      }
      let destination = controllerClazz.init(extras: intent.extras) as! UIViewController

      display.displayViewController(source: source, destination: destination)
    }

  }

  /**
    Launch a view controller for which you would like a result when it finished. When this view controller exits, your onControllerResult() method will be called with the given requestCode.

   - parameter source: The source view controller.
   - parameter intent: The intent for start new view controller.
   - parameter requestCode : this code will be returned in onControllerResult() when the view controller exits.
   */
  public func startControllerForResult(source source: UIViewController, intent: Intent, requestCode: Int) {

    typealias ControllerType = IntentForResultReceivable.Type

    var parameters = [String: AnyObject]()
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
      let destination = controllerClazz.init(extras: intent.extras)

      destination.setRequestCode(requestCode)
      destination.setDelegate(source as? IntentForResultSendable)

      let destinationController = destination as! UIViewController

      display.displayViewController(source: source, destination: destinationController)
    }

  }

}
