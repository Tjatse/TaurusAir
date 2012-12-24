//
//  AppEngine.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppEngine : NSObject

// fires after application was started.
-(void) startApp:(UIApplication *)uiApplication;

// fires after application was teminated.
-(void) stopApp:(UIApplication *)uiApplication;

// fires after application was paused.
-(void) pauseApp:(UIApplication *)uiApplication;

// fires after application was resumed.
-(void) resumeApp:(UIApplication *)uiApplication;

// Get instance;
+(AppEngine*) get;

@end
