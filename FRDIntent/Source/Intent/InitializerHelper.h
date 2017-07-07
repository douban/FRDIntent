//
//  InitializerHelper.h
//  FRDIntent
//
//  Created by GUO Lin on 07/12/2016.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

@import UIKit;

@protocol FRDIntentReceivable;

NS_ASSUME_NONNULL_BEGIN

@interface InitializerHelper : NSObject

+ (nullable UIViewController<FRDIntentReceivable> *)viewControllerFromClazzName:(NSString *)clazzName
                                                                         extras:(NSDictionary<NSString *, id> *)extras;

+ (nullable UIViewController<FRDIntentReceivable> *)viewControllerFromClazz:(Class)clazz
                                                                     extras:(NSDictionary<NSString *, id> *)extras;

@end

NS_ASSUME_NONNULL_END
