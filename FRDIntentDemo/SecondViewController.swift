//
//  SecondViewController.swift
//  FRDBeanFactory
//
//  Created by GUO Lin on 8/24/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit
import FRDIntent

class SecondViewController: UIViewController, IntentReceivableController {

  var number: NSNumber?

  convenience required init(extra: Dictionary<String, Any>?) {
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
    title = "SecondViewController"
    view.backgroundColor = UIColor.whiteColor()
    let numberLabel = UILabel()
    numberLabel.frame = CGRect(x: 20, y: 100, width: view.bounds.size.width - 40, height: 44)
    numberLabel.textAlignment = .Center
    if let number = number {
      numberLabel.text = "\(number)"
    }
    view.addSubview(numberLabel)
  }
}
