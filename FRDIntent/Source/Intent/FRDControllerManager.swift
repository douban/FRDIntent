//
//  FRDControllerManager.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit

/**
 FRDControllerManager is a way to manage view controllers and invoke view controllers from a URL or class name.
 */
public class FRDControllerManager: NSObject {

  /// Singleton instance of FRDControllerManager
  public static let sharedInstance = FRDControllerManager()

  private let routeManager = RouteManager.sharedInstance

  /**
   Registers a url for calling handler blocks.

   - parameter url: The url to be registered.
   - parameter clazz: The clazz to be registered, and the clazz's view controller object will be launched while routed.
   
   - returns: True if it registers successfully.
   */
  @discardableResult public func register(url: URL, clazz: AnyClass) -> Bool {
    return routeManager.register(url: url, clazz: clazz as! FRDIntentReceivable.Type)
  }

  /**
   Registers with a plist file. 
   
   - parameter plistFile: The plistFile path.
   
   - returns: True if it registers successfully.
   */
  public func registers(plistFile: String) -> Bool {

    guard let registers: NSDictionary = NSDictionary(contentsOfFile: plistFile) else {
      return false
    }

    for (url, className) in registers {

      guard let url = url as? String, let className = className as? String else {
        return false
      }

      if let clazz = NSClassFromString(className) as? FRDIntentReceivable.Type {
        let result = register(url: URL(string: url)!, clazz: clazz)
        if !result {
          return false
        }
      }

    }
    return true
  }

  /**
   Launch a view controller from source view controller with a intent.
   
   - parameter source: The source view controller.
   - parameter intent: The intent for launch a new view controller.
   */
  public func startController(source: UIViewController, intent: FRDIntent) {

    var parameters = [String: AnyObject]()
    var controllerClazz: FRDIntentReceivable.Type?

    if let url = intent.url {
      let (params, clazz) = routeManager.searchController(url: url)
      parameters = params
      controllerClazz = clazz
    }

    if let clazz = intent.receiveClass {
      controllerClazz = clazz
    }

    if let controllerClazz = controllerClazz {
      for (key, value) in parameters {
        intent.putExtra(name: key, data: value)
      }

      if let destination = InitializerHelper.viewController(fromClazz: controllerClazz, extras: intent.extras) as? FRDIntentReceivable {

        if let validateResult = destination.validate?(intent: intent), validateResult == false {
          return
        }

        let display: FRDControllerDisplay
        if let controllerDisplay = intent.controllerDisplay {
          display = controllerDisplay
        } else {
          display = FRDPushDisplay()
        }

        if let destination = destination as? UIViewController {
          display.displayViewController(source: source, destination: destination)
        }
      }

    }

  }

  /**
   Launch a view controller for which you would like a result when it finished.
   When this view controller exits, your onControllerResult() method will be called with the given requestCode.

   - parameter source: The source view controller.
   - parameter intent: The intent for start new view controller.
   - parameter requestCode : this code will be returned in onControllerResult() when the view controller exits.
   */
  public func startControllerForResult(source: UIViewController, intent: FRDIntent, requestCode: Int) {

    typealias ControllerType = FRDIntentForResultReceivable.Type

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

      for (key, value) in parameters {
        intent.putExtra(name: key, data: value)
      }

      if let destination = InitializerHelper.viewController(fromClazz: controllerClazz, extras: intent.extras) as? FRDIntentForResultReceivable {

        if let validateResult = destination.validate?(intent: intent), validateResult == false {
          return
        }

        destination.setRequestCode(requestCode)
        if let source = source as? FRDIntentForResultSendable {
          destination.setDelegate(source)
        }

        let display: FRDControllerDisplay
        if let controllerDisplay = intent.controllerDisplay {
          display = controllerDisplay
        } else {
          display = FRDPresentationDisplay()
        }

        if let destination = destination as? UIViewController {
          display.displayViewController(source: source, destination: destination)
        }
      }
    }

  }

}


public extension UIViewController {

  /**
   Launch a view controller from source view controller with an intent.
   @see FRDControllerManager#startController(intent: FRDIntent)

   - parameter intent: The intent for launch a new view controller.
   */
  func startController(intent: FRDIntent) {
    FRDControllerManager.sharedInstance.startController(source: self, intent: intent)
  }

  /**
   Launch a view controller from source view controller without creating an intent.
   @see FRDControllerManager#startController(intent: FRDIntent)

   - parameter pathIdentifier: The pathIdentifier for initializing the intent.
   - parameter extras: The datas for initializing the intent.
   */
  func startController(pathIdentifier: String, extras: [String: AnyObject]) {
    let intent = FRDIntent(pathIdentifier: pathIdentifier)
    intent.putExtras(datas: extras)
    self.startController(intent: intent)
  }

  /**
   Launch a view controller for which you would like a result when it finished. 
   When this view controller exits, your onControllerResult() method will be called with the given requestCode.
   @see FRDControllerManager#startControllerForResult(source: UIViewController, intent: FRDIntent, requestCode: Int)

   - parameter intent: The intent for start new view controller.
   - parameter requestCode : this code will be returned in onControllerResult() when the view controller exits.
   */
  func startControllerForResult(intent: FRDIntent, requestCode: Int) {
    FRDControllerManager.sharedInstance.startControllerForResult(source: self, intent: intent, requestCode: requestCode)
  }

  /**
   Launch a view controller for which you would like a result when it finished without creating an intent.
   When this view controller exits, your onControllerResult() method will be called with the given requestCode.
   @see FRDControllerManager#startControllerForResult(source: UIViewController, intent: FRDIntent, requestCode: Int)
   
   - parameter pathIdentifier: The pathIdentifier for initializing the intent.
   - parameter extras: The datas for initializing the intent.
   - parameter requestCode : this code will be returned in onControllerResult() when the view controller exits.
   */
  func startControllerForResult(pathIdentifier: String, extras: [String: AnyObject], requestCode: Int) {
    let intent = FRDIntent(pathIdentifier: pathIdentifier)
    intent.putExtras(datas: extras)
    self.startControllerForResult(intent: intent, requestCode: requestCode)
  }

  /**
   The FRDReceivable Controller can use this method to setup default information from intent's extras.

   - parameter extras: The datas of intent received.
   */
  func setup(extras: [String: AnyObject]) {
    if let title = extras[FRDIntentParameters.title] as? String {
      self.title = title
    }

    if let hidesBottomBarWhenPushed = extras[FRDIntentParameters.hidesBottomBarWhenPushed] as? Bool {
      self.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
    }
  }

}
