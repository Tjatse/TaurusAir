//
//  AirportSearchHelper.m
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "AirportSearchHelper.h"
#import "TwoCharCode.h"
#import "CharCodeHelper.h"

@implementation AirportSearchHelper

+ (TwoCharCode *)queryWithTwoCharCodeString:(NSString *)key
{
	NSDictionary* allTwoCharcodes = [CharCodeHelper allTwoCharCodesDictionary];
	return [allTwoCharcodes objectForKey:key];
}

@end
