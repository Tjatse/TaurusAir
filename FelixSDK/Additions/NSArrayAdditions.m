//
//  NSArrayAdditions.m
//  WeiBoKong
//
//  Created by maxitech admin on 19/08/2011.
//  Copyright 2011 deep. All rights reserved.
//

#import "NSArrayAdditions.h"


@implementation NSArray (Additions)

+(time_t)getTimeValueForKey:(NSString *)stringTime defaultValue:(time_t)defaultValue {
	//NSString *stringTime   = [self objectForKey:key];
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}

@end
