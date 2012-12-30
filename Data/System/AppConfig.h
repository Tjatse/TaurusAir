//
//  AppConfig.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "StateBase.h"
#import "User.h"

#define STATE_NAMING_IMAGE_HANDLER_AC @"appConfig"

@interface AppConfig : StateBase

@property (nonatomic, retain) User                          *currentUser;
@property (nonatomic, readonly, getter = isLogon) BOOL      logon;

// Get Instance.
+(AppConfig*) get;
// Reset storage.
-(void) reset;
-(void) reset:(int)saveNumber;
// Load local storage.
-(void) loadState;
-(AppConfig *) loadState: (int)saveNumber;
// Save storage.
-(void) saveState;
-(void) saveState:(int)saveNumber;
// Clear cached data.
- (void) clear;
// destroy cached data and save to local storage.
- (void) destroy;

@end
