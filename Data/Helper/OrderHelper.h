//
//  OrderHelper.h
//  TaurusClient
//
//  Created by Tjatse on 13-1-4.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderHelper : NSObject
+ (void)orderListWithId: (NSString *)userId
                success: (void (^)(NSArray *orders))success
                failure: (void (^)(NSString *errorMsg))failure;
@end
