//
//  UserHelper.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-23.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserHelper : NSObject

+ (void)validCodeWithPhone: (NSString *)phone
                   success: (void (^)(NSString *code))success
                   failure: (void (^)(NSString *errorMsg))failure;

+ (void)pwdRecoveryWithLoginName: (NSString *)loginName
                          cnName: (NSString *)cnName
                         success: (void (^)())success
                         failure: (void (^)(NSString *errorMsg))failure;

+ (void)pwdEditWithId: (NSString *)userId
          oldPassword: (NSString *)oldPassword
          newPassword: (NSString *)newPassword
              success: (void (^)())success
              failure: (void (^)(NSString *errorMsg))failure;

+ (void)registerUserWithPhone: (NSString *)phone
                    validCode: (NSString *)validCode
                     password: (NSString *)password
                      success: (void (^)())success
                      failure: (void (^)(NSString *errorMsg))failure;

+ (void)loginWithName: (NSString *)userName
             password: (NSString *)password
              success: (void (^)(User *user))success
              failure: (void (^)(NSString *errorMsg))failure;

+ (void)userInfoWithId: (NSString *)userId
               success: (void (^)(User *user))success
               failure: (void (^)(NSString *errorMsg))failure;

+ (void)logoutWithId: (NSString *)userId
             success: (void (^)())success
             failure: (void (^)(NSString *errorMsg))failure;

+ (void)editUserInfo: (User *)user
             success: (void (^)())success
             failure: (void (^)(NSString *errorMsg))failure;
@end
