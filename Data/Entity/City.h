//
//  City.h
//  TaurusClient
//
//  Created by Simon on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ThreeCharCode;

@interface City : NSObject

@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSArray *threeCharCodes;
- (id)initWithCityName:(NSString*)aCityName threeCharCodes:(NSArray*)aThreeCharCodes;

- (void)appendThreeCharCode:(ThreeCharCode*)item;

@end
