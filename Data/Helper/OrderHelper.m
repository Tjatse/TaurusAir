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
                success:(void (^)(NSArray *))success
                failure:(void (^)(NSString *))failure
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
@end
