//
//  Presentation.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit

/**
 The protocol for abstract the way of how display the destination view controller.
 */
@objc public protocol ControllerDisplay {

  /**
   How to display the destination view controller.
   
   - parameter source: The source view controller.
   - parameter destination: The destination view controller.
   */
  func displayViewController(source: UIViewController, destination: UIViewController)

}
