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
#import "NSDateAdditions.h"

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
		[self pushTicketOrder:[[[TicketOrder alloc] initWithFromCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"PEK"]
																  toCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"SHA"]
															customerName:@"张三"
														   departureTime:[NSDate dateWithTimeIntervalSinceNow:1 * 60 * 60 * 1000]
															flightNumber:@"CA7878"] autorelease]];
		[self pushTicketOrder:[[[TicketOrder alloc] initWithFromCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"PEK"]
																  toCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"SHA"]
															customerName:@"李四"
														   departureTime:[NSDate dateWithTimeIntervalSinceNow:2 * 60 * 60 * 1000 + 5 * 1000]
															flightNumber:@"CA7878"] autorelease]];
		[self pushTicketOrder:[[[TicketOrder alloc] initWithFromCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"PEK"]
																  toCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"SHA"]
															customerName:@"王二麻子"
														   departureTime:[NSDate dateWithTimeIntervalSinceNow:3 * 60 * 60 * 1000]
															flightNumber:@"CA7878"] autorelease]];
		[self pushTicketOrder:[[[TicketOrder alloc] initWithFromCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"PEK"]
																  toCity:[[CharCodeHelper allThreeCharCodesDictionary] objectForKey:@"SHA"]
															customerName:@"小熊"
														   departureTime:[NSDate dateWithTimeIntervalSinceNow:4 * 60 * 60 * 1000]
															flightNumber:@"CA7878"] autorelease]];

	}
	
	return self;
}

#pragma mark - core methods

- (void)pushTicketOrder:(TicketOrder*)ticket
{
	[self.allTicketOrders addObject:ticket];
	
	// 判断通知时间
	// 提前2个小时
	NSDate* twoHoursBefore = [ticket.departureTime dateAfterHours:-2];
	UILocalNotification* alarm = [[UILocalNotification alloc] init];
	if (alarm) {
		NSString* alarmBody = [NSString stringWithFormat:@"%@，%@-%@，%@起飞，该出发了。"
							   , ticket.flightNumber
							   , ticket.fromCity.cityName
							   , ticket.toCity.cityName
							   , [ticket.departureTime stringWithFormat:[NSDate timestampFormatString]]];
		
        alarm.fireDate = twoHoursBefore;
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = kCFCalendarUnitWeekday;
        alarm.soundName = @"ping.caf";//@"default";
        alarm.alertBody = alarmBody;
//        alarm.alertAction = NSLocalizedString(@"打开", @"取消");  //提示框按钮
        
        NSDictionary* infoDic = [NSDictionary dictionaryWithObject:@"notification" forKey:@"Identifier"];
        alarm.userInfo = infoDic;
        [[UIApplication sharedApplication] scheduleLocalNotification:alarm];
		
        SAFE_RELEASE(alarm);
    }
}

@end
