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

@end
