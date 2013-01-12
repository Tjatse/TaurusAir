//
//  NSObject+StrongRefTag.h
//  TaurusClient
//
//  Created by Simon on 13-1-8.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RefTag)

@property (nonatomic, retain) id	strongRefTag;
@property (nonatomic, assign) id	weakRefTag;

@end
