# FRDIntent
Communication between Controoler with Intent

Register

```Swift
    let controllerManager = ControllerManager.sharedInstance
    controllerManager.registerController(NSURL(string: "douban://douban.com/frodo/firstViewController")!, clazz: FirstViewController.self)
```

Open a Controller

```Swift
    let intent = Intent(uri: NSURL(string: "douban://douban.com/frodo/firstViewController")!)
    intent.putExtra(["number": 1])
    let manager = ControllerManager.sharedInstance
    manager.startController(source: self, intent: intent)
```