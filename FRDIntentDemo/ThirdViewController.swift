//
//  ThirdViewController.swift
//  FRDIntent
//
//  Created by GUO Lin on 8/29/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import UIKit
import FRDIntent

class ThirdViewController: UIViewController, IntentForResultReceivableController {

  var requestCode: Int?
  
  var delegate: IntentForResultSendableController?

  let textField: UITextField = UITextField()

  required init(extra: [String: Any]?) {
    let text = extra?["text"] as? String
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
  }

  func dismiss() {
    dismissViewControllerAnimated(true, completion: nil)
    if let controller = delegate {
      let intent = Intent(uri: NSURL(string: "douban://")!)
      intent.putExtra(name: "text", data: textField.text)
      controller.onControllerResult(requestCode: self.requestCode!, resultCode: .Canceled, data: intent)
    }

  }

  func confirm() {
    if let controller = delegate {
      dismissViewControllerAnimated(true, completion: nil)
      let intent = Intent(uri: NSURL(string: "douban://")!)
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
