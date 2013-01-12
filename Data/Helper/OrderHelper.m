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
#import "NSDictionaryAdditions.h"

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

+ (void)performPlaceOrder:(NSArray*)twoCharCodes		// TwoCharCode
		 andThreeCharCode:(NSArray*)threeCharCodes		// ThreeCharCode
				 andCabin:(NSArray*)cabins				// NSDictionary
			  andDateTime:(NSArray*)departureTimes		// NSDate
				  andUser:(User *)user
				  success:(void (^)(NSDictionary *))success
				  failure:(void (^)(NSString *))failure
{
	NSParameterAssert(success != nil);
	NSParameterAssert(failure != nil);
	
    if (IS_DEPLOYED()) {
        if ([AppContext get].online) {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, kFlightPlaceOrderURL];
            __block ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            
//			格式：二字码_航班号_舱位_出发三字码_出发时间_到达三字码_到达时间^二字码_航班号_舱位_出发三字码_出发时间_到达三字码_到达时间
//			如：CZ_CZ1234_Y_PEK_2012-12-25 11:00_SHA_2012-12-25 14:25^CZ_CZ1234_Y_PEK_2012-12-25 11:00_SHA_2012-12-25 14:25

			NSMutableString* flight = [NSMutableString string];
			
			for (int count = twoCharCodes.count, n = 0
				 ; n < count
				 ; ++n) {
				
				if ([flight length] != 0) {
					[flight appendString:@"^"];
				}
				
				
				TwoCharCode* twoCharCode = twoCharCodes[n];
				ThreeCharCode* threeCharCode = threeCharCodes[n];
				NSDictionary* cabin = cabins[n];
				NSDate* departureTime = departureTimes[n];
				
//				[flight appendString:@"%@_%@_%@_%@_%@_%@_%@"
//				 , two];
			}
			
//			[request setPostValue:aDepartureCity.charCode forKey:@"FromSzm"];
//            [request setPostValue:aArrivalCity.charCode forKey:@"ToSzm"];
//            [request setPostValue:[NSString stringWithFormat:@"%d", (int)aDepartureDate.timeIntervalSince1970]
//						   forKey:@"LeaveDate"];
//            
//			setRequestAuth(request);
//            
//			[request setCompletionBlock:^{
//                id jsonObj = [[request responseString] mutableObjectFromJSONString];
//                success(jsonObj);
//            }];
//			
//            [request setFailedBlock:^{
//                failure([request.error localizedDescription]);
//            }];
//			
//            [request startAsynchronous];
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

@end
