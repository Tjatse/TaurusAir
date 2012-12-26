//
//  CityGroup.m
//  TaurusClient
//
//  Created by Simon on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "CityGroup.h"

@implementation CityGroup

@synthesize groupName;
@synthesize cities;

//===========================================================
// - (id)initWith:
//
//===========================================================
- (id)initWithGroupName:(NSString*)aGroupName cities:(NSArray*)aCities
{
    self = [super init];
    if (self) {
        self.groupName = aGroupName;
        self.cities = aCities;
    }
    return self;
}


//===========================================================
// dealloc
//===========================================================
- (void)dealloc
{
    self.groupName = nil;
    self.cities = nil;
	
    [super dealloc];
}

- (void)appendCity:(City*)item
{
	if (self.cities == nil)
		self.cities = [NSMutableArray array];
	
	[(NSMutableArray*)self.cities addObject:item];
}


@end
