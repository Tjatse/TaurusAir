//
//  UIObject+AnimationBlock.h
//  FelixSDK
//
//  Created by Simon on 12-12-27.
//  Copyright (c) 2012年 FelixSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef void (^OnAnimationDidStartBlock)(CAAnimation* anim);
typedef void (^OnAnimationDidStopBlock)(CAAnimation* anim, BOOL finished);

@interface CAAnimation (AnimationBlock)

- (void)setAnimationDidStartBlock:(OnAnimationDidStartBlock)startBlock
		 andAnimationDidStopBlock:(OnAnimationDidStopBlock)stopBlock;

@end
