//
//  NSBaseBusi.m
//  SalesUnion
//
//  Created by J on 11-11-5.
//  Copyright 2011 deep. All rights reserved.
//

#import "FSActionRequest.h"
#import "FSConfig.h"
#import "URLHelper.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

static NSMutableArray* executingRequests;

@interface FSActionRequest ()

- (void)releaseBlocksOnMainThread;
+ (void)releaseBlocks:(NSArray*)blocks;

- (void)actionString:(NSString*)result;
- (void)actionError:(NSError*)error;

- (void)releaseConnection;

@end

@implementation FSActionRequest

@synthesize reqParam;
@synthesize buffer;
@synthesize domain;
@synthesize baseParse;
@synthesize sender;
@synthesize onCompleteSelector;
@synthesize onErrorSelector;
@synthesize isAutoCancelOtherNonBusyRequest;

- (void)dealloc
{
	[self cancel];
	//[self stopBusyHUD];
	
//	[self autorelease];
	
//	if ([executingRequests indexOfObject:self] != NSNotFound)
//		[executingRequests removeObject:self];
	
	[_hud removeFromSuperview];
	[_hud release];
	_hud = nil;
	
    self.baseParse = nil;
	self.buffer = nil;
	self.domain = nil;
	
	self.sender = nil;
    self.onCompleteSelector = nil;
	self.onErrorSelector = nil;
	
	[self releaseConnection];
	[self releaseBlocksOnMainThread];
	
	[super dealloc];
}

- (id)init
{
	if (self = [super init]) {
		// check array nil
		if (executingRequests == nil)
			executingRequests = [[NSMutableArray alloc] init];
		
		// add by felix: fix bug with no cache files;
		FSConfig* config = [[FSConfig alloc] init];
		[config release];
		
		self.isAutoCancelOtherNonBusyRequest = YES;
		self.domain = [FSConfig readValueWithKey:Domain_Key];
		isCancel = YES;
	}
	
	return self;
}

- (void)setBaseParse:(FSActionParser *)value 
{
	[value retain];
	[baseParse release];
	baseParse = value;
	baseParse.busi = self;
}

- (void)releaseConnection
{
	[_connection cancel];
	[_connection clearDelegatesAndCancel];
	[_connection release];
	_connection = nil;
}

- (void)releaseBlocksOnMainThread
{
	NSMutableArray* blocks = [NSMutableArray array];
	
	if (_onCompleteBlock != nil) {
		[blocks addObject:_onCompleteBlock];
		[_onCompleteBlock release];
		_onCompleteBlock = nil;
	}
	
	if (_onErrorBlock != nil) {
		[blocks addObject:_onErrorBlock];
		[_onErrorBlock release];
		_onErrorBlock = nil;
	}
	
	[[self class] performSelectorOnMainThread:@selector(releaseBlocks:) 
								   withObject:blocks 
								waitUntilDone:[NSThread isMainThread]];
}

+ (void)releaseBlocks:(NSArray *)blocks
{
}

- (void)showBusyHUD 
{
	id appDelegate = [UIApplication sharedApplication].delegate;
	
	_hud = [[MBProgressHUD alloc] initWithWindow:[appDelegate window]];
	_hud.removeFromSuperViewOnHide = YES;
	[[appDelegate window] addSubview:_hud];
	[[appDelegate window] bringSubviewToFront:_hud];
	
    //HUD.labelText = @"正在载入...";	
	[_hud show:YES];
}

- (void)stopBusyHUD 
{
    if (_hud != nil) {
		_hud.delegate = nil;
	    [_hud hide:YES];
	}
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (_hud != nil) {
        [_hud removeFromSuperview];  
        [_hud release];  
        _hud = nil;
    }
}

- (id)initWithCallBack:(id)aSender
			onComplete:(SEL)aOnCompleteSelector
			   onError:(SEL)aOnErrorSelector
{
	if (self = [self init]) {
		self.sender = aSender;
		self.onCompleteSelector = aOnCompleteSelector;
		self.onErrorSelector = aOnErrorSelector;
	}
	
	return self;
}

- (id)initWithParams:(NSString*)reqParams 
		withPostData:(NSData*)postData
		  parseClass:(Class)parseClass
		  onComplete:(FSRequestCompleteBlock)onCompleteBlock
			 onError:(FSRequestErrorBlock)onErrorBlock
{
	if (self = [self init]) {
        
		self.reqParam = reqParams;
		self.buffer = postData;
//        NSLog(@"%@", [[[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding] autorelease]);
		self.baseParse = [[[parseClass alloc] init] autorelease];
		
		_onCompleteBlock = [onCompleteBlock copy];
		_onErrorBlock = [onErrorBlock copy];
	}
	
	return self;
}

- (FSActionParser*)parseResult:(NSString *)data
{
	[baseParse parse:data];
	return baseParse;
}

-(void)toAddQueue:(ASINetworkQueue*)queue
{
	[queue addOperation:_connection];
	[queue go];
}

- (void)actionString:(NSString*)result
{
	[self stopBusyHUD];
	
	NSLog(@"get the return json : %@",result);
	
	if (!isCancel) {
		[baseParse parse:result];
		
		if ([self.sender respondsToSelector:self.onCompleteSelector])
			[self.sender performSelector:self.onCompleteSelector withObject:baseParse];
		
		if (_onCompleteBlock != nil)
			_onCompleteBlock(baseParse);
	}

	if ([executingRequests indexOfObject:self] != NSNotFound) {
		[executingRequests performSelector:@selector(removeObject:) withObject:self afterDelay:0.05f];
	}
}

- (void)actionError:(NSError*)error
{
	[self stopBusyHUD];
	
	if (!isCancel) {
		if ([self.sender respondsToSelector:self.onErrorSelector])
			[self.sender performSelector:self.onErrorSelector withObject:error];
		
		if (_onErrorBlock != nil)
			_onErrorBlock(error);
	}
	
	[self autorelease];
	
	if ([executingRequests indexOfObject:self] != NSNotFound)
		[executingRequests removeObject:self];
}

- (void)cancel
{
	[self stopBusyHUD];
	
	isCancel = YES;
	[self releaseConnection];
}

- (void)execute:(BOOL)showBusyLayer 
{
    if (_hud != nil) {
        [_hud removeFromSuperview];
	    [_hud release];
	    _hud = nil;
    }
	
	if ([executingRequests indexOfObject:self] == NSNotFound) {
		[executingRequests addObject:self];
	}
	
	//NSLog(@"the domain is %@",self.domain);
	
	NSString *fullUrl = [NSString stringWithFormat:@"%@%@", self.domain, self.reqParam];
	
	NSLog(@"req: %@" ,fullUrl);
	[self releaseConnection];
	
	isCancel = NO;
	_connection = [[HttpRequestWrapper alloc] initWithURL:[NSURL URLWithString:fullUrl]];
	
	[self onConnectionCreated:_connection];
	_connection.sender = self;
	_connection.actionString = @selector(actionString:);
	[_connection sendData:buffer withURL:fullUrl];
	
	if (showBusyLayer) {
		[self showBusyHUD];
		
		// 移除别的请求
		if (self.isAutoCancelOtherNonBusyRequest) {
			NSMutableArray* deallocedRequests = [NSMutableArray array];
			
			for (FSActionRequest* req in executingRequests) {
				if (req != self && req.isBusyHUDShown)
					[deallocedRequests addObject:req];
			}
			
			for (FSActionRequest* req in deallocedRequests) {
				[req cancel];
				[executingRequests removeObject:req];
			}
		}
	}
}

- (void)execute 
{
	[self execute:YES];
}

- (BOOL)isBusyHUDShown
{
	return _hud != nil && ([_hud.superview.subviews indexOfObject:_hud] != NSNotFound);
}

-(void)asynRequest:(NSString*)url param:(NSMutableDictionary*)dic
{
	NSString *fullUrl = [NSString stringWithFormat:@"%@/%@",domain,url];
	if (!domain)
		fullUrl = url;
	
	[self cancel];
	isCancel = NO;
	_connection = [[HttpRequestWrapper alloc] initWithURL:[NSURL URLWithString:[URLHelper getURL:fullUrl queryParameters:dic]]];
    
	[self onConnectionCreated:_connection];
	_connection.sender = self;
	_connection.actionString = @selector(actionString:);
	[_connection sendData:buffer withURL:nil];
	//[self showBusyHUD];
}

- (void) onConnectionCreated:(HttpRequestWrapper*)req 
{
	
}

- (void)shouldDoInBackground:(BOOL)yesOrNo
{
	[_connection setShouldContinueWhenAppEntersBackground:yesOrNo];
}

+ (void)cancelAllExecutingRequests
{
	NSArray* executingRequestsCopy = [NSArray arrayWithArray:executingRequests];
	for (FSActionRequest* req in executingRequestsCopy)
		SAFE_RELEASE(req);
}

@end
