//
//  AirplaneTypeHelper.h
//  TaurusClient
//
//  Created by Simon on 13-1-12.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AirplaneType.h"
#import "FlightSelectViewController.h"

@interface AirplaneTypeHelper : NSObject

@property (nonatomic, retain) NSDictionary*		allAirplaneType;

+ (id)sharedHelper;

@end


@interface AirplaneType (FriendlyPlaneType)

@property (nonatomic, readonly) NSString*	friendlyPlaneType;
@property (nonatomic, readonly) FlightSelectPlaneFilterType	friendlyPlaneFilterType;

@end