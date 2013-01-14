//
//  User.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize userId = _userId;
@synthesize loginName = _loginName;
@synthesize name = _name;
@synthesize phone = _phone;
@synthesize email = _email;
@synthesize remark = _remark;
@synthesize gender = _gender;
@synthesize birthday = _birthday;
@synthesize guid = _guid;
@synthesize userPwd = _userPwd;
@synthesize userName = _userName;

//===========================================================
// - (id)initWith:
//
//===========================================================
- (id)initWithUserId:(NSString*)theUserId userName:(NSString*)theUserName loginName:(NSString*)theLoginName userPwd:(NSString*)theUserPwd name:(NSString*)theName phone:(NSString*)thePhone email:(NSString*)theEmail remark:(NSString*)theRemark gender:(BOOL)flag birthday:(NSString*)theBirthday guid:(NSString*)theGuid
{
    self = [super init];
    if (self) {
        _userId = [theUserId retain];
        _loginName = [theLoginName retain];
        _name = [theName retain];
        _phone = [thePhone retain];
        _email = [theEmail retain];
        _remark = [theRemark retain];
        _gender = flag;
        _birthday = [theBirthday retain];
        _guid = [theGuid retain];
        _userPwd = [theUserPwd retain];
        _userName = [theUserName retain];
    }
    return self;
}

- (void)dealloc
{
    [_userId release], _userId = nil;
    [_loginName release], _loginName = nil;
    [_name release], _name = nil;
    [_phone release], _phone = nil;
    [_email release], _email = nil;
    [_remark release], _remark = nil;
    [_birthday release], _birthday = nil;
    [_guid release], _guid = nil;
    [_userPwd release], _userPwd = nil;
    [_userName release], _userName = nil;
    [super dealloc];
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.loginName forKey:@"loginName"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.remark forKey:@"remark"];
    [encoder encodeBool:self.gender forKey:@"gender"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    [encoder encodeObject:self.guid forKey:@"guid"];
    [encoder encodeObject:self.userPwd forKey:@"userPwd"];
    [encoder encodeObject:self.userName forKey:@"userName"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.loginName = [decoder decodeObjectForKey:@"loginName"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.remark = [decoder decodeObjectForKey:@"remark"];
        self.gender = [decoder decodeBoolForKey:@"gender"];
        self.birthday = [decoder decodeObjectForKey:@"birthday"];
        self.guid = [decoder decodeObjectForKey:@"guid"];
        self.userPwd = [decoder decodeObjectForKey:@"userPwd"];
        self.userName = [decoder decodeObjectForKey:@"userName"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setUserId:[[self.userId copy] autorelease]];
    [theCopy setLoginName:[[self.loginName copy] autorelease]];
    [theCopy setName:[[self.name copy] autorelease]];
    [theCopy setPhone:[[self.phone copy] autorelease]];
    [theCopy setEmail:[[self.email copy] autorelease]];
    [theCopy setRemark:[[self.remark copy] autorelease]];
    [theCopy setGender:self.gender];
    [theCopy setBirthday:[[self.birthday copy] autorelease]];
    [theCopy setGuid:[[self.guid copy] autorelease]];
    [theCopy setUserPwd:[[self.userPwd copy] autorelease]];
    [theCopy setUserName:[[self.userName copy] autorelease]];
    
    return theCopy;
}
@end
