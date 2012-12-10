//
//  UIWebViewAdditions.m
//  FelixSDK
//
//  Created by Yang Felix on 12-4-20.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import "UIWebViewAdditions.h"

@implementation UIWebView (Additions)

- (NSString*)selectionText
{
	NSString* result = [self stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
	return result;
}

@end
