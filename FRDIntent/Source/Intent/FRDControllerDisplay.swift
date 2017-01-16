//
//  FRDControllerDisplay.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit

/**
 The protocol to abstract the way of how the destination view controller displays.
 */
@objc public protocol FRDControllerDisplay {

  /**
   How to display the destination view controller.
   
   - parameter source: The source view controller.
   - parameter destination: The destination view controller.
   */
  func displayViewController(from source: UIViewController, to destination: UIViewController)

}
