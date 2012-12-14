//
//  User.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize clientIP = _clientIP;
@synthesize guid = _guid;
@synthesize tId = _tId;
@synthesize userName = _userName;

//===========================================================
// - (id)initWith:
//
//===========================================================
- (id)initWithClientIP:(NSString*)theClientIP guid:(NSString*)theGuid tId:(NSString*)theTId userName:(NSString*)theUserName
{
    self = [super init];
    if (self) {
        _clientIP = [theClientIP retain];
        _guid = [theGuid retain];
        _tId = [theTId retain];
        _userName = [theUserName retain];
    }
    return self;
}


- (void)dealloc
{
    [_clientIP release], _clientIP = nil;
    [_guid release], _guid = nil;
    [_tId release], _tId = nil;
    [_userName release], _userName = nil;
    [super dealloc];
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.clientIP forKey:@"clientIP"];
    [encoder encodeObject:self.guid forKey:@"guid"];
    [encoder encodeObject:self.tId forKey:@"tId"];
    [encoder encodeObject:self.userName forKey:@"userName"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.clientIP = [decoder decodeObjectForKey:@"clientIP"];
        self.guid = [decoder decodeObjectForKey:@"guid"];
        self.tId = [decoder decodeObjectForKey:@"tId"];
        self.userName = [decoder decodeObjectForKey:@"userName"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setClientIP:[[self.clientIP copy] autorelease]];
    [theCopy setGuid:[[self.guid copy] autorelease]];
    [theCopy setTId:[[self.tId copy] autorelease]];
    [theCopy setUserName:[[self.userName copy] autorelease]];
    
    return theCopy;
}
@end
