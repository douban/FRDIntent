# FRDIntent

[![Test Status](https://travis-ci.org/douban/FRDIntent.svg?branch=master)](https://travis-ci.org/douban/FRDIntent)
[![Language](https://img.shields.io/badge/language-Swift%203-orange.svg)
](https://developer.apple.com/swift/)
[![IDE](https://img.shields.io/badge/XCode-8-blue.svg)]()
[![iOS](https://img.shields.io/badge/iOS-8.0-green.svg)]()

**[README in English](./README_EN.md)**

**FRDIntent** 包括两部分 `FRDIntent/Intent` 和 `FRDIntent/URLRoutes`。它们分别可以用于处理 iOS 系统中，应用内和应用外的 view controller 调用。

`FRDIntent/Intent` 是一个消息传递对象，用于启动 UIViewController。可以认为它是对 Android 系统中的 [Intent](https://developer.android.com/guide/components/intents-filters.html) 的模仿。

`FRDIntent/URLRoutes` 是一个 URL Router。通过 FRDIntent/URLRoutes 可以用 URL 调起一个注册过的 block。

可以看出，FRDIntent/URLRoutes 和社区已经存在的诸多 URL Routers 的功能和目的差别不大。在 FRDIntent 中，实现 URLRoutes 是为了让 FRDIntent/URLRoutes 和 FRDIntent/Intent 一起配合解决应用内和应用外 view controller 的调用。Intent 处理内部 view controller 跳转；URLRoutes 负责外部调用。在 FRDIntent/URLRoutes 的实现中，FRDIntent/URLRoutes 只是起了暴露外部调用入口，接收外部调用的作用。在应用内，仍然是通过 FRDIntent/Intent 启动 view controller。也就是说外部调用实际上是通过内部调用实现的。

这么做其实是为了隔离了外部调用和内部调用，做这个区分会带来一些好处：

- iOS 系统提供的通过 URL 调用另外一个应用功能本身就是使用在应用间的。iOS 系统中，应用之间的隔离是清晰而明确的，通过 URL 在应用之间传递信息是合适的。但是，如果在应用内部调用也使用 URL 传递信息，就会带来诸多限制。Intent 更适合内部调用的场景。通过 Intent，可以传递复杂数据对象，可以较容易地定义转场动画。这些在 URL 方案中都很难做到。
- 区分了外部调用和内部调用。我们就可以选择是否将一个内部调用暴露给外部使用。这就避免了在 URL 的方案中，无法区分内部调用和外部调用，将本应只给内部使用的调用也暴露给了外部。


## 安装

### Install Cocoapods

[CocoaPods](http://cocoapods.org) 是一个 Objective-c 和 Swift 的依赖管理工具。你可以通过以下命令安装 CocoaPods：

```bash
$ gem install cocoapods
```

### Podfile

只使用 FRDInent/Intent：

```ruby
target 'TargetName' do
  pod 'FRDIntent/Intent', :git => 'https://github.com/douban/FRDIntent.git', :commit => '0.8.0'
end
```

使用 FRDIntent/Intent 和 FRDIntent/URLRoutes：

```ruby
target 'TargetName' do
  pod 'FRDIntent', :git => 'https://github.com/douban/FRDIntent.git', :commit => '0.8.0'
end
```

注意：`pod FRDInent` 和 `pod FRDIntent/URLRoutes` 将引入相同的代码。这是因为 FRDIntent/URLRoutes 依赖于 FRDIntent/Intent。

然后，命令行运行：

```bash
$ pod install
```

### 版本

版本选择：[https://github.com/douban/FRDIntent/releases](https://github.com/douban/FRDIntent/releases)。


## Intent

`FRDIntent/Intent` 是一个消息传递对象，用于启动 UIViewController。可以认为它是对 Android 系统中的 [Intent](https://developer.android.com/guide/components/intents-filters.html) 的模仿。当然，相对于 Android Intent，FRDIntent/Intent 做了极度简化。这是因为 FRDIntent/Intent 的使用场景更为简单：只处理应用内的 view controller 间跳转。

直接使用 iOS 系统方法完成各 view controller 之间的跳转，各 view controller 会耦合得很紧。跳转时，一个 view controller 需要知道下一个 view controller 是如何创建的各种细节。这造成了 view controller 之间的依赖。使用 FRDIntent/Intent 传递跳转信息，可以解除 view controller 之间的耦合。

如果需要对项目进行模块化，重要的一步就是解除各 view controller 之间的耦合。在这方面，FRDIntent 是一个可以考虑的方案。

FRDIntent/Intent 有如下优势：

- 充分解耦。调用者和被调用者完全隔离，被调用者只需要依赖协议：`FRDIntentReceivable`。一个 UIViewControlller 符合该协议即可被启动。
- 对于“启动一个页面，并从该页面获取结果”这种较普遍的需求提供了一个通用的解决方案。具体查看方法：startControllerForResult。这是对 Android 中 startActivityForResult 的模仿和简化。
- 支持自定义转场动画。
- 支持传递复杂数据对象。

### 使用

主要通过类 `FRDControllerManager` 使用 FRDIntent/Intent。它提供了三个方法：`register` 用于注册，`startController` 和 `startControllerForResult` 用于启动页面。

#### 注册

通过代码注册：

```Swift
  let controllerManager = FRDControllerManager.sharedInstance
  controllerManager.register(URL(string: "/frodo/firstview")!, clazz: FirstViewController.self)
```

通过 plist 文件批量注册：

```Swift
  let plistPath = Bundle.main.path(forResource: "FRDIntentRegisters", ofType: "plist")
  let controllerManager = FRDControllerManager.sharedInstance
  controllerManager.register(plistFile: plistPath)
```

#### 启动 view controller

通过指定类名启动 view controller:

```Swift
  let intent = FRDIntent(clazz: SecondViewController.self)
  let manager = FRDControllerManager.sharedInstance
  manager.startController(source: self, intent: intent)
```

通过 URL 启动 view controller:

```Swift
  let intent = FRDIntent(uri: URL(string: "/frodo/firstview")!)
  let manager = FRDControllerManager.sharedInstance
  manager.startController(source: self, intent: intent)
```

#### 启动一个会返回结果的 view controller

调用页面，该页面同时也是接受返回结果的页面。该 view controller 需要符合协议 `FRDIntentForResultSendable`：

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

被调用的 view controller 需要符合协议 `FRDIntentForResultReceivable`。该协议是 `FRDIntentReceivable` 的子协议。在 `FRDIntentReceivable` 基础上，多了两个实例变量定义：

```Swift
  var delegate: FRDIntentForResultSendable?
  var requestCode: Int?
```

通过 `startControllerForResult` 启动页面：

```Swift
  let intent = FRDIntent(clazz: ThirdViewController.self)
  intent.putExtra(name: "text", data: "Text From Source")
  let manager = FRDControllerManager.sharedInstance
  manager.startControllerForResult(source: self, intent: intent, requestCode: RequestText)
```

#### 自定义转场动画

在 FRDIntent 中，转场动画被抽象为协议：`FRDControllerDisplay`。自定义转场动画的实现需要符合该协议，并在启动页面时，将自定义的转场动画对象赋给 `FRDIntent` 的实例变量 `controllerDisplay` 即可完成转场动画的设置。

FRDIntent/Intent 已提供了两个转场动画的实现：`FRDPushDisplay` 和 `FRDPresentationDisplay`。如果不指定转场动画，通过 `startController` 启动页面使用的是 `FRDPushDisplay`；通过 `startControllerForResult` 启动页面使用的是 `FRDPresentationDisplay`。


## URLRoutes

`FRDIntent/URLRoutes` 是一个 URL Router。通过 FRDIntent/URLRoutes 可以用 URL 调起一个注册过的 block。

iOS 系统为各个应用间的相互调用提供了一种基于 URL 的处理方案。即应用可以声明自己可以处理某些有特定 scheme 和 host 的 URL。其他应用就可以通过调用这些 URL 而跳转到该应用的某些页面。

FRDIntent/URLRoutes 是为了使得 iOS 系统中这种基于 URL 的应用间调用的处理更为简单。所以 FRDIntent/URLRoutes 和社区已经存在的诸多 URL Routers 的功能和目的差别不大。FRDIntent 实现 URLRoutes 是为了使 FRDIntent/URLRoutes 可以和 FRDIntent/Intent 配合解决应用内和应用外 view controller 的调用。

### 使用

#### 向系统暴露应用可以接收的 URL

在 Xcode 中选择你的项目的 Target, 点击 Info, 添加一项 URL Types。
例如：

- Identifier: com.frdintent
- URL Schemes: frdintent
- Role: Editor
- Icon:

#### 接管应用的 URL 处理

```Swift
  func application(app: UIApplication, openURL url: URL, options: [String : AnyObject]) -> Bool {
    return FRDURLRoutes.sharedInstance.route(url: url)
  }
```

#### 注册

通过代码注册一个 view controler。在第三方应用调起该 URL 时，会启动该 view controller。该 view controller 的进入动画为 Push 横滑进入方式。

```Swift
  let routes = FRDURLRoutes.sharedInstance
  routes.register(url: URL(string: "/story/:storyId")!, clazz: SecondViewController.self)
```

通过 plist 文件批量注册，效果和上面通过代码注册一样。注册的 view controller 进入动画都为 Push 横滑进入方式。

```Swift
  let plistPath = Bundle.main.path(forResource: "FRDURLRoutesRegisters", ofType: "plist")
  let routes = FRDURLRoutes.sharedInstance
  routes.register(plistFile: plistPath)
```

注册一个 block handler。下面例子中的 block handler 中，用注册时的 URL 构造了一个 Intent，并将该 Intent 送出。FRDControllerManager 会处理这个 Intent。看是否有合适的 view controller 可以被启动。

如果，需要定制 view controller 的转场动画，可以使用该方法注册 URL。

```Swift
  let router = FRDURLRoutes.sharedInstance
  router.register(url: URL(string: "/user/:userId")!) { (params: [String: Any]) in
    let intent = Intent(url: params[URLRoutes.URLRoutesURL] as! URL)
    if let topViewController = UIApplication.topViewController() {
      FRDControllerManager.sharedInstance.startController(source: topViewController, intent: intent)
    }
  }
```

### 获取 URL 参数

FRDIntent/URLRoutes 支持简单的 URL 参数模式适配。上例中，我们以模式匹配的形式注册了 URL `"/story/:storyId"`。如有诸如 `frdintent://frdintent.com/story/123` 这样的外部调用，FRDIntent/URLRoutes 会将键 `storyId` 和值 `123` 存入 block handler 的参数 params 中。这样在 block handler 中就能通过键 `storyId` 获取值 `123`。


## 注意点

#### Prefix

Swift 由于有可见性声明，并无需前缀来避免命名冲突。所以，前缀在 Swift 项目中并不需要。但我们仍然为公开类都添加了`FRD`前缀。这是由于该库仍然主要供 Objective-C 项目使用，为了避免 Objective-C 代码的命名冲突，还是加上了前缀。

#### 参数 source 的类型

FRDControllerManager 的方法 `startControllerForResult(source: UIViewController, intent: FRDIntent, requestCode: Int)` 没有严格限制 `source` 参数类型。`source` 精确的类型应该分别是形如 `UIViewController<FRDIntentForResultSendable>` 所表达的：“这是一个类，并且符合一个协议”。这在 Swift 3 中，仍然需要别扭地使用泛型声明来实现。但这里使用泛型声明并不精确，同时更麻烦的是泛型方法无法暴露给 Objective-C 使用。因此，FRDIntent 做了折衷，`source` 类型只是 UIViewController。使用者需要自己保证它也是符合 `FRDIntentForResultSendable` 协议的。


## FRDIntentDemo

FRDIntentDemo 对 FRDIntent 各种使用方法都做了演示。FRDIntentDemo 使用 Objective-C 实现，这是为了演示 FRDIntent 虽然使用 Swift 完成，但是对 Objective-C 有良好的兼容。

对于外部调用的演示，可以在模拟器的 Safari 的地址栏中输入 `frdintent://frdintent.com/user/123`。正常情况下，访问该 URL 将会启动 FRDIntentDemo，并进入 FirstViewController。


## 单元测试

FRDIntentTests 文件夹包含了 FRDIntent 单元测试代码。单元测试不仅是对代码正确性的验证，也是查看如何使用 FRDIntent 的良好示例。


## License

The MIT license.
