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
public class PresentationDisplay: ControllerDisplay {

  public init() {}

  /**
   How to display the destination view controller.

   - parameter source: The source view controller.
   - parameter destination: The destination view controller.
   */
  public func displayViewController(source source: UIViewController, destination: UIViewController) {
    let nav = UINavigationController(rootViewController: destination)
    source.presentViewController(nav, animated: true, completion: nil)
  }

}