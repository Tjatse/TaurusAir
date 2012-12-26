//
//  OrderState.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-26.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "OrderState.h"

@implementation OrderState
@synthesize code;
@synthesize title;

//===========================================================
// - (id)initWith:
//
//===========================================================
- (id)initWithCode:(NSString*)theCode title:(NSString*)theTitle
{
    self = [super init];
    if (self) {
        code = [theCode retain];
        title = [theTitle retain];
    }
    return self;
}
- (void)dealloc
{
    [code release], code = nil;
    [title release], title = nil;
    [super dealloc];
}

@end
