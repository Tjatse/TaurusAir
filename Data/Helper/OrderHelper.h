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
@class User;

@interface OrderHelper : NSObject
+ (void)orderListWithId: (NSString *)userId
                success: (void (^)(NSArray *orders))success
                failure: (void (^)(NSString *errorMsg))failure;
+ (void)orderDetailWithId: (NSString *)orderId
                   userId: (NSString *)userId
                success: (void (^)(NSDictionary *order))success
                failure: (void (^)(NSString *errorMsg))failure;

// place order
+ (void)performPlaceOrder:(NSArray*)twoCharCodes		// TwoCharCode
		 andThreeCharCode:(NSArray*)threeCharCodes		// ThreeCharCode
				 andCabin:(NSArray*)cabins				// NSDictionary
			  andDateTime:(NSArray*)departureTimes		// NSDate
				  andUser:(User *)user
				  success:(void (^)(NSDictionary* respObj))success
				  failure:(void (^)(NSString* errorMsg))failure;

@end
