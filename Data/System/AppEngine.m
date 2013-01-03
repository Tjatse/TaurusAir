//
//  AppEngine.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "AppEngine.h"
#import "AppConfig.h"
#import "AppContext.h"
#import "FSConfig.h"
#import "TicketOrderHelper.h"

@implementation AppEngine

+(AppEngine*) get
{
    @synchronized(self)
    {
		static AppEngine* singleton = nil;
		
        // create our single instance
        if(singleton == nil) {
            singleton = [[self alloc] init];
        }
		
		return singleton;
    }
}

- (id)init
{
	if (self = [super init]) {
		[FSConfig engine];
		[TicketOrderHelper sharedHelper];
	}
	
	return self;
}

-(void) startApp:(UIApplication *)uiApplication{
    
    //[AppContext get].application = uiApplication;
    [[AppConfig get] loadState];
	[AppContext get];
    
    NSLog(@"[[ Start App ]]");
}

-(void) stopApp:(UIApplication *)uiApplication{
    
    [[AppConfig get] saveState];
    
    NSLog(@"[[ Stop App ]]");
}

-(void) pauseApp:(UIApplication *)uiApplication{
    
    [[AppConfig get] saveState];
    
    NSLog(@"[[ Pause App ]]");
}

-(void) resumeApp:(UIApplication *)uiApplication{
    
    NSLog(@"[[ Resume App ]]");
}
@end
