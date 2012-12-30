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
@property (nonatomic, retain) NSString      *loginName;
@property (nonatomic, retain) NSString      *name;
@property (nonatomic, retain) NSString      *phone;
@property (nonatomic, retain) NSString      *email;
@property (nonatomic, retain) NSString      *remark;
@property (nonatomic, readwrite) BOOL       gender;
@property (nonatomic, retain) NSString      *birthday;

- (id)initWithUserId:(NSString*)theUserId loginName:(NSString*)theLoginName name:(NSString*)theName phone:(NSString*)thePhone email:(NSString*)theEmail remark:(NSString*)theRemark gender:(BOOL)flag birthday:(NSString*)theBirthday;

@end
