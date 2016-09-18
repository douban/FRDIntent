//
//  FRDControllerManager.m
//  FRDIntent
//
//  Created by GUO Lin on 9/14/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

@import UIKit;

#import <FRDIntent/FRDIntent-Swift.h>

#import "FRDControllerManager.h"


@implementation FRDControllerManager

+ (instancetype)sharedInstance
{
  static dispatch_once_t onceToken;
  static id instance;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}


- (void)registerWithUrl:(NSURL *)url clazz:(Class<IntentReceivable>)clazz
{
  [[ControllerManager sharedInstance] registerWithUrl:url clazz:clazz];
}

- (void)startControllerWithSource:(UIViewController *)source intent:(Intent *)intent
{
  [[ControllerManager sharedInstance] startControllerWithSource:source intent:intent];
}

- (void)startControllerForResultWithSource:(UIViewController<IntentForResultSendable> *)source
                                    intent:(Intent *)intent
                               requestCode:(NSInteger)requestCode
{
  [[ControllerManager sharedInstance] startControllerForResultWithSource:source
                                                                  intent:intent
                                                             requestCode:requestCode];
}

@end
