//
//  ContacterHelper.h
//  TaurusClient
//
//  Created by Tjatse on 13-1-11.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    kAdd = 1,
    kModify = 2,
    kDelete = 3
}
TravelerOperateType;

@interface ContacterHelper : NSObject
+ (void)passengersWithId: (NSString *)userId
                 success: (void (^)(NSArray *passengers))success
                 failure: (void (^)(NSString *errorMsg))failure;

+ (void)contactersWithId: (NSString *)userId
                 success: (void (^)(NSArray *passengers))success
                 failure: (void (^)(NSString *errorMsg))failure;


+ (void)contacterOperateWithData: (NSDictionary *)data
                     operateType: (TravelerOperateType)operateType
                         success: (void (^)(NSString *identification))success
                         failure: (void (^)(NSString *errorMsg))failure;

+ (void)passengerOperateWithData: (NSDictionary *)data
                     operateType: (TravelerOperateType)operateType
                         success: (void (^)(NSString *identification))success
                         failure: (void (^)(NSString *errorMsg))failure;

@end
