//
//  AppDelegate.m
//  FRDIntent
//
//  Created by GUO Lin on 9/13/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "MainViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];

  MainViewController *controller = [[MainViewController alloc] init];

  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];

  self.window.rootViewController = nav;

  [self.window makeKeyAndVisible];

  [self configurationRoutes];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)configurationRoutes {

  // Internal call
  ControllerManager *controllerManager = [ControllerManager sharedInstance];
  [controllerManager registerWithUrl: [NSURL URLWithString: @"/user/:userId"] clazz: [FirstViewController class]];
  [controllerManager registerWithUrl: [NSURL URLWithString: @"/story/:storyId"] clazz: [SecondViewController class]];
  [controllerManager registerWithUrl: [NSURL URLWithString: @"/user/:userId/story/:storyId"] clazz: [ThirdViewController class]];


  // External call
//  let router = URLRouter.sharedInstance
//  router.register(url: NSURL(string: "/user/:userId/story/:storyId")!) { (params: [String: AnyObject]) in
//    let intent = Intent(url: params[URLRouter.URLRouterURL] as! NSURL)
//    intent.controllerDisplay = PresentationDisplay()
//    if let topViewController = UIApplication.topViewController() {
//      ControllerManager.sharedInstance.startController(source: topViewController, intent: intent)
//    }
//  }

  //[[URLRouter sharedInstance] registerWithUrl: [NSURL URLWithString: @"/story/:storyId"]  clazz: [SecondViewController self]];
}

@end
