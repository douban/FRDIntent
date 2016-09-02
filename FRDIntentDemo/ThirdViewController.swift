//
//  ThirdViewController.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/29/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit
import FRDIntent

class ThirdViewController: UIViewController, IntentForResultReceivable {

  var data: [String: Any]?
  var requestCode: Int?
  
  var delegate: IntentForResultSendable?

  let textField: UITextField = UITextField()

  required init(extras: [String: Any]?) {
    data = extras
    let text = extras?["text"] as? String
    textField.text = text
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "ThirdViewController"
    view.backgroundColor = UIColor.whiteColor()

    let closeButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(dismiss))
    navigationItem.leftBarButtonItem = closeButton

    let confirmButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(confirm))
    navigationItem.rightBarButtonItem = confirmButton

    textField.frame = CGRect(x: 10, y: 100, width: view.bounds.size.width - 20, height: 44)
    textField.backgroundColor = UIColor.lightGrayColor()
    textField.clearButtonMode = .Always
    textField.returnKeyType = .Done
    textField.delegate = self
    view.addSubview(textField)

    let numberLabel = UILabel()
    numberLabel.frame = CGRect(x: 20, y: 200, width: view.bounds.size.width - 40, height: 300)
    numberLabel.textAlignment = .Center
    numberLabel.numberOfLines = 0
    if let data = data {
      numberLabel.text = "\(data)"
    }
    view.addSubview(numberLabel)
  }

  func dismiss() {
    dismissViewControllerAnimated(true, completion: nil)
    if let controller = delegate {
      let intent = Intent(url: NSURL(string: "douban://")!)
      intent.putExtra(name: "text", data: textField.text)
      controller.onControllerResult(requestCode: self.requestCode!, resultCode: .Canceled, data: intent)
    }

  }

  func confirm() {
    if let controller = delegate {
      dismissViewControllerAnimated(true, completion: nil)
      let intent = Intent(url: NSURL(string: "douban://")!)
      intent.putExtra(name: "text", data: textField.text)
      controller.onControllerResult(requestCode: self.requestCode!, resultCode: .Ok, data: intent)
    }
  }
}

extension ThirdViewController: UITextFieldDelegate {

  func textFieldShouldReturn(textField: UITextField)  -> Bool {
    confirm()
    return true
  }
}

