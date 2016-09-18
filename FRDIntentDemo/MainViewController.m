//
//  MainViewController.m
//  FRDIntent
//
//  Created by GUO Lin on 9/12/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//
#import <FRDIntent/FRDControllerManager.h>
#import <FRDIntent/FRDIntent-Swift.h>

#import "MainViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface MainViewController () <IntentForResultSendable>
@end

@implementation MainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];

  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(20, 100, self.view.bounds.size.width - 40, 44);
  [button setTitle:@"By Uri" forState:UIControlStateNormal];
  button.backgroundColor = [UIColor greenColor];
  [button addTarget:self
             action:@selector(gotoFirstViewController)
   forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button];

  UIButton *secondbutton = [UIButton buttonWithType:UIButtonTypeCustom];
  secondbutton.frame = CGRectMake(20, 200, self.view.bounds.size.width - 40, 44);
  [secondbutton setTitle:@"By Class Name" forState:UIControlStateNormal];
  secondbutton.backgroundColor = [UIColor greenColor];
  [secondbutton addTarget:self
                   action:@selector(gotoSecondViewController)
         forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:secondbutton];

  UIButton *thirdbutton = [UIButton buttonWithType:UIButtonTypeCustom];
  thirdbutton.frame = CGRectMake(20, 300, self.view.bounds.size.width - 40, 44);
  [thirdbutton setTitle:@"Intent for result" forState:UIControlStateNormal];
  thirdbutton.backgroundColor = [UIColor greenColor];
  [thirdbutton addTarget:self
                  action:@selector(gotoThirdViewController)
        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:thirdbutton];

}

- (void)gotoFirstViewController
{
  //Intent *intent = [[Intent alloc] initWithUrl:[NSURL URLWithString:@"/user/3001?loc=beijing&uuid=10001#ref"]];
  Intent *intent = [[Intent alloc] initWithPathIdentifier:@"/user/3001?loc=beijing&uuid=10001#ref"];
  [intent putExtraWithName:@"number" data: [NSNumber numberWithInteger:1]];
  [self startControllerWithIntent: intent];
}

- (void)gotoSecondViewController
{
  Intent *intent = [[Intent alloc] initWithClazz:[SecondViewController  class]];
  [intent putExtraWithName:@"number" data: [NSNumber numberWithInteger:2]];
  [self startControllerWithIntent:intent];
}

- (void)gotoThirdViewController
{
  Intent *intent = [[Intent alloc] initWithClazz:[ThirdViewController  class]];
  [intent putExtraWithName:@"number" data: [NSNumber numberWithInteger:3]];
  [self startControllerForResultWithIntent:intent requestCode:1];
}

#pragma mark - IntentForResultSendable

- (void)onControllerResultWithRequestCode:(NSInteger)requestCode resultCode:(enum ResultCode)code data:(Intent *)intent
{
  if (requestCode == 1){
    if (code == ResultCodeOk) {
      NSString *text = [intent.extras objectForKey:@"text"];
      NSLog(@"Successful confirm get from destination : %@", text);
    } else if (code == ResultCodeCanceled) {
      NSString *text = intent.extras[@"text"];
      NSLog(@"Canceled confirm get from destination : %@", text);
    }
  }
}


@end
