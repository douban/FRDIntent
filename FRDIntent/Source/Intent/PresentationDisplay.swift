//
//  PresentationDisplay.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit

public class PresentationDisplay: ControllerDisplay {

  public func displayViewController<T: UIViewController>(source source: T, destination: T) {
    let nav = UINavigationController(rootViewController: destination)
    source.presentViewController(nav, animated: true, completion: nil)
  }

}