//
//  PresentationDisplay.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit

public class PresentationDisplay: ControllerDisplay {

  public func displayViewController(source source: UIViewController, destination: UIViewController) {
    source.presentViewController(destination, animated: true, completion: nil)
  }

}