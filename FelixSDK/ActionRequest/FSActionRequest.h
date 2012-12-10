//
//  FSActionRequest.h
//  FSSDK
//
//  Created by Felix on 11-11-5.
//  Copyright 2011 deep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSActionParser.h"
#import "FSCallBack.h"
#import "ASINetworkQueue.h"
#import "HttpRequestWrapper.h"
#import "MBProgressHUD.h"

typedef void (^FSRequestCompleteBlock)(FSActionParser* parse);
typedef void (^FSRequestErrorBlock)(NSError* error);

@interface FSActionRequest : NSObject <MBProgressHUDDelegate>
{
	MBProgressHUD*			_hud;
	
	FSRequestCompleteBlock	_onCompleteBlock;
	FSRequestErrorBlock		_onErrorBlock;
	
@protected
	HttpRequestWrapper*		_connection;
	BOOL					isCancel;
}

@property (nonatomic, retain) NSString* 			reqParam;
@property (nonatomic, retain) NSData* 				buffer;
@property (nonatomic, retain) NSString* 			domain;
@property (nonatomic, retain) FSActionParser* 		baseParse;
@property (nonatomic, assign) id 					sender;
@property (nonatomic, assign) SEL 					onCompleteSelector;
@property (nonatomic, assign) SEL 					onErrorSelector;
@property (nonatomic, assign) BOOL					isAutoCancelOtherNonBusyRequest;
@property (nonatomic, readonly) BOOL				isBusyHUDShown;

- (void)toAddQueue:(ASINetworkQueue*)queue;

- (id)initWithParams:(NSString*)reqParams
		withPostData:(NSData*)postData
		  parseClass:(Class)parseClass
		  onComplete:(FSRequestCompleteBlock)onCompleteBlock
			 onError:(FSRequestErrorBlock)onErrorBlock;

- (id)initWithCallBack:(id)sender
			onComplete:(SEL)onCompleteSelector
			   onError:(SEL)onErrorSelector;

- (FSActionParser*)parseResult:(NSString *)data;
- (void)cancel;
- (void)execute;
- (void)execute:(BOOL)showBusyLayer;
- (void)shouldDoInBackground:(BOOL)yesOrNo;
- (void)asynRequest:(NSString*)url param:(NSMutableDictionary*)dic;
- (void)showBusyHUD;
- (void)stopBusyHUD;
- (void)onConnectionCreated:(HttpRequestWrapper*)req;
+ (void)cancelAllExecutingRequests;

@end
