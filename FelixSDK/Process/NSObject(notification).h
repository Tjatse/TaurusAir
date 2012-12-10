#import <Foundation/Foundation.h>

typedef struct _msg
{
	NSInteger wParam;
	NSInteger lParam;
}OCMSG;

@interface NSObject(notification)
-(void)addObserverWithSelector:(SEL)aSelector name:(NSString*)aNotificationName object:(id)aObject;
-(void)addObserverWithSelector:(SEL)aSelector name:(NSString*)aNotificationName;

-(void)removeObserver;
-(void)removeObserverWithName:(NSString*)aNotificationName object:(id)aObject;
-(void)removeObserverWithName:(NSString*)aNotificationName;
+(void)postNotification:(NSString*)aNotificationName;
+(void)postNotification:(NSString*)aNotificationName object:(id)aObject;

+(void)PostNotificationWithOCMsgExtend:(NSString*)notiName message:(OCMSG)msg requester:(void*)req;
+(void)PostNotificationWithOCMsg:(NSString*)notiName message:(OCMSG)msg;
+(void)postNotificationObject:(NSString*)notiName msg:(id)obj;
@end


@interface NSMsgSend : NSObject {
    id data;
    NSInteger type;
    id sender;
    SEL action;
    SEL failAction;
}
@property(nonatomic,assign)id data;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)SEL failAction;
@property(nonatomic,assign)id sender;
@property(nonatomic,assign)SEL action;
@end