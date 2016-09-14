//
//  FRDControllerManager.h
//  FRDIntent
//
//  Created by GUO Lin on 9/14/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

@import UIKit;

@class Intent;

@protocol IntentReceivable;
@protocol IntentForResultSendable;


/**
 FRDControllerManager is Objective-C wrapper of ControllerManager.
 @see ControllerManager
 */
@interface FRDControllerManager : NSObject

+ (instancetype)sharedInstance;

/**
 Registers a url for calling handler blocks.

 - parameter url: The url to be registered.
 - parameter clazz: The clazz to be registered, and the clazz's view controller object will be launched while routed.
 */
- (void)registerWithUrl:(NSURL *)url clazz:(Class<IntentReceivable>)clazz;

/**
 Launch a view controller from source view controller with a intent.
 
 - parameter source: The source view controller.
 - parameter intent: The intent for launch a new view controller.
 */
- (void)startControllerWithSource:(UIViewController *)source intent:(Intent *)intent;

/**
 Launch a view controller for which you would like a result when it finished. When this view controller exits, your onControllerResult() method will be called with the given requestCode.

 - parameter source: The source view controller.
 - parameter intent: The intent for start new view controller.
 - parameter requestCode : this code will be returned in onControllerResult() when the view controller exits.
 */
- (void)startControllerForResultWithSource:(UIViewController<IntentForResultSendable> *)source
                                    intent:(Intent *)intent
                               requestCode:(NSInteger)requestCode;

@end
