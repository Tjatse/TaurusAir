//
//  TicketOrderHelper.h
//  TaurusClient
//
//  Created by Simon on 13-1-2.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TicketOrder;

@interface TicketOrderHelper : NSObject

+ (TicketOrderHelper*)sharedHelper;

@property (nonatomic, retain) NSMutableArray* allTicketOrders;

- (void)pushTicketOrder:(TicketOrder*)ticket;

@end
