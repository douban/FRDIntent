//
//  PresentationDisplay.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit

/**
 The way of display view controllers with present. It calls presentViewController(viewController: UIViewController, animated: Bool)
 */
open class PresentationDisplay: NSObject, ControllerDisplay {

  /**
   How to display the destination view controller.

   - parameter source: The source view controller.
   - parameter destination: The destination view controller.
   */
  open func displayViewController(source: UIViewController, destination: UIViewController) {
    let nav = UINavigationController(rootViewController: destination)
    source.present(nav, animated: true, completion: nil)
  }

}
