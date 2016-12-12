//
//  FRDIntentReceivable.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import Foundation

/**
 The protocol to abstract the view controller tha can receive the Intent.
 */
@objc public protocol FRDIntentReceivable {

  /**
   Initialzier with extra data.
   
   - parameter extras: The extra data.
   */
  init(extras: [String: AnyObject]?)

}
