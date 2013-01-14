//
//  User.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

@property (nonatomic, retain) NSString      *userId;
@property (nonatomic, retain) NSString      *userName;
@property (nonatomic, retain) NSString      *loginName;
@property (nonatomic, retain) NSString      *name;
@property (nonatomic, retain) NSString      *phone;
@property (nonatomic, retain) NSString      *email;
@property (nonatomic, retain) NSString      *remark;
@property (nonatomic, readwrite) BOOL       gender;
@property (nonatomic, retain) NSString      *birthday;
@property (nonatomic, retain) NSString      *guid;
@property (nonatomic, retain) NSString      *userPwd;

- (id)initWithUserId:(NSString*)theUserId userName:(NSString*)theUserName loginName:(NSString*)theLoginName userPwd:(NSString*)theUserPwd name:(NSString*)theName phone:(NSString*)thePhone email:(NSString*)theEmail remark:(NSString*)theRemark gender:(BOOL)flag birthday:(NSString*)theBirthday guid:(NSString*)theGuid;

@end
