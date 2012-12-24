//
//  UserHelper.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-23.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserHelper : NSObject

+ (void)findPwd: (NSString *) loginName
          phone: (NSString *)phone
        success: (void (^)())success
        failure: (void (^)(NSString *errorMsg))failure;
@end
