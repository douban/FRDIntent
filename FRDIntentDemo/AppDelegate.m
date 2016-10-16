//
//  AppDelegate.m
//  FRDIntent
//
//  Created by GUO Lin on 9/13/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

#import <FRDIntent/FRDIntent-Swift.h>
#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "MainViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"


@interface UIApplication (topViewController)

+ (UIViewController *)topViewController;

@end

@implementation UIApplication (topViewController)

+ (UIViewController *)topViewController
{
  return [self _frd_visibleViewControllerFrom:[UIApplication sharedApplication].keyWindow.rootViewController];
}


+ (UIViewController *)_frd_visibleViewControllerFrom:(UIViewController *)vc
{
  if ([vc isKindOfClass:[UINavigationController class]]) {
    return [self _frd_visibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
  }

  if ([vc isKindOfClass:[UITabBarController class]]) {
    return [self _frd_visibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
  }

  if (vc.presentedViewController) {
    return [self _frd_visibleViewControllerFrom:vc.presentedViewController];
  }

  return vc;

}

@end


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

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
  return [[FRDURLRoutes sharedInstance] routeWithUrl:url];
}


- (void)configurationRoutes {

  // Internal call register
  //[[FRDControllerManager sharedInstance] registerWithUrl: [NSURL URLWithString: @"/user/:userId"] clazz: [FirstViewController class]];
  //[[FRDControllerManager sharedInstance] registerWithUrl: [NSURL URLWithString: @"/story/:storyId"] clazz: [SecondViewController class]];
  //[[FRDControllerManager sharedInstance] registerWithUrl: [NSURL URLWithString: @"/user/:userId/story/:storyId"] clazz: [ThirdViewController class]];

  // Internal call register by plist
  NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"FRDIntentRegisters" ofType:@"plist"];
  [[FRDControllerManager sharedInstance] registersWithPlistFile:plistPath];



  // External call register
  [[FRDURLRoutes sharedInstance] registerWithUrl:[NSURL URLWithString:@"/user/:userId/story/:storyId"]
                                         handler:^(NSDictionary<NSString*, id> *params)
  {
    NSURL *url = [params objectForKey:FRDRouteParameters.URLRouteURL];
    FRDIntent *intent = [[FRDIntent alloc] initWithUrl:url];
    intent.controllerDisplay = [[FRDPresentationDisplay alloc] init];
    UIViewController *topViewController = [UIApplication topViewController];
    if (topViewController) {
      [[FRDControllerManager sharedInstance] startControllerWithSource:topViewController intent:intent];
    }
  }];


  // External call register
  //[[FRDURLRoutes sharedInstance] registerWithUrl:[NSURL URLWithString: @"/story/:storyId"]
  //                                         clazz:[SecondViewController self]];

  // External call register by plist
  NSString* routesPlistPath = [[NSBundle mainBundle] pathForResource:@"FRDURLRoutesRegisters" ofType:@"plist"];
  [[FRDURLRoutes sharedInstance] registersWithPlistFile:routesPlistPath];
}

@end
