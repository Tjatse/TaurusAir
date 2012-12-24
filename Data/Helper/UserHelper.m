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
#import "JSONKit.h"

@implementation UserHelper

+ (void)findPwd: (NSString *) loginName
          phone: (NSString *)phone
        success: (void (^)())success
        failure: (void (^)(NSString *errorMsg))failure
{
    if([AppContext get].online)
    {
        
        NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, ACCOUNT_FINDPWD];
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        [request setCompletionBlock:^{
            id JSON = [[request responseString] objectFromJSONString];
            if (JSON == [NSNull null] || JSON == nil) {
                failure(@"无法连接服务器。");
            }else{
                NSDictionary *meta= [JSON objectForKey:@"Meta"];
                
                if ([[meta objectForKey:@"Method"] isEqualToString: @"PasswordRecovery"]){
                    if([meta objectForKey:@"Message"] == nil || (NSNull *)[meta objectForKey:@"Message"] == [NSNull null]) {
                        success();
                    }else{
                        failure([meta objectForKey:@"Message"]);
                    }
                }else{
                    failure(@"服务器返回数据错误。");
                }
            }
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
}
@end
