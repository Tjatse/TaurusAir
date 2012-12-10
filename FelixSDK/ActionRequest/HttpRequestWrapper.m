//
//  HttpRequestWrapper.m
//  FelixSDK
//
//  Created by felix on 02/11/2011.
//  Copyright 2011 deep. All rights reserved.
//

#import "HttpRequestWrapper.h"
#include <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "UIDevice+IdentifierAddition.h"

@interface HttpRequestWrapper ()

- (void)receiveData:(NSString*)buffer;
- (void)receiveError:(NSError*)aError;

@end

@implementation HttpRequestWrapper

@synthesize actionJson;
@synthesize actionError;
@synthesize actionString;
@synthesize sender;

- (id)init
{
	self = [super init];
	if (self) {
		self.timeOutSeconds = 20;
		[self setDefaultResponseEncoding:NSUTF8StringEncoding];
		reqHeadPropertys = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (id)initWithURL:(NSURL *)newURL
{
	if (self = [super initWithURL:newURL]) {
		[self setDefaultResponseEncoding:NSUTF8StringEncoding];
	}
	
	return self;
}

- (void)dealloc
{
	sender = nil;
	actionJson = nil;
	actionError = nil;
	actionString = nil;
	
	[reqHeadPropertys release];
	reqHeadPropertys = nil;
	
	[super dealloc];
}

-(BOOL)netWorkAble
{
	struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) 
    {
        //printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

-(void)postDataDic:(NSMutableDictionary*)params withURL:(NSString*)tourl
{
	self.requestMethod =@"POST";
	if (tourl) {
		[self setURL:[NSURL URLWithString:tourl]];
	}
	NSArray *names = [params allKeys];
    for (NSInteger i = 0; i < [names count]; i++) {
        NSString *name = [names objectAtIndex:i];
        if (i==0) {
            [(ASIFormDataRequest *)self setPostValue:[params objectForKey:name] forKey:name];
        }
        else
            [(ASIFormDataRequest *)self setData:[params objectForKey:name] forKey:name];
    }
	self.timeOutSeconds = 60;
	[self setDelegate:self];
	[self setDidStartSelector:@selector(requestStarted:)];
	[self setDidFinishSelector:@selector(requestFinished:)];
	[self setDidFailSelector:@selector(requestFailed:)];
	[self startAsynchronous];
}

-(BOOL)sendData:(NSData*)buffer withURL:(NSString*)tourl
{
    NSString *retimei =[[UIDevice currentDevice] uniqueDeviceIdentifier];
//    NSLog(@"retimei %@",retimei);
    
	if (buffer && [buffer length]!=0) {
		self.requestMethod = @"POST";
		[self addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
        [self addRequestHeader:@"MACID" value:retimei];
	}
	else {
		self.requestMethod = @"GET";
	}
	
	if (tourl) {
		[self setURL:[NSURL URLWithString:tourl]];
	}
	
	self.timeOutSeconds = 60;
	[self setDelegate:self];
	[self setDidStartSelector:@selector(requestStarted:)];
	[self setDidFinishSelector:@selector(requestFinished:)];
	[self setDidFailSelector:@selector(requestFailed:)];
	[self setPostBody:(NSMutableData*)buffer];
	[self startAsynchronous];
	return YES;
}

- (void)receiveData:(NSString*)buffer;
{
	[sender retain];
	
	if ([sender respondsToSelector:actionString]) 
		[sender performSelector:actionString withObject:buffer];
	
	if ([sender respondsToSelector:actionJson]) {
		NSDictionary* root = [buffer objectFromJSONString];
		[sender performSelector:actionJson withObject:root];
	}
	
	BOOL setSenderToNil = [sender retainCount] == 1;
	[sender release];
	
	if (setSenderToNil)
		sender = nil;
}

- (void)receiveError:(NSError*)aError;
{
	if ([sender respondsToSelector:actionError])
		[sender performSelector:actionError withObject:aError];
}

- (void)disConnect
{
	[self cancel];
}

-(void)pushHeadPropertys:(NSString*)value withKey:(NSString*)key
{
	[self addRequestHeader:key value:value];
}

- (void)requestFinished:(ASIHTTPRequest *)_request
{
//	NSLog(@"response string: %@", [_request responseString]);
	
	NSInteger statusCode = [_request responseStatusCode];
	BOOL hasError = NO;
	switch (statusCode) {
        case 401: // Not Authorized: either you need to provide authentication credentials, or the credentials provided aren't valid.
			hasError = YES;
			break;
			
        case 403: // Forbidden: we understand your request, but are refusing to fulfill it.  An accompanying error message should explain why.
        case 40302:
			hasError = YES;
			break;
			
        case 304: // Not Modified: there was no new data to return.
			hasError = YES;
			[self receiveError:_request.error];
			break;
            
        case 400: // Bad Request: your request is invalid, and we'll return an error message that tells you why. This is the status code returned if you've exceeded the rate limit
        case 200: // OK: everything went awesome.
            break;
			
        case 404: // Not Found: either you're requesting an invalid URI or the resource in question doesn't exist (ex: no such user). 
        case 500: // Internal Server Error: we did something wrong.  Please post to the group about it and the Weibo team will investigate.
        case 502: // Bad Gateway: returned if Weibo is down or being upgraded.
        case 503: // Service Unavailable: the Weibo servers are up, but are overloaded with requests.  Try again later.
        default:
            hasError = YES;
			break;
    }
	
	if (hasError)
		[self receiveError:_request.error];
	else
		[self receiveData:[_request responseString]];
}

- (void)requestFailed:(ASIHTTPRequest *)_request
{
	//[NSObject stopActivityIndicatorViewAnimation];
	//NSError *aError = [_request error];
	//NSString *str = [NSString stringWithFormat:@"Reason:%@\nerrordetail:%@",[aError localizedFailureReason],[aError localizedDescription]];
    //NSLog(@"_request error!!!, Reason:%@, errordetail:%@"
    //      , [error localizedFailureReason], [error localizedDescription]);
    //[self receiveData:nil];
	
	[self receiveError:_request.error];
}

@end
