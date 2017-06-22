//
//  FourthViewController.m
//  FRDIntent
//
//  Created by GUO Lin on 03/01/2017.
//  Copyright © 2017 Douban Inc. All rights reserved.
//
@import FRDIntent;
#import "FourthViewController.h"
#import "UIViewController+TopViewController.h"

@interface FourthViewController ()

@property (nonatomic, strong) NSDictionary<NSString *, id> *data;

@end

@implementation FourthViewController

- (id)initWithExtras:(NSDictionary<NSString *,id> *)extras {
  self = [super init];
  if (self) {
    _data = extras;
  }
  return self;
}

- (BOOL)validate:(FRDIntent *)intent {
  // Check intent
  NSLog(@"validate url: %@", intent.url);
  NSLog(@"validate extras: %@", intent.extras);

  // Dispatch to another view controller
  NSDictionary *datas = @{FRDIntentParameters.title: @"First by dispatch"};
  UIViewController *topViewController = [UIViewController topViewController];
  [topViewController startControllerWithPathIdentifier:@"/user/3001?loc=beijing&uuid=10001#ref" extras:datas];

  // must return false to prevent push self view controller.
  return false;
}

@end
