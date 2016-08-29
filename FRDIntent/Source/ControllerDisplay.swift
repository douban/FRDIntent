//
//  Presentation.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit

public protocol ControllerDisplay {

  func displayViewController<T: UIViewController>(source source: T, destination: T)

}