//
//  UIApplicationAdditions.h
//  FelixSDK
//
//  Created by Yang Felix on 12-4-25.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Additions)

@property (nonatomic, readonly) UIWindow* mainWindow;

+ (UIWindow*)mainWindow;
+ (void)showBusyHUD:(UIView*)parentView;
+ (void)showBusyHUD:(UIView*)parentView withTitle:(NSString*)title;
+ (void)showBusyHUD;
+ (void)stopBusyHUD;
+ (NSURL*)applicationDocumentsDirectory;

@end
