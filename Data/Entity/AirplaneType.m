//
//  AirplaneType.m
//  TaurusClient
//
//  Created by Simon on 13-1-12.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "AirplaneType.h"

@implementation AirplaneType

@synthesize tid;
@synthesize shortModel;
@synthesize remark;
@synthesize planeType;

//===========================================================
// - (id)initWith:
//
//===========================================================
- (id)initWithTid:(NSString*)aTid shortModel:(NSString*)aShortModel remark:(NSString*)aRemark planeType:(NSString*)aPlaneType
{
    self = [super init];
    if (self) {
        self.tid = aTid;
        self.shortModel = aShortModel;
        self.remark = aRemark;
        self.planeType = aPlaneType;
    }
    return self;
}


//===========================================================
// dealloc
//===========================================================
- (void)dealloc
{
    self.tid = nil;
    self.shortModel = nil;
    self.remark = nil;
    self.planeType = nil;
	
    [super dealloc];
}

@end
