//
//  FRDPushDisplay.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit

/**
 The way of display view controllers with push. 
 It calls pushViewController(viewController: UIViewController, animated: Bool)
 */
open class FRDPushDisplay: NSObject, FRDControllerDisplay {

  /**
   How to display the destination view controller.

   - parameter source: The source view controller.
   - parameter destination: The destination view controller.
   */
  open func displayViewController(from source: UIViewController, to destination: UIViewController) {
    if let navigationController = source.navigationController {
      navigationController.pushViewController(destination, animated: true)
    }
  }

}
