//
//  SMRuntime.h
//  SilverMobileCoreRuntime
//
//  Created by Ross Lefstin on 8/10/12.
//  Copyright (c) 2012 Tibco Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIApplication;

@class SMApp;
@class SMAppManager;
@class SMUpdatePoller;
@class SMExtensionCatalog;
@class SMHttpOperationLoggingDelegate;
@class SMCDVCommandProperties;

@protocol SMLoginDelegate;
@protocol SMNavigator;

@protocol SMRuntime <NSObject>

// Connection/App information
@property (nonatomic, readonly) NSURL *smnetUrl;
@property (nonatomic, readonly) NSURL *serverUrl;
@property (nonatomic, readonly) NSString *applicationName;
@property (nonatomic, readonly) NSString *userName;
@property (nonatomic, readonly) NSString *password;
@property (nonatomic, readonly) NSString *firstname;
@property (nonatomic, readonly) NSString *lastname;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) NSString *fixedServer;
@property (nonatomic, readonly) NSString *startPage;
@property (nonatomic, readonly) NSString *portalPage;
@property (nonatomic, readwrite) NSString *appPage;
@property (nonatomic, readonly) BOOL showRefreshButton;
@property (nonatomic, readonly) BOOL showToolbar;
@property (nonatomic, readonly) BOOL showPortalTab;
@property (nonatomic, readonly) BOOL showErrorDialog;
@property (nonatomic, readonly) BOOL showMessageView;
@property (nonatomic, readonly) BOOL isInSoloMode;
@property (nonatomic, readwrite) BOOL isLoggedIn;
@property (nonatomic, readonly) BOOL isOfflineAllowed;
@property (nonatomic, readonly) BOOL didStartOffline;
@property (nonatomic, readonly) NSDictionary *customizationMap;
@property (nonatomic, readonly) NSURLRequestCachePolicy cachePolicy;


// Singleton objects
@property (nonatomic, readonly) NSString *javascriptInjection;
@property (nonatomic, readonly) SMAppManager *appManager;
@property (nonatomic, readonly) SMUpdatePoller *updatePoller;
@property (nonatomic, readonly) SMExtensionCatalog *extensionCatalog;
@property (nonatomic, readonly) SMHttpOperationLoggingDelegate *httpDelegate;

@property (nonatomic, assign) id<SMNavigator> navigator;

@property (nonatomic, readwrite) BOOL isOffline;


- (void) attemptLogin:(NSString *)serviceUrl username:(NSString *)username password:(NSString *)password passcode:(NSString*) passcode delegate:(id<SMLoginDelegate>)delegate;
- (void) attemptOfflineStart:(NSString *)serviceUrl username:(NSString *)username password:(NSString *)password delegate:(id<SMLoginDelegate>)delegate;
- (NSData *) getCachedResponse:(NSURLRequest *)request;
- (NSData *) getCachedFetchAppsResponse;
- (void) updateCachedFetchAppsResponse:(NSData *)apps;
- (void) fetchActualURLForApp:(SMApp *)app;
- (void) storeActualURLForApp:(SMApp *)app;
- (void) fetchMessagesForApp:(SMApp *)app;
- (void) storeMessagesForApp:(SMApp *)app;
- (void) storeActualURLForStartPage:(NSString *)app;
- (void) storeActualURLForPortalPage:(NSString *)app;

- (void) onInitialAppLoadCompleted;
- (void) updateApplicationBadge;

- (void) setDevToken:(NSString *)devToken;
- (NSString *) devToken;

- (void) shutdown;
- (void) pause;
- (void) resume;
- (void) disconnected;

- (NSURL *) synthesizeNetUrl:(NSString *)path;
- (NSURL *) synthesizeServerUrl:(NSString *)path;

- (BOOL) getCustomizationDimension:(CGFloat *)dimension forOrientation:(UIInterfaceOrientation)orientation forKey:(NSString *)key;

- (void) invokeErrorHandler:(NSString *)message errorCode:(int) code;
- (void) invokeErrorHandler:(NSString *)message handler:(SMCDVCommandProperties*) callback;


@end

// Provides management of the runtime
@interface SMRuntime : NSObject

+ (id<SMRuntime>) runtime;
+ (id<SMRuntime>) initialize:(UIApplication *)application;
+ (void) destroy;

+ (NSBundle *) bundle;
+ (NSBundle *) customizationBundle;

+ (NSString *) customizationProperty:(NSString *)name;

@end
