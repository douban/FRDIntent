//
//  IntentReceivable.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import Foundation

public protocol IntentReceivable {

  init(extra: Dictionary<String, Any>?)

}
