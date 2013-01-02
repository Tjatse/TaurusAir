//
//  TicketOrderHelper.m
//  TaurusClient
//
//  Created by Simon on 13-1-2.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "TicketOrderHelper.h"
#import "TicketOrder.h"
#import "ThreeCharCode.h"
#import "CharCodeHelper.h"

@implementation TicketOrderHelper

+ (TicketOrderHelper *)sharedHelper
{
	@synchronized (self) {
		static TicketOrderHelper* instance = nil;
		
		if (instance == nil) {
			instance = [[TicketOrderHelper alloc] init];
		}
		
		return instance;
	}
}

- (void)dealloc
{
	self.allTicketOrders = nil;
	
	[super dealloc];
}

- (id)init
{
	if (self = [super init]) {
		self.allTicketOrders = [NSMutableArray array];
		[self.allTicketOrders addObject:[[[TicketOrder alloc] initWithFromCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"PEK"]
																  toCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"SHA"]
															customerName:@"张三"
														   departureTime:[NSDate dateWithTimeIntervalSinceNow:1 * 60 * 60 * 1000]
															flightNumber:@"CA7878"] autorelease]];
		[self.allTicketOrders addObject:[[[TicketOrder alloc] initWithFromCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"PEK"]
																  toCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"SHA"]
															customerName:@"李四"
														   departureTime:[NSDate dateWithTimeIntervalSinceNow:2 * 60 * 60 * 1000 + 5 * 1000]
															flightNumber:@"CA7878"] autorelease]];
		[self.allTicketOrders addObject:[[[TicketOrder alloc] initWithFromCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"PEK"]
																  toCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"SHA"]
															customerName:@"王二麻子"
														   departureTime:[NSDate dateWithTimeIntervalSinceNow:3 * 60 * 60 * 1000]
															flightNumber:@"CA7878"] autorelease]];
		[self.allTicketOrders addObject:[[[TicketOrder alloc] initWithFromCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"PEK"]
																  toCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"SHA"]
															customerName:@"小熊"
														   departureTime:[NSDate dateWithTimeIntervalSinceNow:4 * 60 * 60 * 1000]
															flightNumber:@"CA7878"] autorelease]];

	}
	
	return self;
}



@end
