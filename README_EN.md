# FRDIntent

[![Test Status](https://travis-ci.org/douban/FRDIntent.svg?branch=master)](https://travis-ci.org/douban/FRDIntent)
[![Language](https://img.shields.io/badge/language-Swift%203-orange.svg)
](https://developer.apple.com/swift/)
[![IDE](https://img.shields.io/badge/XCode-8-blue.svg)]()
[![iOS](https://img.shields.io/badge/iOS-8.0-green.svg)]()

**FRDIntent** consists of two parts: FRDIntent/Intent and FRDIntent/URLRoutes for the internal and external calls to UIViewController respectively.


## Installation

### Install Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C and Swift. You can install it with the following command:

```bash
$ gem install cocoapods
```

### Podfile

Only FRDIntent/Intent

```ruby
target 'TargetName' do
  pod 'FRDIntent/Intent', :git => 'https://github.com/douban/FRDIntent.git', :commit => '0.8.0'
end
```

Both FRDIntent/Intent and FRDIntent/URLRoutes:

```ruby
target 'TargetName' do
  pod 'FRDIntent', :git => 'https://github.com/douban/FRDIntent.git', :commit => '0.8.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### Version

Choose the right version: [https://github.com/douban/FRDIntent/releases](https://github.com/douban/FRDIntent/releases).

## Intent

FRDIntent/Intent is a messaging object for invoking an UIViewController. The concept is similar to [Intent](https://developer.android.com/guide/components/intents-filters.html) API on Android. But admittedly, FRDIntent/Intent is extremely simple and even crude, when comparing with Android's Intent. FRDIntent/Intent is only designed to handles internal between view controller within an app.

The traditional way of handling view controller's transition in often involves giving a view controller all the details of the recipient view on how it will be created. This creates unwanted tight dependencies dependencies between view controllers. FRDIntent/Intent is for eliminating this kind of dependency.

Benifits of using FRDIntent/Intent:

- Full decoupling. Completely separate the caller and the recipient. Caller only invoke intent. The recipient view controller only needs to conforme the `FRDIntentReceivable` protocol.
- It's easy to pass data back to the caller: just use the method `starControllerForResult`. This's similar to Android's `startActivityForResult`.
- Customizable transition animation.
- Easy transmission of complex data objects.

### Usage

`FRDControllerManager` is the main class to use FRDIntent/Intent. It has threes simple methods: `register` for registering the triggering path of an Intent, `startController` and `startControllerForResult` for launching a view controller.

#### Register

Via code:

```Swift
  let controllerManager = FRDControllerManager.sharedInstance
  controllerManager.register(URL(string: "/frodo/firstview")!, clazz: FirstViewController.self)
```

Via plist file:

```Swift
  let plistPath = Bundle.main.path(forResource: "FRDIntentRegisters", ofType: "plist")
  let controllerManager = FRDControllerManager.sharedInstance
  controllerManager.register(plistFile: plistPath)
```

#### Launch a view controller by class

```Swift
  let intent = FRDIntent(clazz: SecondViewController.self)
  let manager = FRDControllerManager.sharedInstance
  manager.startController(source: self, intent: intent)
```

#### Launch a view controller by url

```Swift
  let intent = FRDIntent(uri: URL(string: "/frodo/firstview")!)
  let manager = FRDControllerManager.sharedInstance
  manager.startController(source: self, intent: intent)
```

#### Launch a view controller and obtain the callback data

```Swift
  let intent = FRDIntent(clazz: ThirdViewController.self)
  intent.putExtra(name: "text", data: "Text From Source")
  let manager = FRDControllerManager.sharedInstance
  manager.startControllerForResult(source: self, intent: intent, requestCode: RequestText)
```

Someone, maybe the caller itself must conform with the `FRDIntentForResultSendable` protocol to get the callback data from the recipient. An `onControllerResult` method needs to be implemented to handle the return data.

```Swift
  extension ViewController: FRDIntentForResultSendable {

    func onControllerResult(requestCode: Int, resultCode: FRDResultCode, data: Intent) {
      if (requestCode == RequestText) {
        if (resultCode == .ok) {
          let text = data.extra["text"]
          print("Successful confirm get from destination : \(text)")
        } else if (resultCode == .canceled) {
          let text = data.extra["text"]
          print("Canceled get from destination : \(text)")
        }
      }
    }

  }
```

The recipient must conform with the `FRDIntentForResultReceivable` protocol to receive the Intent. `FRDIntentForResultReceivable` is a sub-protocol of `FRDIntentReceivable`. Two additional variables are needed:

```Swift
  var data: [String: Any]?
  var requestCode: Int?
```

#### Customize transition animation

In FRDIntent, the transition is abstracted as `FRDControllerDisplay` protocol. There are already two implementations: `FRDPushDisplay` and `FRDPresentationDisplay` of `FRDControllerDisplay`.

Your custom transition should conform this protocol `FRDControllerDisplay`. When the caller want to launch a view controller, set the `FRDIntent`'s `controllerDisplay` variable to the object presenting your custom tranistion.

FRDIntent's default transition is `FRDPushDisplay` within `starController`, or `FRDPresentationDisplay` within `startControllerForResult`.

## URLRoutes

FRDIntent/URLRoutes provides a router from URLs to the app's functional blocks. iOS provides a solution to launch an app from another app based on URL protocols. One may land on different pages based on the path and parameters passed with the URL. FRDIntent/URLRoutes takes advantage of this mechanism, and allows developers to easily define how to invoke functional blocks with URL.

In a sense, FRDIntent/URLRoutes is similar to many URL Routers in the community, [JLRoutes](https://github.com/joeldev/JLRoutes) for instance. But writing routes with FRDIntent/URLRoutes allows you to organically integrate the routes with FRDIntent/Intent, which makes it a lot simpler to navigate through internal calls and external calls.

### Usage

#### Set the url in Xcode

In Xcode, choose your Project's `Target`, then clcik `Info`, add a `URL Types`. For example:

- Identifier: com.frdintent
- URL Schemes: frdintent
- Role: Editor
- Icon:

#### Take over control of app's url call

````Swift
  func application(app: UIApplication, openURL url: URL, options: [String : AnyObject]) -> Bool {
    return FRDURLRoutes.sharedInstance.route(url: url)
  }
```

#### Register

Via code:

```Swift
  let routes = FRDURLRoutes.sharedInstance
  routes.register(url: URL(string: "/story/:storyId")!, clazz: SecondViewController.self)
```

Via plist file:

```Swift
  let plistPath = Bundle.main.path(forResource: "FRDURLRoutesRegisters", ofType: "plist")
  let routes = FRDURLRoutes.sharedInstance
  routes.register(plistFile: plistPath)
```

Register a block handler.

```Swift
  let router = FRDURLRoutes.sharedInstance
  router.register(url: URL(string: "/user/:userId")!) { (params: [String: Any]) in
    let intent = Intent(url: params[URLRoutes.URLRoutesURL] as! URL)
    if let topViewController = UIApplication.topViewController() {
      FRDControllerManager.sharedInstance.startController(source: topViewController, intent: intent)
    }
  }
```

### Get url parameters

FRDIntent/URLRoutes supports simple url parameter pattern match. In the example above, we register url with the pattern `"/story/:storyId"`, if there is an external call like `frdintent://frdintent.com/story/123`, FRDIntent/URLRoutes will save the key `storyId` and the value `123` into the block handler's parameter `params` that is a dictionary. We can get `123` from the dictionary `params` by key `storyId`.


## Notes

#### Prefix

Prefix is not necessary in Swift project because of Swift's visiblity declaration. But considering that this library will be used widely in Objective-C project, it's better to add `FRD` prefix to avoid the name conflict in Objective-C.

#### Type of `source` parameter

In the class `FRDControllerManager`, methods `startController(source: UIViewController, intent: FRDIntent)` and `startControllerForResult(source: UIViewController, intent: FRDIntent, requestCode: Int)` don't constrain view controller type of the `source` parameter. The precise type of `source` should be either `UIViewController<FRDIntentReceivable>` or `UIViewController<FRDIntentForResultReceivable>`, conforming with the accepted protocol.

In Swift, to add this constraint, we'd have to awkwardly implement some generic types, and what's even worse is that generic methods in Swift don't work in Objective-C. So the tradeoff is we only limit the `source` parameter to be a `UIViewController`, it's up to the developer to conform with the protocols and implement necessary methods as needed.


## Intent 和 URLRoutes

FRDIntent/Intent and FRDIntent/URLRoutes can interact with each other. FRIntent/Intent handles internal call and FRDIntent/URLRoutes handles external call. In the implementation of FRDIntent/URLRoutes, FRDIntent/URLRoutes only exposes the external call's entry. In the app, FRDIntent/Intent effectively handles the launch process for FRDIntent/URLRoutes.

The separation of FRDIntent/Intent and FRDIntent/URLRoutes is effectively the separation of internal and external calls. There are some advantages of this separation:

- FRDIntent/Intent can be at handling internal calls. It now supports transmission of complex data and customized transition animation. It will be more difficult to implement those with a simple URL Router solution.
- Seperation of internal calls and external calls makes sense. It makes it easier to choose which views can be exposed to external calls, and which are invokable by internal calls only.

## FRDIntentDemo

FRDIntent is written in Swift. FRDIntentDemo is implemented in Objective-C too demonstrate the library's compatibility with Objective-C.

To test external call, enter `frdintent://frdintent.com/user/123` in Safari's address bar. If everything goes fine, FRDIntentDemo will launch and display the FirstViewController.


## Unit Test

Rexxar iOS includes a suite of unit tests within the RexxarTests subdirectory.


## License

The MIT License.
