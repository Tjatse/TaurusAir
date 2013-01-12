//
//  FlightSearchHelper.m
//  TaurusClient
//
//  Created by Simon on 13-1-12.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "BBlock.h"
#import "NSDictionaryAdditions.h"
#import "AppContext.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "AppDefines.h"
#import "JSONKit.h"
#import "NSDateAdditions.h"

#import "FlightSearchHelper.h"
#import "ThreeCharCode.h"

@implementation FlightSearchHelper

+ (void)performFlightSearchWithDepartureCity:(ThreeCharCode *)aDepartureCity
							  andArrivalCity:(ThreeCharCode *)aArrivalCity
							andDepartureDate:(NSDate *)aDepartureDate
								  andSuccess:(void (^)(NSMutableDictionary* respObj))success
								  andFailure:(void (^)(NSString *))failure
{
	NSParameterAssert(success != nil);
	NSParameterAssert(failure != nil);
	
    if (IS_DEPLOYED()) {
        if ([AppContext get].online) {
            NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, kFlightSearchURL];
            __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            
			[request setPostValue:aDepartureCity.charCode forKey:@"FromSzm"];
            [request setPostValue:aArrivalCity.charCode forKey:@"ToSzm"];
            [request setPostValue:[NSString stringWithFormat:@"%@", [aDepartureDate stringWithFormat:[NSDate timestampFormatString]]]
						   forKey:@"LeaveDate"];
            
			setRequestAuth(request);
            
			[request setCompletionBlock:^{
                id jsonObj = [[request responseString] mutableObjectFromJSONString];
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
			NSString* path = [[NSBundle mainBundle] pathForResource:@"RunAvCommand" ofType:@"js"];
			NSString* content = [NSString stringWithContentsOfFile:path
														  encoding:NSUTF8StringEncoding
															 error:nil];
			
			NSMutableDictionary* jsonContent = [[content mutableObjectFromJSONString] objectForKey:@"Response"];
			
			success(jsonContent);
        }];
    }
}

@end
