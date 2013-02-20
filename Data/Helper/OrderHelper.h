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
@class FlightSelectViewController;

@interface OrderHelper : NSObject
+ (void)orderListWithUser: (User *)user
                  success: (void (^)(NSArray *orders))success
                  failure: (void (^)(NSString *errorMsg))failure;
+ (void)orderDetailWithId: (NSString *)orderId
                     user: (User *)user
                  success: (void (^)(NSDictionary *order))success
                  failure: (void (^)(NSString *errorMsg))failure;
+ (void)cancelWithId: (NSString *)orderId
                user: (User *)user
             success: (void (^)())success
             failure: (void (^)(NSString *errorMsg))failure;
+ (void)refundWithId: (NSString *)orderId
  passengerAndFlight: (NSString *)passengerAndFlight
       refundResonse: (NSString *)refundResonse
                user: (User *)user
             success: (void (^)())success
             failure: (void (^)(NSString *errorMsg))failure;

// GetCabinRemark
+ (void)performGetCabinRemark:(User*)user
                       andEzm:(NSString*)ezm
					 andCabin:(NSString*)cabin
					  success:(void (^)(NSDictionary *))success
					  failure:(void (^)(NSString *))failure;

// place order
+ (void)performPlaceOrderWithUser:(User*)user
					andFlightInfo:(NSArray*)flightInfos						// NSDictionary
						 andCabin:(NSArray*)cabins							// NSDictionary
					 andTravelers:(NSArray *)travelers
					 andContactor:(NSDictionary*)contactor
				   andSendAddress:(NSString*)sendAddress
						  success:(void (^)(NSDictionary *))success
						  failure:(void (^)(NSString *))failure;

// CreatePayUrl
+ (void)performCreatePayUrlOrderWithUser:(User*)user
					   andPlaceOrderJson:(NSDictionary*)placeOrderJson
					success:(void (^)(NSDictionary *))success
					failure:(void (^)(NSString *))failure;

// order
+ (void)performOrderWithPassangers:(NSDictionary*)passangers
					  andContactor:(NSDictionary*)contactor
					andSendAddress:(NSString*)sendAddress
	 andFlightSelectViewController:(FlightSelectViewController*)vc
						 andInView:(UIView*)inView
						  andPrice:(float)price
					andProductName:(NSString*)productName
					andProductDesc:(NSString*)productDesc;


@end
