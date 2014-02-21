//
//  SMMainController.h
//  SMC
//
//  Created by Ross Lefstin on 5/14/12.
//  Copyright (c) 2012 Tibco Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMNavigator.h"
#import "SMCDVCommandProperties.h"

@class SMApp;
@class SMMessage;


typedef enum SMControllerType
{
    SMControllerPortal,
    SMControllerMain,
    SMControllerMessage,
    SMControllerInfo
} SMControllerType;

@protocol SMMasterController <SMNavigator>

// Login, logout & app loading
- (void) presentStartPage:(BOOL)animated;
- (void) onLogin;

// App launching
- (void) launchApp:(SMApp *)app;
- (void) launchAppWithString:(NSString *)app callback:(SMCDVCommandProperties *)theCallback;
- (void) launchApp:(SMApp *)app withScript:(NSString *)script;
- (void) launchApp:(SMApp *)app withUrl:(NSString *)url;
- (void) viewMessagesForApp:(SMApp *)app;
- (void) viewMessage:(SMMessage *)message forApp:(SMApp *)app;
- (void) reloadApp;

- (BOOL) isAppVisible;
- (SMApp *) currentApp;

@property (nonatomic, readonly) UIView *view;

@end

@interface SMMasterController : NSObject

+ (id<SMMasterController>) controller;
+ (id<SMMasterController>) create:(UIApplication *)application bundle:(NSBundle *)bundle;
+ (void) destroy;

@end
