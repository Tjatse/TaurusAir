//
//  GeocodeHelper.h
//  TaurusClient
//
//  Created by Simon on 12-12-26.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OnGeocodeResponse)(NSString* address, NSString* city);

@interface GeocodeHelper : NSObject

+ (void)requestGeocodeWithLat:(float)lat
					   andLon:(float)lon
				  andComplete:(OnGeocodeResponse)complete;

@end
