//
//  CitySearchHelper.h
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class City;

@interface CitySearchHelper : NSObject

+ (City*)queryCityWithCityName:(NSString*)cityName;
+ (NSArray*)popularCities;
+ (NSArray*)queryCityWithFilterKey:(NSString*)filterKey;

@end
