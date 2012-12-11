//
//  AppDelegate.h
//  TaurusClient
//
//  Created by Simon on 12-12-10.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIBGNavigationController;
@class MainViewController;

#define __APP_NAVVC__	(((AppDelegate*)([UIApplication sharedApplication].delegate)).navController)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow*						window;
@property (retain, nonatomic) MainViewController*			mainViewController;
@property (retain, nonatomic) UIBGNavigationController*		navController;

@end
