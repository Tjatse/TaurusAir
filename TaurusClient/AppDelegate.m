//
//  AppDelegate.m
//  TaurusClient
//
//  Created by Simon on 12-12-10.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "AppDelegate.h"
#import "UIBGNavigationController.h"
#import "MainViewController.h"
#import "FSConfig.h"
#import "AppEngine.h"

@interface AppDelegate ()

@property (nonatomic, assign) UIBackgroundTaskIdentifier		bgTask;

@end

@implementation AppDelegate

- (void)dealloc
{
	[_window release];
	self.mainViewController = nil;
	self.navController = nil;
	
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[[FSConfig alloc] init] autorelease];
    
    [[AppEngine get] startApp:application];
	
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor clearColor];
	self.mainViewController = [[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil] autorelease];
	
	self.navController = [[[UIBGNavigationController alloc] initWithRootViewController:self.mainViewController] autorelease];
	self.window.rootViewController = self.navController;
	
    [self.window makeKeyAndVisible];
    
    // handle uncaught exception
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[AppEngine get] pauseApp:application];

	NSAssert(self.bgTask == UIBackgroundTaskInvalid, nil);
	
	self.bgTask = [application beginBackgroundTaskWithExpirationHandler: ^{
		dispatch_async(dispatch_get_main_queue(), ^{
			if (UIBackgroundTaskInvalid != self.bgTask) {
				
				[application endBackgroundTask:self.bgTask];
				self.bgTask = UIBackgroundTaskInvalid;
			}
		});
	}];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
				   ^{
					   dispatch_async(dispatch_get_main_queue(), ^{
						   if (UIBackgroundTaskInvalid != self.bgTask) {
                               
							   [application endBackgroundTask:self.bgTask];
							   self.bgTask = UIBackgroundTaskInvalid;
						   }
					   });
				   });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[AppEngine get] resumeApp:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	// TODO: 航班提醒处理
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[AppEngine get] stopApp:application];
}

static void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

@end
