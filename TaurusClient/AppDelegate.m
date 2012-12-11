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
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    self.window.backgroundColor = [UIColor clearColor];
	self.mainViewController = [[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil] autorelease];
	
	self.navController = [[[UIBGNavigationController alloc] initWithRootViewController:self.mainViewController] autorelease];
	self.window.rootViewController = self.navController;
	
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
