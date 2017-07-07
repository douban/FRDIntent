//
//  ThirdViewController.m
//  FRDIntent
//
//  Created by GUO Lin on 9/13/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSDictionary<NSString *, id> *data;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, assign) NSInteger requestCode;
@property (nonatomic, weak) id<FRDIntentForResultSendable> delegate;


@end

@implementation ThirdViewController

- (id)initWithExtras:(NSDictionary<NSString *,id> *)extras {
  self = [super init];
  if (self) {
    _data = extras;
    [self setupExtras:extras];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];

  UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                         target:self
                                                                         action:@selector(dismiss:)];
  self.navigationItem.leftBarButtonItem = dismiss;

  UIBarButtonItem *confirm = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                           target:self
                                                                           action:@selector(confirm:)];

  self.navigationItem.rightBarButtonItem = confirm;

  self.textField = [[UITextField alloc] init];
  self.textField.frame = CGRectMake(10, 100, self.view.bounds.size.width - 20, 44);
  self.textField.backgroundColor = [UIColor lightGrayColor];
  self.textField.clearButtonMode = UITextFieldViewModeAlways;
  self.textField.returnKeyType = UIReturnKeyDone;
  self.textField.delegate = self;
  [self.view addSubview: self.textField];


  UILabel *numberLabel = [[UILabel alloc] init];
  numberLabel.frame = CGRectMake(20, 100, self.view.bounds.size.width - 40, 400);
  numberLabel.textAlignment = NSTextAlignmentCenter;
  numberLabel.numberOfLines = 0;
  if (self.data) {
    numberLabel.text = [NSString stringWithFormat:@"%@", self.data];
  }
  [self.view addSubview:numberLabel];
}

- (void)dismiss:(id)sender {
  [self dismissViewControllerAnimated:YES completion:NULL];

  if (self.delegate) {
    NSDictionary *data = @{@"text": self.textField.text ?: @""};
    [self.delegate controllerDidReturnWithReqeustCode:self.requestCode resultCode:FRDResultCodeCanceled data:data];
  }
}

- (void)confirm:(id)sender {
  [self dismissViewControllerAnimated:YES completion:NULL];
  if (self.delegate) {
    NSDictionary *data = @{@"text": self.textField.text ?: @""};
    [self.delegate controllerDidReturnWithReqeustCode:self.requestCode resultCode:FRDResultCodeOk data:data];
  }
}

#pragma mark = IntentForResultReceivable 

- (void)setRequestCode:(NSInteger)requestCode
{
  _requestCode = requestCode;
}

- (void)setDelegate:(__strong id<FRDIntentForResultSendable> )delegate
{
  _delegate = delegate;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self dismiss:textField];
  return YES;
}

@end
