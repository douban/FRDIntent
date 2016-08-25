//
//  FirstViewController.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/25/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit
import FRDIntent

class FirstViewController: UIViewController, IntentReceivable {

  var number: NSNumber?

  convenience required init(extra: Dictionary<String, AnyObject>?) {
    let number = extra?["number"] as? NSNumber
    self.init(number: number)
  }

  init(number: NSNumber?) {
    self.number = number
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "FirstViewController"
    view.backgroundColor = UIColor.whiteColor()
    let numberLabel = UILabel()
    numberLabel.frame = CGRect(x: 20, y: 100, width: view.bounds.size.width - 40, height: 44)
    numberLabel.textAlignment = .Center
    numberLabel.text = "\(number)"
    view.addSubview(numberLabel)
  }

}
