//
//  CharCodeHelper.h
//  TaurusClient
//
//  Created by Simon on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwoCharCode.h"
#import "ThreeCharCode.h"

@class City;

@interface CharCodeHelper : NSObject

+ (NSArray*)allTwoCharCodes;
+ (NSArray*)allThreeCharCodes;
+ (NSDictionary*)allTwoCharCodesDictionary;
+ (NSDictionary*)allThreeCharCodesDictionary;
+ (NSDictionary*)allCities;
+ (NSArray*)allCityGroups;
+ (NSDictionary*)allOrderStates;

+ (NSArray*)parseContentOfCSVFile:(NSString*)filePath;

@end

typedef enum tagFlightAreaType
{
	kFlightAreaTypeInternal = 1
	, kFlightAreaTypeGlobal = 2
} FlightAreaType;

@interface TwoCharCode (FriendlyFlightAreaCode)

@property (nonatomic, readonly) FlightAreaType	flightArea;

@end

@interface ThreeCharCode (FriendlyFlightAreaCode)

@property (nonatomic, readonly) FlightAreaType	flightArea;

@end