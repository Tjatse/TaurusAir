#import "NSObject(notification).h"
#import "FSNotification.h"

@implementation NSObject(notification)

#pragma mark -
#pragma mark addObserver

-(void)addObserverWithSelector:(SEL)aSelector name:(NSString*)aNotificationName object:(id)aObject
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:aSelector
												 name:aNotificationName
											   object:aObject];		
}

-(void)addObserverWithSelector:(SEL)aSelector name:(NSString*)aNotificationName
{
	[self addObserverWithSelector:aSelector name:aNotificationName object:nil];		
}


+(void)postNotification:(NSString*)aNotificationName
{
    [[NSNotificationCenter defaultCenter] postNotificationName:aNotificationName object:nil];
}

+(void)postNotification:(NSString*)aNotificationName object:(id)aObject
{
    [[NSNotificationCenter defaultCenter] postNotificationName:aNotificationName object:aObject];
}

+(void)PostNotificationWithOCMsgExtend:(NSString*)notiName message:(OCMSG)msg requester:(void*)req
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:
						  [NSNumber numberWithInt:msg.lParam], ZM_NOTI_LPARAM,
						  [NSNumber numberWithInt:msg.wParam], ZM_NOTI_WPARAM,
						  nil];
	
	NSNotification* notification = [NSNotification notificationWithName:notiName
																 object:req
															   userInfo:dict];
	if (notification) 
	{
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:)
															   withObject:notification
															waitUntilDone:YES];
	}
    [dict release];
	[pool release];
}

+(void)PostNotificationWithOCMsg:(NSString*)notiName message:(OCMSG)msg
{
    [self PostNotificationWithOCMsgExtend:notiName
								  message:msg
								requester:NULL];
}

+(void)postNotificationObject:(NSString*)notiName msg:(id)obj
{
    //NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:
						  obj, ZM_NOTI_LPARAM,
						  nil];
	
	NSNotification* notification = [NSNotification notificationWithName:notiName
																 object:NULL
															   userInfo:dict];
	if (notification) 
	{
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:)
															   withObject:notification
															waitUntilDone:YES];
	}
    [dict release];
	//[pool release];
}
#pragma mark -
#pragma mark removeObserver

-(void)removeObserver
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)removeObserverWithName:(NSString*)aNotificationName object:(id)aObject
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:aNotificationName
												  object:aObject];	
}

-(void)removeObserverWithName:(NSString*)aNotificationName
{
    [self removeObserverWithName:aNotificationName object:nil];
}



@end


@implementation NSMsgSend
@synthesize sender,action,failAction,type,data;

@end
