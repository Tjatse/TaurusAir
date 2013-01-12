//
//  ContacterHelper.m
//  TaurusClient
//
//  Created by Tjatse on 13-1-11.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "ContacterHelper.h"
#import "AppContext.h"
#import "AppDefines.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "NSDictionaryAdditions.h"
#import "BBlock.h"
#import "AppConfig.h"

@interface ContacterHelper(Private)
+ (id)dummy: (NSString *)key;
@end

@implementation ContacterHelper
#pragma mark Dummy Data
+ (id)dummy: (NSString *)key
{
    NSString *path = [[NSBundle mainBundle] pathForResource:key ofType:@"json"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    
    return [content objectFromJSONString];
}
#pragma mark - Passengers
+ (void)analyzePassengersRet: (id)JSON
                     success: (void (^)(NSArray *results))success
                     failure: (void (^)(NSString *errorMsg))failure;
{
    if (JSON == [NSNull null] || JSON == nil) {
        failure(@"无法连接服务器。");
    }else{
        NSDictionary *meta= [JSON objectForKey:@"Meta"];
        
        if ([[meta getStringValueForKey:@"Method" defaultValue:@""] isEqualToString: @"GetPassengers"] && [[meta getStringValueForKey:@"Status" defaultValue:@"fail"] isEqualToString:@"ok"]){
            NSArray *resp = [JSON objectForKey:@"Response"];
            if(resp) {
                success((NSNull *)resp == [NSNull null] ? @[]:resp);
            }else{
                failure([meta getStringValueForKey:@"Message" defaultValue:@"获取常旅客失败，服务器端返回错误。"]);
            }
        }else{
            failure([meta getStringValueForKey:@"Message" defaultValue:@"服务器返回数据错误。"]);
        }
    }
}

+ (void)passengersWithId:(NSString *)userId
                 success:(void (^)(NSArray *passengers))success
                 failure:(void (^)(NSString *errMsg))failure
{
    if(IS_DEPLOYED()){
        if([AppContext get].online)
        {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, TRAVELER_PASSENGERS];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setPostValue:userId forKey:@"Tid"];
            [request setPostValue:@"1" forKey:@"NowPage"];
            [request setPostValue:@"10000" forKey:@"PerPageCount"];
            setRequestAuth(request);
            [request setCompletionBlock:^{
                id JSON = [[request responseString] objectFromJSONString];
                [self analyzePassengersRet:JSON
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
            id JSON = [self dummy:@"Passengers"];
            [self analyzePassengersRet:JSON
                               success:success
                               failure:failure];
        }];
    }
}
#pragma mark - Contacters
+ (void)analyzeContactersRet: (id)JSON
                     success: (void (^)(NSArray *results))success
                     failure: (void (^)(NSString *errorMsg))failure;
{
    if (JSON == [NSNull null] || JSON == nil) {
        failure(@"无法连接服务器。");
    }else{
        NSDictionary *meta= [JSON objectForKey:@"Meta"];
        
        if ([[meta getStringValueForKey:@"Method" defaultValue:@""] isEqualToString: @"GetContactors"] && [[meta getStringValueForKey:@"Status" defaultValue:@"fail"] isEqualToString:@"ok"]){
            NSArray *resp = [JSON objectForKey:@"Response"];
            if(resp) {
                success((NSNull *)resp == [NSNull null] ? @[]:resp);
            }else{
                failure([meta getStringValueForKey:@"Message" defaultValue:@"获取联系人失败，服务器端返回错误。"]);
            }
        }else{
            failure([meta getStringValueForKey:@"Message" defaultValue:@"服务器返回数据错误。"]);
        }
    }
}

+ (void)contactersWithId:(NSString *)userId
                 success:(void (^)(NSArray *contacters))success
                 failure:(void (^)(NSString *errMsg))failure
{
    if(IS_DEPLOYED()){
        if([AppContext get].online)
        {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, TRAVELER_CONTACTERS];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setPostValue:userId forKey:@"Tid"];
            [request setPostValue:@"1" forKey:@"NowPage"];
            [request setPostValue:@"10000" forKey:@"PerPageCount"];
            setRequestAuth(request);
            [request setCompletionBlock:^{
                id JSON = [[request responseString] objectFromJSONString];
                [self analyzeContactersRet:JSON
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
            id JSON = [self dummy:@"Contacters"];
            [self analyzeContactersRet:JSON
                               success:success
                               failure:failure];
        }];
    }
}

#pragma mark - Operations

+ (void)analyzeCtcOpRet: (id)JSON
                success: (void (^)(NSString *result))success
                failure: (void (^)(NSString *errorMsg))failure;
{
    if (JSON == [NSNull null] || JSON == nil) {
        failure(@"无法连接服务器。");
    }else{
        NSDictionary *meta= [JSON objectForKey:@"Meta"];
        
        if ([[meta getStringValueForKey:@"Status" defaultValue:@"fail"] isEqualToString:@"ok"]){
            NSString *method = [meta getStringValueForKey:@"Method" defaultValue:@""];
            if([method hasPrefix:@"OperateContactor_"]){
                NSString *resp = [JSON objectForKey:@"Response"];
                success(resp);
            }else{
                failure([meta getStringValueForKey:@"Message" defaultValue:@"联系人操作失败，服务器端返回错误。"]);
            }
        }else{
            failure([meta getStringValueForKey:@"Message" defaultValue:@"服务器返回数据错误。"]);
        }
    }
}
+ (void)contacterOperateWithData: (NSDictionary *)data
                     operateType: (TravelerOperateType)operateType
                         success: (void (^)(NSString *identification))success
                         failure: (void (^)(NSString *errorMsg))failure
{
    if(IS_DEPLOYED()){
        if([AppContext get].online)
        {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, TRAVELER_CTC_OPR];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            for(NSString *k in [data allKeys]){
                if([k isEqualToString: @"Gender"]){
                    BOOL g = [[data objectForKey:k] boolValue];
                    [request setPostValue:g ? @"true":@"false" forKey:k];
                }else{
                    [request setPostValue:[data objectForKey:k] forKey:k];
                }
            }
            User *u = [AppConfig get].currentUser;
            [request setPostValue:u.guid forKey:@"Guid"];
            [request setPostValue:u.userId forKey:@"Tid"];
            [request setPostValue:u.loginName forKey:@"UserName"];
            [request setPostValue:[NSString stringWithFormat:@"%d", operateType] forKey:@"Operate"];
            setRequestAuth(request);
            [request setCompletionBlock:^{
                id JSON = [[request responseString] objectFromJSONString];
                [self analyzeCtcOpRet:JSON
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
            id JSON = [self dummy:@"ContacterOperate"];
            [self analyzeCtcOpRet:JSON
                          success:success
                          failure:failure];
        }];
    }
}

+ (void)analyzePsgOpRet: (id)JSON
                success: (void (^)(NSString *result))success
                failure: (void (^)(NSString *errorMsg))failure;
{
    if (JSON == [NSNull null] || JSON == nil) {
        failure(@"无法连接服务器。");
    }else{
        NSDictionary *meta= [JSON objectForKey:@"Meta"];
        
        if ([[meta getStringValueForKey:@"Status" defaultValue:@"fail"] isEqualToString:@"ok"]){
            NSString *method = [meta getStringValueForKey:@"Method" defaultValue:@""];
            if([method hasPrefix:@"OperatePassenger_"]){
                NSString *resp = [JSON objectForKey:@"Response"];
                success(resp);
            }else{
                failure([meta getStringValueForKey:@"Message" defaultValue:@"常旅客操作失败，服务器端返回错误。"]);
            }
        }else{
            failure([meta getStringValueForKey:@"Message" defaultValue:@"服务器返回数据错误。"]);
        }
    }
}
+ (void)passengerOperateWithData: (NSDictionary *)data
                     operateType: (TravelerOperateType)operateType
                         success: (void (^)(NSString *identification))success
                         failure: (void (^)(NSString *errorMsg))failure
{
    if(IS_DEPLOYED()){
        if([AppContext get].online)
        {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, TRAVELER_PSG_OPR];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            for(NSString *k in [data allKeys]){
                if([k isEqualToString: @"Gender"]){
                    BOOL g = [[data objectForKey:k] boolValue];
                    [request setPostValue:g ? @"true":@"false" forKey:k];
                }else{
                    [request setPostValue:[data objectForKey:k] forKey:k];
                }
            }
            User *u = [AppConfig get].currentUser;
            [request setPostValue:u.userId forKey:@"Tid"];
            [request setPostValue:u.loginName forKey:@"UserName"];
            [request setPostValue:u.guid forKey:@"Guid"];
            [request setPostValue:[NSString stringWithFormat:@"%d", operateType] forKey:@"Operate"];
            setRequestAuth(request);
            [request setCompletionBlock:^{
                id JSON = [[request responseString] objectFromJSONString];
                [self analyzePsgOpRet:JSON
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
            id JSON = [self dummy:@"PassengerOperate"];
            [self analyzePsgOpRet:JSON
                          success:success
                          failure:failure];
        }];
    }
}

@end
