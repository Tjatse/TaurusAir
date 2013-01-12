//
//  NSObject+StrongRefTag.m
//  TaurusClient
//
//  Created by Simon on 13-1-8.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "NSObject+RefTag.h"
#import <objc/runtime.h>

static char NSObjectStrongRefTagKey;
static char NSObjectWeakRefTagKey;

@implementation NSObject (RefTag)

- (id)strongRefTag
{
	id result = objc_getAssociatedObject(self, &NSObjectStrongRefTagKey);
	return result;
}

- (void)setStrongRefTag:(id)strongRefTag
{
	objc_setAssociatedObject(self, &NSObjectStrongRefTagKey, strongRefTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)weakRefTag
{
	id result = objc_getAssociatedObject(self, &NSObjectWeakRefTagKey);
	return result;
}

- (void)setWeakRefTag:(id)weakRefTag
{
	objc_setAssociatedObject(self, &NSObjectWeakRefTagKey, weakRefTag, OBJC_ASSOCIATION_ASSIGN);
}

@end
