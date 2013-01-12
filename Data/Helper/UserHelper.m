//
//  UserHelper.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-23.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "UserHelper.h"
#import "AppContext.h"
#import "AppDefines.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "NSDictionaryAdditions.h"
#import "BBlock.h"

@interface UserHelper(Private)
+ (id)dummy: (NSString *)key;
@end

@implementation UserHelper
#pragma mark Dummy Data
+ (id)dummy: (NSString *)key
{
    NSString *path = [[NSBundle mainBundle] pathForResource:key ofType:@"json"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    
    return [content objectFromJSONString];
}
#pragma mark - Get Validation Code
+ (void)analyzeValidCodeRet: (id)JSON
                      success: (void (^)(NSString *vcode))success
                      failure: (void (^)(NSString *errorMsg))failure;
{
    if (JSON == [NSNull null] || JSON == nil) {
        failure(@"无法连接服务器。");
    }else{
        NSDictionary *meta= [JSON objectForKey:@"Meta"];
        
        if ([[meta getStringValueForKey:@"Method" defaultValue:@""] isEqualToString: @"GetVerifyCode"] && [[meta getStringValueForKey:@"Status" defaultValue:@"fail"] isEqualToString:@"ok"]){
            NSString *resp = [JSON getStringValueForKey:@"Response" defaultValue:nil];
            if(resp) {
                success(resp);
            }else{
                failure([meta getStringValueForKey:@"Message" defaultValue:@"获取验证码失败，服务器端返回错误。"]);
            }
        }else{
            failure([meta getStringValueForKey:@"Message" defaultValue:@"服务器返回数据错误。"]);
        }
    }
}
+ (void)validCodeWithPhone: (NSString *)phone
                   success: (void (^)(NSString *code))success
                   failure: (void (^)(NSString *errorMsg))failure
{
    if(IS_DEPLOYED()){
        if([AppContext get].online)
        {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, ACCOUNT_VERIFY_CODE];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setPostValue:phone forKey:@"Phone"];
            setRequestAuth(request);
            [request setCompletionBlock:^{
                id JSON = [[request responseString] objectFromJSONString];
                [self analyzeValidCodeRet:JSON
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
            id JSON = [self dummy:@"GetVerifyCode"];
            [self analyzeValidCodeRet:JSON
                              success:success
                              failure:failure];
        }];
    }
}
#pragma mark - Password Recovery
+ (void)analyzePwdRecoveryRet: (id)JSON
                      success: (void (^)())success
                      failure: (void (^)(NSString *errorMsg))failure;
{
    if (JSON == [NSNull null] || JSON == nil) {
        failure(@"无法连接服务器。");
    }else{
        NSDictionary *meta= [JSON objectForKey:@"Meta"];
        
        if ([[meta getStringValueForKey:@"Method" defaultValue:@""] isEqualToString: @"EditUserPwd"] && [[meta getStringValueForKey:@"Status" defaultValue:@"fail"] isEqualToString:@"ok"]){
            BOOL resp = [JSON getBoolValueForKey:@"Response" defaultValue:false];
            if(resp) {
                success();
            }else{
                failure([meta getStringValueForKey:@"Message" defaultValue:@"找回密码失败，服务器端返回错误。"]);
            }
        }else{
            failure([meta getStringValueForKey:@"Message" defaultValue:@"服务器返回数据错误。"]);
        }
    }
}
+ (void)pwdRecoveryWithLoginName: (NSString *)loginName
                          cnName: (NSString *)cnName
                         success: (void (^)())success
                         failure: (void (^)(NSString *errorMsg))failure
{
    if(IS_DEPLOYED()){
        if([AppContext get].online)
        {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, ACCOUNT_FINDPWD];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setPostValue:loginName forKey:@"LoginName"];
            [request setPostValue:cnName forKey:@"CnName"];
            setRequestAuth(request);
            [request setCompletionBlock:^{
                id JSON = [[request responseString] objectFromJSONString];
                [self analyzePwdRecoveryRet:JSON
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
            id JSON = [self dummy:@"PasswordRecovery"];
            [self analyzePwdRecoveryRet:JSON
                                success:success
                                failure:failure];
        }];
    }
}
#pragma mark - Password Edit
+ (void)analyzePwdEditRet:(id)JSON
                  success:(void (^)())success
                  failure:(void (^)(NSString *))failure
{
    if (JSON == [NSNull null] || JSON == nil) {
        failure(@"无法连接服务器。");
    }else{
        NSDictionary *meta= [JSON objectForKey:@"Meta"];
        
        if ([[meta getStringValueForKey:@"Method" defaultValue:@""] isEqualToString: @"EditUserPwd"] && [[meta getStringValueForKey:@"Status" defaultValue:@"fail"] isEqualToString:@"ok"]){
            BOOL resp = [JSON getBoolValueForKey:@"Response" defaultValue:false];
            if(resp) {
                success();
            }else{
                failure([meta getStringValueForKey:@"Message" defaultValue:@"修改密码失败，服务器端返回错误。"]);
            }
        }else{
            failure([meta getStringValueForKey:@"Message" defaultValue:@"服务器返回数据错误。"]);
        }
    }
}
+ (void)pwdEditWithId:(NSString *)userId
          oldPassword:(NSString *)oldPassword
          newPassword:(NSString *)newPassword
              success:(void (^)())success
              failure:(void (^)(NSString *))failure
{
    if(IS_DEPLOYED()){
        if([AppContext get].online)
        {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, ACCOUNT_UPDPWD];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setPostValue:userId forKey:@"UserId"];
            [request setPostValue:oldPassword forKey:@"OldPwd"];
            [request setPostValue:newPassword forKey:@"NewPwd"];
            setRequestAuth(request);
            [request setCompletionBlock:^{
                id JSON = [[request responseString] objectFromJSONString];
                [self analyzePwdRecoveryRet:JSON
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
            id JSON = [self dummy:@"EditUserPwd"];
            [self analyzePwdEditRet:JSON
                            success:success
                            failure:failure];
        }];
    }
}

#pragma mark - Register User
+ (void)analyzeRegisterUserRet:(id)JSON
                       success:(void (^)())success
                       failure:(void (^)(NSString *))failure
{
    if (JSON == [NSNull null] || JSON == nil) {
        failure(@"无法连接服务器。");
    }else{
        NSDictionary *meta= [JSON objectForKey:@"Meta"];
        
        if ([[meta getStringValueForKey:@"Method" defaultValue:@""] isEqualToString: @"RegistUser"] && [[meta getStringValueForKey:@"Status" defaultValue:@"fail"] isEqualToString:@"ok"]){
            BOOL resp = [JSON getBoolValueForKey:@"Response" defaultValue:false];
            if(resp) {
                success();
            }else{
                failure([meta getStringValueForKey:@"Message" defaultValue:@"注册用户失败，服务器端返回错误。"]);
            }
        }else{
            failure([meta getStringValueForKey:@"Message" defaultValue:@"服务器返回数据错误。"]);
        }
    }
}
+ (void)registerUserWithPhone: (NSString *)phone
                    validCode: (NSString *)validCode
                     password: (NSString *)password
                      success: (void (^)())success
                      failure: (void (^)(NSString *errorMsg))failure
{
    if(IS_DEPLOYED()){
        if([AppContext get].online)
        {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, ACCOUNT_REG];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setPostValue:validCode forKey:@"VCode"];
            [request setPostValue:phone forKey:@"Phone"];
            [request setPostValue:phone forKey:@"LoginName"];
            [request setPostValue:password forKey:@"Pwd"];
            [request setPostValue:phone forKey:@"Name"];
            setRequestAuth(request);
            [request setCompletionBlock:^{
                id JSON = [[request responseString] objectFromJSONString];
                [self analyzeRegisterUserRet:JSON
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
            id JSON = [self dummy:@"RegisterUser"];
            [self analyzeRegisterUserRet:JSON
                                 success:success
                                 failure:failure];
        }];
    }
}

#pragma mark - Login
+ (void)analyzeLoginRet:(id)JSON
                success:(void (^)(User *user))success
                failure:(void (^)(NSString *))failure
{
    if (JSON == [NSNull null] || JSON == nil) {
        failure(@"无法连接服务器。");
    }else{
        NSDictionary *meta= [JSON objectForKey:@"Meta"];
        
        if ([[meta getStringValueForKey:@"Method" defaultValue:@""] isEqualToString: @"UserLogin"] && [[meta getStringValueForKey:@"Status" defaultValue:@"fail"] isEqualToString:@"ok"]){
            NSDictionary *resp = [JSON objectForKey:@"Response"];
            if(resp != nil && (NSNull *)resp != [NSNull null]) {
                NSString *userId = [NSString stringWithFormat:@"%d", [[resp objectForKey:@"Tid"] intValue]];
                NSString *userName = [resp getStringValueForKey:@"UserName" defaultValue:@""];
                User *u = [[User alloc] initWithUserId:userId
                                             loginName:userName
                                               userPwd:[resp getStringValueForKey:@"UserPwd" defaultValue:@""]
                                                  name:[resp getStringValueForKey:@"Name" defaultValue:userName]
                                                 phone:@""
                                                 email:@""
                                                remark:@""
                                                gender:YES
                                              birthday:@""
                                                  guid:[resp getStringValueForKey:@"Guid" defaultValue:userName]];
                success(u);
                [u release];
            }else{
                failure([meta getStringValueForKey:@"Message" defaultValue:@"用户登录失败，服务器端返回错误。"]);
            }
        }else{
            failure([meta getStringValueForKey:@"Message" defaultValue:@"服务器返回数据错误。"]);
        }
    }
}
+ (void)loginWithName: (NSString *)userName
             password: (NSString *)password
              success: (void (^)(User *u))success
              failure: (void (^)(NSString *errorMsg))failure
{
    if(IS_DEPLOYED()){
        if([AppContext get].online)
        {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, ACCOUNT_LOGIN];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setPostValue:userName forKey:@"UserName"];
            [request setPostValue:password forKey:@"UserPwd"];
            setRequestAuth(request);
            [request setCompletionBlock:^{
                id JSON = [[request responseString] objectFromJSONString];
                [self analyzeLoginRet:JSON
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
            id JSON = [self dummy:@"UserLogin"];
            [self analyzeLoginRet:JSON
                          success:success
                          failure:failure];
        }];
    }
}

#pragma mark - User Info
+ (void)analyzeUserInfoRet:(id)JSON
                   success:(void (^)(User *user))success
                   failure:(void (^)(NSString *))failure
{
    if (JSON == [NSNull null] || JSON == nil) {
        failure(@"无法连接服务器。");
    }else{
        NSDictionary *meta= [JSON objectForKey:@"Meta"];
        
        if ([[meta getStringValueForKey:@"Method" defaultValue:@""] isEqualToString: @"GetUserInfoById"] && [[meta getStringValueForKey:@"Status" defaultValue:@"fail"] isEqualToString:@"ok"]){
            NSDictionary *resp = [JSON objectForKey:@"Response"];
            if(resp != nil && (NSNull *)resp != [NSNull null]) {
                NSString *userId = [NSString stringWithFormat:@"%d", [[resp objectForKey:@"RegistUserId"] intValue]];
                NSString *userName = [resp getStringValueForKey:@"LoginName" defaultValue:@""];
                User *u = [[User alloc] initWithUserId:userId
                                             loginName:userName
                                               userPwd:[resp getStringValueForKey:@"UserPwd" defaultValue:@""]
                                                  name:[resp getStringValueForKey:@"Name" defaultValue:userName]
                                                 phone:[resp getStringValueForKey:@"Phone" defaultValue:@""]
                                                 email:[resp getStringValueForKey:@"Email" defaultValue:@""]
                                                remark:[resp getStringValueForKey:@"Remark" defaultValue:@""]
                                                gender:[resp getBoolValueForKey:@"Gender" defaultValue:YES]
                                              birthday:[resp getStringValueForKey:@"Birthday" defaultValue:@"1900-1-1"]
                                                  guid:nil];
                success(u);
                [u release];
            }else{
                failure([meta getStringValueForKey:@"Message" defaultValue:@"用户登录失败，服务器端返回错误。"]);
            }
        }else{
            failure([meta getStringValueForKey:@"Message" defaultValue:@"服务器返回数据错误。"]);
        }
    }
}

+ (void)userInfoWithId: (NSString *)userId
               success: (void (^)(User *user))success
               failure: (void (^)(NSString *errorMsg))failure
{
    if(IS_DEPLOYED()){
        if([AppContext get].online)
        {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, ACCOUNT_GET];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setPostValue:userId forKey:@"UserId"];
            setRequestAuth(request);
            [request setCompletionBlock:^{
                id JSON = [[request responseString] objectFromJSONString];
                [self analyzeUserInfoRet:JSON
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
            id JSON = [self dummy:@"UserLogin"];
            [self analyzeUserInfoRet:JSON
                             success:success
                             failure:failure];
        }];
    }
}
#pragma mark - Edit User
+ (void)analyzeEditUserRet: (id)JSON
                   success: (void (^)())success
                   failure: (void (^)(NSString *errorMsg))failure
{
    
    if (JSON == [NSNull null] || JSON == nil) {
        failure(@"无法连接服务器。");
    }else{
        NSDictionary *meta= [JSON objectForKey:@"Meta"];
        
        if ([[meta getStringValueForKey:@"Method" defaultValue:@""] isEqualToString: @"EditUserInfo"] && [[meta getStringValueForKey:@"Status" defaultValue:@"fail"] isEqualToString:@"ok"]){
            BOOL resp = [JSON getBoolValueForKey:@"Response" defaultValue:false];
            if(resp) {
                success();
            }else{
                failure([meta getStringValueForKey:@"Message" defaultValue:@"修改用户信息失败，服务器端返回错误。"]);
            }
        }else{
            failure([meta getStringValueForKey:@"Message" defaultValue:@"服务器返回数据错误。"]);
        }
    }
}
+ (void)editUserInfo: (User *)user
             success: (void (^)())success
             failure: (void (^)(NSString *errorMsg))failure
{
    if(IS_DEPLOYED()){
        if([AppContext get].online)
        {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, ACCOUNT_UPDATE];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setPostValue:user.loginName forKey:@"LoginName"];
            [request setPostValue:user.name forKey:@"Name"];
            [request setPostValue:user.phone forKey:@"Phone"];
            [request setPostValue:user.email forKey:@"Email"];
            [request setPostValue:user.remark forKey:@"Remark"];
            [request setPostValue:user.birthday forKey:@"Birthday"];
            [request setPostValue:user.gender ? @"true":@"false" forKey:@"Gender"];
            [request setPostValue:user.userId forKey:@"RegistUserId"];
            
            setRequestAuth(request);
            [request setCompletionBlock:^{
                id JSON = [[request responseString] objectFromJSONString];
                [self analyzeEditUserRet:JSON
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
            id JSON = [self dummy:@"EditUserInfo"];
            [self analyzeEditUserRet:JSON
                             success:success
                             failure:failure];
        }];
    }
}

#pragma mark - Logout
+ (void)analyzeLogoutRet:(id)JSON
                 success:(void (^)())success
                 failure:(void (^)(NSString *))failure
{
    if (JSON == [NSNull null] || JSON == nil) {
        failure(@"无法连接服务器。");
    }else{
        NSDictionary *meta= [JSON objectForKey:@"Meta"];
        
        if ([[meta getStringValueForKey:@"Method" defaultValue:@""] isEqualToString: @"UserLoginOut"] && [[meta getStringValueForKey:@"Status" defaultValue:@"fail"] isEqualToString:@"ok"]){
            success();
        }else{
            failure([meta getStringValueForKey:@"Message" defaultValue:@"服务器返回数据错误。"]);
        }
    }
}
+ (void)logoutWithId:(NSString *)userId
             success:(void (^)())success
             failure:(void (^)(NSString *))failure
{
    if(IS_DEPLOYED()){
        if([AppContext get].online)
        {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, ACCOUNT_LOGOUT];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setPostValue:userId forKey:@"UserId"];
            setRequestAuth(request);
            [request setCompletionBlock:^{
                id JSON = [[request responseString] objectFromJSONString];
                [self analyzeLogoutRet:JSON
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
            id JSON = [self dummy:@"UserLoginOut"];
            [self analyzeLogoutRet:JSON
                           success:success
                           failure:failure];
        }];
    }
}
@end
