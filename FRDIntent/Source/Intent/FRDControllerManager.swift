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
  @discardableResult public func register(_ url: URL, clazz: FRDIntentReceivable.Type) -> Bool {
    return routeManager.register(url, clazz: clazz)
  }

  /**
   Registers with a plist file. 
   
   - parameter path: The plistFile path.
   
   - returns: True if it registers successfully.
   */
  @discardableResult public func register(contentsOfFile path: String) -> Bool {

    guard let registers: NSDictionary = NSDictionary(contentsOfFile: path) else {
      return false
    }

    for (url, className) in registers {

      guard let url = url as? String, let className = className as? String else {
        return false
      }

      if let clazz = NSClassFromString(className) as? FRDIntentReceivable.Type {
        let result = register(URL(string: url)!, clazz: clazz)
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
  public func startController(from source: UIViewController, withIntent intent: FRDIntent) {

    var parameters = [String: Any]()
    var controllerClazz: FRDIntentReceivable.Type?

    if let url = intent.url {
      let (params, clazz) = routeManager.searchController(for: url)
      parameters = params
      controllerClazz = clazz
    }

    if let clazz = intent.receiveClass {
      controllerClazz = clazz
    }

    if let controllerClazz = controllerClazz {
      for (key, value) in parameters {
        intent.putExtraName(key, withValue: value)
      }

      if let destination = InitializerHelper.viewController(fromClazz: controllerClazz,
                                                            extras: intent.extras) as? FRDIntentReceivable {

        if let validateResult = destination.validate?(intent), validateResult == false {
          return
        }

        let display: FRDControllerDisplay
        if let controllerDisplay = intent.controllerDisplay {
          display = controllerDisplay
        } else {
          display = FRDPushDisplay()
        }

        if let destination = destination as? UIViewController {
          display.displayViewController(from: source, to: destination)
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
  public func startControllerForResult(from source: UIViewController, withIntent intent: FRDIntent, requestCode: Int) {

    typealias ControllerType = FRDIntentForResultReceivable.Type

    var parameters = [String: Any]()
    var controllerClazz: ControllerType?

    if let url = intent.url {
      let (params, clazz) = routeManager.searchController(for: url)
      parameters = params
      controllerClazz = clazz as? ControllerType
    }

    if let clazz = intent.receiveClass as? ControllerType {
      controllerClazz = clazz
    }

    if let controllerClazz = controllerClazz {

      for (key, value) in parameters {
        intent.putExtraName(key, withValue: value)
      }

      if let destination = InitializerHelper.viewController(fromClazz: controllerClazz,
                                                            extras: intent.extras) as? FRDIntentForResultReceivable {

        if let validateResult = destination.validate?(intent), validateResult == false {
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
          display.displayViewController(from: source, to: destination)
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
  func startController(withIntent intent: FRDIntent) {
    FRDControllerManager.sharedInstance.startController(from: self, withIntent: intent)
  }

  /**
   Launch a view controller from source view controller without creating an intent.
   @see FRDControllerManager#startController(intent: FRDIntent)

   - parameter pathIdentifier: The pathIdentifier for initializing the intent.
   - parameter extras: The datas for initializing the intent.
   */
  func startController(withPathIdentifier pathIdentifier: String, extras: [String: Any]) {
    let intent = FRDIntent(pathIdentifier: pathIdentifier)
    intent.putExtraDatas(extras)
    self.startController(withIntent: intent)
  }

  /**
   Launch a view controller for which you would like a result when it finished. 
   When this view controller exits, your onControllerResult() method will be called with the given requestCode.
   @see FRDControllerManager#startControllerForResult(source: UIViewController, intent: FRDIntent, requestCode: Int)

   - parameter intent: The intent for start new view controller.
   - parameter requestCode : this code will be returned in onControllerResult() when the view controller exits.
   */
  func startControllerForResult(withIntent intent: FRDIntent, requestCode: Int) {
    FRDControllerManager.sharedInstance.startControllerForResult(from: self,
                                                                 withIntent: intent,
                                                                 requestCode: requestCode)
  }

  /**
   Launch a view controller for which you would like a result when it finished without creating an intent.
   When this view controller exits, your onControllerResult() method will be called with the given requestCode.
   @see FRDControllerManager#startControllerForResult(source: UIViewController, intent: FRDIntent, requestCode: Int)
   
   - parameter pathIdentifier: The pathIdentifier for initializing the intent.
   - parameter extras: The datas for initializing the intent.
   - parameter requestCode : this code will be returned in onControllerResult() when the view controller exits.
   */
  func startControllerForResult(withPathIdentifier pathIdentifier: String, extras: [String: Any], requestCode: Int) {
    let intent = FRDIntent(pathIdentifier: pathIdentifier)
    intent.putExtraDatas(extras)
    self.startControllerForResult(withIntent: intent, requestCode: requestCode)
  }

  /**
   The FRDReceivable Controller can use this method to setup default information from intent's extras.

   - parameter extras: The datas of intent received.
   */
  func setupExtras(_ extras: [String: Any]) {
    if let title = extras[FRDIntentParameters.title] as? String {
      self.title = title
    }

    if let hidesBottomBarWhenPushed = extras[FRDIntentParameters.hidesBottomBarWhenPushed] as? Bool {
      self.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
    }
  }

}
