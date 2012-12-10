//
//  NSURLAdditions.h
//  WeiBoKong
//
//  Created by Cao Canfu on 18/08/2011.
//  Copyright 2011 Maxitech Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURL (Additions)

+ (NSDictionary *)parseURLQueryString:(NSString *)queryString;

+ (NSURL *)smartURLForString:(NSString *)str;

@end
