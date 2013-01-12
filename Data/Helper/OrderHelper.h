//
//  OrderHelper.h
//  TaurusClient
//
//  Created by Tjatse on 13-1-4.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ThreeCharCode;
@class TwoCharCode;
@class ContacterHelper;
@class User;

@interface OrderHelper : NSObject
+ (void)orderListWithUser: (User *)user
                  success: (void (^)(NSArray *orders))success
                  failure: (void (^)(NSString *errorMsg))failure;
+ (void)orderDetailWithId: (NSString *)orderId
                     user: (User *)user
                  success: (void (^)(NSDictionary *order))success
                  failure: (void (^)(NSString *errorMsg))failure;

// place order
+ (void)performPlaceOrderWithFlightInfo:(NSArray*)flightInfos						// NSDictionary
							   andCabin:(NSArray*)cabins							// NSDictionary
						   andTravelers:(NSArray *)travelers
						   andContactor:(NSDictionary*)contactor
								success:(void (^)(NSDictionary *))success
								failure:(void (^)(NSString *))failure;

// CreatePayUrl
+ (void)performCreatePayUrl:(NSDictionary*)placeOrderJson
					success:(void (^)(NSDictionary *))success
					failure:(void (^)(NSString *))failure;

@end
