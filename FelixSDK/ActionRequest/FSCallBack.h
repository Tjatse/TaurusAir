#import <Foundation/Foundation.h>

@interface FSCallBack : NSObject {
	SEL		callAction;
	id		callDel;
}

@property (nonatomic, assign) SEL callAction;
@property (nonatomic, assign) id callDel;

@end
