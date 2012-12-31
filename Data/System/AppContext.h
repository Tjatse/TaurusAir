//
//  AppContext.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavViewController.h"

@interface AppContext : NSObject

// Get a value indicating whether device network is available or not.
@property (nonatomic, readonly) BOOL online;

// Singleton instance.
+ (AppContext *) get;

@property (nonatomic, retain) NavViewController *navController;

@property (nonatomic, readonly) float 			currentLatitude;
@property (nonatomic, readonly) float 			currentLongitude;
@property (nonatomic, retain) NSString*			currentLocationGeocode;
@property (nonatomic, retain) NSString*			currentLocationCity;
@property (nonatomic, assign) BOOL				isLocationAvailable;

@end
