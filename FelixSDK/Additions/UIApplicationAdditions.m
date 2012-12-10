//
//  UIApplicationAdditions.m
//  FelixSDK
//
//  Created by Yang Felix on 12-4-25.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import "UIApplicationAdditions.h"
#import "MBProgressHUD.h"
#import "FSTool.h"

static 	MBProgressHUD*			_hud;

@implementation UIApplication (Additions)

- (UIWindow *)mainWindow
{
	return [[self class] mainWindow];
}

+ (UIWindow*)mainWindow
{
	UIWindow* window = [UIApplication sharedApplication].keyWindow;	
    if (!window) {	
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];	
    }	
	
	return window;
}

+ (void)showBusyHUD
{
	[self showBusyHUD:nil];
}

+ (void)showBusyHUD:(UIView*)parentView
{
	[self showBusyHUD:parentView withTitle:nil];
}

+ (void)showBusyHUD:(UIView*)parentView 
		  withTitle:(NSString *)title
{
    if (_hud != nil) {
        [_hud removeFromSuperview];
		_hud.delegate = nil;
	    SAFE_RELEASE(_hud);
    }
	
	if (parentView == nil) {
		UIWindow* mainWindow = [UIApplication sharedApplication].mainWindow;	
		parentView = mainWindow;
	}
	
	_hud = [[MBProgressHUD alloc] initWithView:parentView];
    //HUD.delegate = self;
	_hud.removeFromSuperViewOnHide = YES;
	[parentView addSubview:_hud];
	[parentView bringSubviewToFront:_hud];
	
	if ([title length] > 0)
	    _hud.labelText = title;	
		
	[_hud show:YES];
}

+ (void)stopBusyHUD 
{
    if (_hud != nil) {
		_hud.delegate = nil;
	    [_hud hide:YES];
	}
}

+ (NSURL*)applicationDocumentsDirectory
{
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
