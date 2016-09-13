//
//  FirstViewController.m
//  FRDIntent
//
//  Created by GUO Lin on 9/13/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

#import "FirstViewController.h"


@interface FirstViewController ()

@property (nonatomic, strong) NSDictionary<NSString *, id> *data;

@end

@implementation FirstViewController

- (id)initWithExtras:(NSDictionary<NSString *,id> *)extras {
  self = [super init];
  if (self) {
    _data = extras;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"First View Controller";
  self.view.backgroundColor = [UIColor whiteColor];

  UILabel *numberLabel = [[UILabel alloc] init];
  numberLabel.frame = CGRectMake(20, 100, self.view.bounds.size.width - 40, 400);
  numberLabel.textAlignment = NSTextAlignmentCenter;
  numberLabel.numberOfLines = 0;
  if (self.data) {
    numberLabel.text = [NSString stringWithFormat:@"%@", self.data];
  }
  [self.view addSubview:numberLabel];
}

@end
