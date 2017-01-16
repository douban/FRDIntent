//
//  MainViewController.m
//  FRDFRDIntent
//
//  Created by GUO Lin on 9/12/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//
#import <FRDIntent/FRDIntent-Swift.h>

#import "MainViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"

@interface MainViewController () <FRDIntentForResultSendable>
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
  [thirdbutton setTitle:@"FRDIntent for result" forState:UIControlStateNormal];
  thirdbutton.backgroundColor = [UIColor greenColor];
  [thirdbutton addTarget:self
                  action:@selector(gotoThirdViewController)
        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:thirdbutton];

  UIButton *fourthbutton = [UIButton buttonWithType:UIButtonTypeCustom];
  fourthbutton.frame = CGRectMake(20, 400, self.view.bounds.size.width - 40, 44);
  [fourthbutton setTitle:@"Check intent and dispatch" forState:UIControlStateNormal];
  fourthbutton.backgroundColor = [UIColor greenColor];
  [fourthbutton addTarget:self
                  action:@selector(gotoCheckAndDispatchViewController)
        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:fourthbutton];

}

- (void)gotoFirstViewController
{
  NSDictionary *datas = @{@"number": @1, FRDIntentParameters.title: @"First" };
  [self startControllerWithPathIdentifier:@"/user/3001?loc=beijing&uuid=10001#ref" extras:datas];
}

- (void)gotoSecondViewController
{
  FRDIntent *intent = [[FRDIntent alloc] initWithClazz:[SecondViewController  class]];
  [intent putExtraName:@"number" withValue:[NSNumber numberWithInteger:2]];
  [self startControllerWithIntent:intent];
}

- (void)gotoThirdViewController
{
  NSDictionary *datas = @{@"number": @3, FRDIntentParameters.title: @"Third" };
  [self startControllerForResultWithPathIdentifier:@"/user/2001/story/1001?loc=beijing&uuid=10001#ref"
                                            extras:datas
                                       requestCode:1];
}

- (void)gotoCheckAndDispatchViewController
{
  NSDictionary *datas = @{@"number": @4, FRDIntentParameters.title: @"First" };
  [self startControllerWithPathIdentifier:@"/subject/3001?loc=beijing&uuid=10001#ref" extras:datas];
}

#pragma mark - FRDIntentForResultSendable

- (void)onControllerResultWithRequestCode:(NSInteger)requestCode
                               resultCode:(enum FRDResultCode)code
                                     data:(FRDIntent *)intent
{
  if (requestCode == 1){
    if (code == FRDResultCodeOk) {
      NSString *text = [intent.extras objectForKey:@"text"];
      NSLog(@"Successful confirm get from destination : %@", text);
    } else if (code == FRDResultCodeCanceled) {
      NSString *text = intent.extras[@"text"];
      NSLog(@"Canceled confirm get from destination : %@", text);
    }
  }
}


@end
