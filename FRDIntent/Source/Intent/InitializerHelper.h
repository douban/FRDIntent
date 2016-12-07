//
//  InitializerHelper.h
//  FRDIntent
//
//  Created by GUO Lin on 07/12/2016.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

@import UIKit;

@protocol FRDIntentReceivable;
@interface InitializerHelper : NSObject

+ (nullable UIViewController<FRDIntentReceivable> *)viewControllerFromwClazzName:(nonnull NSString *)clazzName
                                                                           extras:(nullable NSDictionary<NSString *, id> *)extras;

+ (nullable UIViewController<FRDIntentReceivable> *)viewControllerFromwClazz:(nonnull Class)clazz
                                                                      extras:(nullable NSDictionary<NSString *, id> *)extras;

@end
