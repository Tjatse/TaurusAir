//
//  NSObjectAdditions.h
//  YmartClient
//
//  Created by Yang Felix on 12-6-10.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (Additions)

- (id)performSelector:(SEL)aSelector withMultiObjects:(id)object,...;
- (void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay withMultiObjects:(id)object,...;

@end
