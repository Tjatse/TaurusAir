//
//  HttpRequestWrapper.h
//  FelixSDK
//
//  Created by felix on 02/11/2011.
//  Copyright 2011 deep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface HttpRequestWrapper : ASIHTTPRequest 
{
@private
	NSMutableDictionary*	reqHeadPropertys;
}

@property (nonatomic, assign) SEL 			actionJson;
@property (nonatomic, assign) SEL 			actionError;
@property (nonatomic, assign) SEL 			actionString;
@property (nonatomic, assign) id<NSObject> 	sender;

- (BOOL)netWorkAble;
- (BOOL)sendData:(NSData*)buffer withURL:(NSString*)tourl;
- (void)disConnect;
- (void)pushHeadPropertys:(NSString*)value withKey:(NSString*)key;
- (void)postDataDic:(NSMutableDictionary*)params withURL:(NSString*)tourl;

@end
