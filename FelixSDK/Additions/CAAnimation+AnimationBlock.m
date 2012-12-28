//
//  UIObject+AnimationBlock.m
//  FelixSDK
//
//  Created by Simon on 12-12-27.
//  Copyright (c) 2012年 FelixSDK. All rights reserved.
//

#import <objc/runtime.h>
#import "CAAnimation+AnimationBlock.h"

static char CAAnimationDidStartBlockKey;
static char CAAnimationDidStopBlockKey;

@interface AnimationTempObject : NSObject

@end

@implementation AnimationTempObject

- (void)animationDidStart:(CAAnimation *)anim
{
	OnAnimationDidStartBlock startBlock = objc_getAssociatedObject(self, &CAAnimationDidStartBlockKey);
	if (startBlock != nil)
		startBlock(anim);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	OnAnimationDidStopBlock stopBlock = objc_getAssociatedObject(self, &CAAnimationDidStopBlockKey);
	if (stopBlock != nil)
		stopBlock(anim, flag);
}

@end

@implementation CAAnimation (AnimationBlock)

- (void)setAnimationDidStartBlock:(OnAnimationDidStartBlock)startBlock
		 andAnimationDidStopBlock:(OnAnimationDidStopBlock)stopBlock
{
	AnimationTempObject* tempObj = [[[AnimationTempObject alloc] init] autorelease];
	
    objc_setAssociatedObject(tempObj, &CAAnimationDidStartBlockKey, startBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(tempObj, &CAAnimationDidStopBlockKey, stopBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
	
	self.delegate = tempObj;
}

@end
