//
//  PushDisplay.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit

public class PushDisplay: ControllerDisplay {

  public func displayViewController(source source: UIViewController, destination: UIViewController) {
    if let navigationController = source.navigationController {
      navigationController.pushViewController(destination, animated: true)
    }
  }

}