//
//  OrderHelper.m
//  TaurusClient
//
//  Created by Tjatse on 13-1-4.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "OrderHelper.h"
#import "AppContext.h"
#import "AppDefines.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "NSDictionaryAdditions.h"
#import "BBlock.h"

#import "ThreeCharCode.h"
#import "TwoCharCode.h"

@interface OrderHelper(Private)
+ (id)dummy: (NSString *)key;
@end

@implementation OrderHelper
#pragma mark Dummy Data
+ (id)dummy: (NSString *)key
{
    NSString *path = [[NSBundle mainBundle] pathForResource:key ofType:@"json"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    
    return [content objectFromJSONString];
}

#pragma mark - Order List
+ (void)analyzeOrderListRet: (id)JSON
                    success: (void (^)(NSArray *results))success
                    failure: (void (^)(NSString *errorMsg))failure;
{
    if (JSON == [NSNull null] || JSON == nil) {
        failure(@"无法连接服务器。");
    }else{
        NSDictionary *meta= [JSON objectForKey:@"Meta"];
        
        if ([[meta getStringValueForKey:@"Method" defaultValue:@""] isEqualToString: @"GetTicketOrdersByCondition"] && [[meta getStringValueForKey:@"Status" defaultValue:@"fail"] isEqualToString:@"ok"]){
            NSArray *resp = [JSON objectForKey:@"Response"];
            if(resp) {
                success(resp);
            }else{
                failure([meta getStringValueForKey:@"Message" defaultValue:@"获取订单列表失败，服务器端返回错误。"]);
            }
        }else{
            failure([meta getStringValueForKey:@"Message" defaultValue:@"服务器返回数据错误。"]);
        }
    }
}
+ (void)orderListWithId:(NSString *)userId
                success:(void (^)(NSArray *orders))success
                failure:(void (^)(NSString *errMsg))failure
{
    if(IS_DEPLOYED()){
        if([AppContext get].online)
        {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, ORDER_LIST];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setPostValue:userId forKey:@"Tid"];
            setRequestAuth(request);
            [request setCompletionBlock:^{
                id JSON = [[request responseString] objectFromJSONString];
                [self analyzeOrderListRet:JSON
                                  success:success
                                  failure:failure];
            }];
            [request setFailedBlock:^{
                failure([request.error localizedDescription]);
            }];
            [request startAsynchronous];
        }
        else
        {
            failure(@"当前网络不可用，且没有本地数据。");
        }
    }else{
        [BBlock dispatchAfter:1 onMainThread:^{
            id JSON = [self dummy:@"OrderList"];
            [self analyzeOrderListRet:JSON
                              success:success
                              failure:failure];
        }];
    }
}

#pragma mark - Order Detail
+ (void)analyzeOrderDetailRet: (id)JSON
                      success: (void (^)(NSDictionary *results))success
                      failure: (void (^)(NSString *errorMsg))failure;
{
    if (JSON == [NSNull null] || JSON == nil) {
        failure(@"无法连接服务器。");
    }else{
        NSDictionary *meta= [JSON objectForKey:@"Meta"];
        
        if ([[meta getStringValueForKey:@"Method" defaultValue:@""] isEqualToString: @"GetTicketOrderDetailById"] && [[meta getStringValueForKey:@"Status" defaultValue:@"fail"] isEqualToString:@"ok"]){
            NSDictionary *resp = [JSON objectForKey:@"Response"];
            if(resp) {
                success(resp);
            }else{
                failure([meta getStringValueForKey:@"Message" defaultValue:@"获取订单详细信息失败，服务器端返回错误。"]);
            }
        }else{
            failure([meta getStringValueForKey:@"Message" defaultValue:@"服务器返回数据错误。"]);
        }
    }
}
+ (void)orderDetailWithId:(NSString *)orderId
                   userId: (NSString *)userId
                  success:(void (^)(NSDictionary *order))success
                  failure:(void (^)(NSString *))failure
{
    if(IS_DEPLOYED()){
        if([AppContext get].online)
        {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, ORDER_DETAIL];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setPostValue:userId forKey:@"Tid"];
            [request setPostValue:orderId forKey:@"OrderId"];
            setRequestAuth(request);
            [request setCompletionBlock:^{
                id JSON = [[request responseString] objectFromJSONString];
                [self analyzeOrderDetailRet:JSON
                                    success:success
                                    failure:failure];
            }];
            [request setFailedBlock:^{
                failure([request.error localizedDescription]);
            }];
            [request startAsynchronous];
        }
        else
        {
            failure(@"当前网络不可用，且没有本地数据。");
        }
    }else{
        [BBlock dispatchAfter:1 onMainThread:^{
            id JSON = [self dummy:@"OrderDetail"];
            [self analyzeOrderDetailRet:JSON
                                success:success
                                failure:failure];
        }];
    }
}

#pragma mark - place order

+ (void)performPlaceOrder:(NSArray*)twoCharCodes					// TwoCharCode
andDepartureThreeCharCode:(NSArray*)departureThreeCharCodes			// ThreeCharCode
  andArrivalThreeCharCode:(NSArray*)arrivalThreeCharCodes			// arrivalThreeCharCodes
			andFlightInfo:(NSArray*)flightInfos						// NSDictionary
				 andCabin:(NSArray*)cabins							// NSDictionary
			 andTravelers:(NSArray *)travelers
			 andContactor:(NSDictionary*)contactor
				  success:(void (^)(NSDictionary *))success
				  failure:(void (^)(NSString *))failure
{
	NSParameterAssert(success != nil);
	NSParameterAssert(failure != nil);
	
    if (IS_DEPLOYED()) {
        if ([AppContext get].online) {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, kFlightPlaceOrderURL];
            __block ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];

            // flight
			NSMutableString* flightStr = [NSMutableString string];
			
			for (int travelersCount = travelers.count, m = 0
				 ; m < travelersCount
				 ; ++m) {

				for (int count = twoCharCodes.count, n = 0
					 ; n < count
					 ; ++n) {
					
					if ([flightStr length] != 0) {
						[flightStr appendString:@"^"];
					}
					
					NSDictionary* flightInfo = flightInfos[n];
					TwoCharCode* twoCharCode = twoCharCodes[n];
					ThreeCharCode* departureThreeCharCode = departureThreeCharCodes[n];
					ThreeCharCode* arrivalThreeCharCode = arrivalThreeCharCodes[n];
					NSDictionary* cabin = cabins[n];
					
					// 格式：二字码_航班号_舱位_出发三字码_出发时间_到达三字码_到达时间^二字码_航班号_舱位_出发三字码_出发时间_到达三字码_到达时间
					// 如：CZ_CZ1234_Y_PEK_2012-12-25 11:00_SHA_2012-12-25 14:25^CZ_CZ1234_Y_PEK_2012-12-25 11:00_SHA_2012-12-25 14:25
					
					[flightStr appendFormat:@"%@_%@_%@_%@_%@_%@_%@"
					 , twoCharCode.charCode
					 , [flightInfo getStringValueForKey:@"FlightNum" defaultValue:@""]
					 , [cabin getStringValueForKey:@"CabinName" defaultValue:@""]
					 , departureThreeCharCode.charCode
					 , [flightInfo getStringValueForKey:@"LeaveTime" defaultValue:@""]
					 , arrivalThreeCharCode.charCode
					 , [flightInfo getStringValueForKey:@"ArriveTime" defaultValue:@""]];
				}
			}
			
			// Traveler
			// 乘客
			NSMutableString* travelerStr = [NSMutableString string];
			for (int flightCount = twoCharCodes.count, m = 0
				 ; m < flightCount
				 ; ++m) {
				
				for (int count = travelers.count, n = 0
					 ; n < count
					 ; ++n) {
					
					// 格式：姓名_乘客类型_身份证号^姓名_乘客类型_身份证号
					// 如：张三_1_413024198309141234^李四_1_413024198309141234
					//
					// 乘客类型：1成人 2儿童
					if ([travelerStr length] != 0)
						[travelerStr appendString:@"^"];
					
					NSDictionary* traveler = travelers[n];
					
					// 姓名
					NSString* name = [traveler getStringValueForKey:@"Name" defaultValue:@""];
					
					// 乘客类型
					NSString* travelerType = [traveler getStringValueForKey:@"TravelerType" defaultValue:@""];
					
					// 身份证号
					NSString* chinaId = [traveler getStringValueForKey:@"ChinaId" defaultValue:@""];
					
					[travelerStr appendFormat:@"%@_%@_%@", name, travelerType, chinaId];
				}
			}
			
			// 联系人姓名 ContactorName
			NSString* contactorName = [contactor getStringValueForKey:@"Name" defaultValue:@""];
			
			// 联系人手机号 ContactorPhone
			NSString* contactorPhone = [contactor getStringValueForKey:@"Phone" defaultValue:@""];
			
			// 联系人email ContactorEmail
			NSString* contactorEmail = [contactor getStringValueForKey:@"Email" defaultValue:@""];
			
			// 乘客备注 PassengerRemark
			NSString* passengerRemark = @"";
			
			[request setPostValue:flightStr forKey:@"Flight"];
            [request setPostValue:travelerStr forKey:@"Traveler"];
            [request setPostValue:contactorName forKey:@"ContactorName"];
            [request setPostValue:contactorPhone forKey:@"ContactorPhone"];
            [request setPostValue:contactorEmail forKey:@"ContactorEmail"];
            [request setPostValue:passengerRemark forKey:@"PassengerRemark"];
            
			setRequestAuth(request);
            
			[request setCompletionBlock:^{
                id jsonObj = [[request responseString] mutableObjectFromJSONString];
				
 				if (![[jsonObj valueForKeyPath:@"Meta.Status"] isEqualToString:@"ok"])
					failure([jsonObj valueForKeyPath:@"Meta.Message"]);
				else
					success(jsonObj);
            }];
			
            [request setFailedBlock:^{
                failure([request.error localizedDescription]);
            }];
			
            [request startAsynchronous];
        } else {
            failure(@"当前网络不可用，且没有本地数据。");
        }
    } else {
        [BBlock dispatchAfter:0.2f onMainThread:^{
			NSString* path = [[NSBundle mainBundle] pathForResource:@"PlaceOrder" ofType:@"js"];
			NSString* content = [NSString stringWithContentsOfFile:path
														  encoding:NSUTF8StringEncoding
															 error:nil];
			
			NSMutableDictionary* jsonContent = [[content mutableObjectFromJSONString] objectForKey:@"Response"];
			
			success(jsonContent);
        }];
    }
}

+ (void)performCreatePayUrl:(NSDictionary *)placeOrderJson
					success:(void (^)(NSDictionary *))success
					failure:(void (^)(NSString *))failure
{
	NSParameterAssert(success != nil);
	NSParameterAssert(failure != nil);
	
	if (IS_DEPLOYED()) {
        if ([AppContext get].online) {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, kOrderCreatePayUrl];
            __block ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
			
//			OrderId	Y	订单Id
//			PayPlat	Y	支付平台  如2表示支付宝
			
			NSString* orderId = [placeOrderJson getStringValueForKey:@"Response" defaultValue:@""];
            NSString* payPlat = @"2";
			
			[request setPostValue:orderId forKey:@"OrderId"];
            [request setPostValue:payPlat forKey:@"PayPlat"];
            
			setRequestAuth(request);
            
			[request setCompletionBlock:^{
                id jsonObj = [[request responseString] mutableObjectFromJSONString];
				
				if (![[jsonObj valueForKeyPath:@"Meta.Status"] isEqualToString:@"ok"])
					failure([jsonObj valueForKeyPath:@"Meta.Message"]);
				else
					success(jsonObj);
            }];
			
            [request setFailedBlock:^{
                failure([request.error localizedDescription]);
            }];
			
            [request startAsynchronous];
        } else {
            failure(@"当前网络不可用，且没有本地数据。");
        }
    } else {
        [BBlock dispatchAfter:0.2f onMainThread:^{
			NSString* path = [[NSBundle mainBundle] pathForResource:@"CreatePayUrl" ofType:@"js"];
			NSString* content = [NSString stringWithContentsOfFile:path
														  encoding:NSUTF8StringEncoding
															 error:nil];
			
			NSMutableDictionary* jsonContent = [[content mutableObjectFromJSONString] objectForKey:@"Response"];
			
			success(jsonContent);
        }];
    }
}

@end
