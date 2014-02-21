//
//  SMCoreUI.h
//  SMCoreUI
//
//  Created by Ross Lefstin on 8/9/12.
//  Copyright (c) 2012 Tibco Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCoreUI : NSObject

+ (void) startSilverMobile:(UIApplication *)application;
+ (void) pauseSilverMobile;
+ (void) resumeSilvermobile;
+ (void) stopSilverMobile;
+ (void) destroy;
+ (void) setDeviceToken:(NSData *)devToken;

+ (NSString *) version;
+ (NSBundle *) bundle;

+ (UIImage *) imageNamed:(NSString *)imageName;
+ (UIImage *) imageNamed:(NSString *)imageName error:(NSError **)error;

@end
