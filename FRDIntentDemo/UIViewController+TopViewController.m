//
//  UIViewController+TopViewController.m
//  FRDIntent
//
//  Created by GUO Lin on 03/01/2017.
//  Copyright © 2017 Douban Inc. All rights reserved.
//

#import "UIViewController+TopViewController.h"

@implementation UIViewController (TopViewController)

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
