//
//  InitializerHelper.m
//  FRDIntent
//
//  Created by GUO Lin on 07/12/2016.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

#import "InitializerHelper.h"
#import <FRDIntent/FRDIntent-Swift.h>

@implementation InitializerHelper

+ (UIViewController<FRDIntentReceivable> *)viewControllerFromClazzName:(NSString *)clazzName
                                                                extras:(NSDictionary<NSString *, id> *)extras
{
  Class clazz = NSClassFromString(clazzName);
  id<FRDIntentReceivable> initObj = [clazz alloc];
  UIViewController<FRDIntentReceivable> *vc = (UIViewController<FRDIntentReceivable> *)[initObj initWithExtras:extras];
  return vc;
}

+ (UIViewController<FRDIntentReceivable> *)viewControllerFromClazz:(Class)clazz
                                                            extras:(NSDictionary<NSString *, id> *)extras
{
  id<FRDIntentReceivable> initObj = [clazz alloc];
  UIViewController<FRDIntentReceivable> *vc = (UIViewController<FRDIntentReceivable> *)[initObj initWithExtras:extras];
  return vc;
}


@end
