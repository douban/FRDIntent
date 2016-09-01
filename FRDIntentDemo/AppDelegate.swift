//
//  AppDelegate.swift
//  FRDIntentDemo
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit
import FRDIntent

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.

    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window?.rootViewController = UINavigationController(rootViewController: ViewController())
    window?.makeKeyAndVisible()

    configureIntent()

    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
    return URLRouter.sharedInstance.route(url: url)
  }

  func configureIntent() {

    // Internal call
    let controllerManager = ControllerManager.sharedInstance
    controllerManager.register(url: NSURL(string: "/user/:userId")!, clazz: FirstViewController.self)
    controllerManager.register(url: NSURL(string: "/story/:storyId")!, clazz: SecondViewController.self)
    controllerManager.register(url: NSURL(string: "/user/:userId/story/:storyId")!, clazz: ThirdViewController.self)

    // External call
    let router = URLRouter.sharedInstance
    router.register(url: NSURL(string: "/user/:userId")!) { (params: [String: Any]) in
      let intent = Intent(url: params[URLRouter.URLRouterURL] as! NSURL)
      if let topViewController = UIApplication.topViewController() {
        ControllerManager.sharedInstance.startController(source: topViewController, intent: intent)
      }
    }

    router.register(url: NSURL(string: "/story/:storyId")!, clazz: SecondViewController.self)
  }

}

extension UIApplication {

  class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {

    if let nav = base as? UINavigationController {
      return topViewController(nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return topViewController(selected)
      }
    }
    if let presented = base?.presentedViewController {
      return topViewController(presented)
    }
    return base

  }
  
}


