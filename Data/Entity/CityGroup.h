//
//  CityGroup.h
//  TaurusClient
//
//  Created by Simon on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class City;

@interface CityGroup : NSObject

@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) NSArray *cities;
- (id)initWithGroupName:(NSString*)aGroupName cities:(NSArray*)aCities;

- (void)appendCity:(City*)city;

@end
