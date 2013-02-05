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
#import "AlixPay.h"
#import "AlixPayHelper.h"
#import "AppDefines.h"
#import "DataVerifier.h"

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
	[[UIApplication sharedApplication] cancelLocalNotification:notification];
	
	NSLog(@"df");
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	[self parseURL:url application:application];
	return YES;
}

- (void)parseURL:(NSURL *)url application:(UIApplication *)application
{
	AlixPay *alixpay = [AlixPay shared];
	AlixPayResult *result = [alixpay handleOpenURL:url];
	if (result) {
		//是否支付成功
		if (9000 == result.statusCode) {
			/*
			 *用公钥验证签名
			 */
			id<DataVerifier> verifier = CreateRSADataVerifier(kAlixPayRSAPublicKey);
			if ([verifier verifyString:result.resultString withSign:result.signString]) {
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																	 message:@"支付成功。" //result.statusMessage
																	delegate:nil
														   cancelButtonTitle:@"确定"
														   otherButtonTitles:nil];
				[alertView show];
				[alertView release];
				
				[AlixPayHelper alixPayCallback:YES];
			}//验签错误
			else {
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																	 message:@"签名错误"
																	delegate:nil
														   cancelButtonTitle:@"确定"
														   otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}
		}
		//如果支付失败,可以通过result.statusCode查询错误码
		else {
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																 message:result.statusMessage
																delegate:nil
													   cancelButtonTitle:@"确定"
													   otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		
	}
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
