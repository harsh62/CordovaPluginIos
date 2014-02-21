//
//  SMNavigator.h
//  SMC
//
//  Created by Ross Lefstin on 8/10/12.
//  Copyright (c) 2012 Tibco Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMNavigator <NSObject>

- (void) navigateToStartPage;
- (void) navigateToApp;
- (void) navigateToMessages;
- (void) navigateToInfo;
- (void) logout;
- (void) logoutAndStart;
- (void) login:(NSString *) username password:(NSString *) pswd url:(NSString *)server passcode:(NSString *)pcode;
- (void) navigateToPortal;
- (void) reloadApp;
- (void) quit;

@optional
- (void) onRuntimeDisconnected:(BOOL)showAlert;
- (void) onRuntimeShutdown;
- (void) onRuntimePause;
- (void) onRuntimeResume;

@end
