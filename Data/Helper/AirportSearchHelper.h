//
//  AirportSearchHelper.h
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TwoCharCode;

@interface AirportSearchHelper : NSObject

+ (TwoCharCode*)queryWithTwoCharCodeString:(NSString*)key;

@end
