//
//  AppContext.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "AppContext.h"
#import "Reachability.h"

@implementation AppContext
@synthesize online;

+ (AppContext *)get
{   
    static dispatch_once_t onceQueue;
    static AppContext *appContext = nil;
    
    dispatch_once(&onceQueue, ^{ appContext = [[self alloc] init]; });
    return appContext;
}
-(BOOL)online{
    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return status != NotReachable;
}

@end
