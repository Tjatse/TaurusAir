//
//  AppConfig.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "AppConfig.h"

static AppConfig *singleton = nil;
static int _currentNumber = 1;

@implementation AppConfig
@synthesize currentUser;
@synthesize logon;
@synthesize pwdRecoveryHash;
@synthesize rememberedName;

- (void) dealloc
{
    [currentUser release], currentUser = nil;
    [pwdRecoveryHash release], pwdRecoveryHash = nil;
    [super dealloc];
}

+ (AppConfig*) get
{
    if(!singleton){
        if ([self isKindOfClass:[AppConfig class]]) {
            singleton = [[AppConfig alloc] init];
            [singleton clear];
        } else {
            singleton = [[self alloc] init];
        }
    }
    return singleton;
}
- (BOOL)isLogon
{
    return self.currentUser != nil;
}

- (void) loadState
{
    singleton = [self loadState:_currentNumber];
}
- (AppConfig*) loadState:(int)loadNumber{
    _currentNumber = loadNumber;
    id ret = [self loadState:STATE_NAMING_IMAGE_HANDLER_AC number:loadNumber];
    if (nil == ret) {
        [self clear];
        return self;
    }else {
        [singleton release];
        singleton = [ret retain];
        return ret;
    }
}

- (void) saveState{
    [self saveState:_currentNumber];
}

-(void) saveState:(int)saveNumber{
    [self saveState:STATE_NAMING_IMAGE_HANDLER_AC number:saveNumber object:self];
}

- (void) reset{
    [self reset:_currentNumber];
}

- (void) reset:(int)saveNumber{
    [self loadState:saveNumber];
    [self clear];
    [self saveState:saveNumber];
}

- (void) clear
{
    [currentUser release], currentUser = nil;
    //[pwdRecoveryHash release], pwdRecoveryHash = nil;
}

- (void)destroy
{
    [singleton loadState];
    [singleton clear];
    [singleton saveState];
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.currentUser forKey:@"currentUser"];
    [encoder encodeObject:self.pwdRecoveryHash forKey:@"pwdRecoveryHash"];
    [encoder encodeObject:self.rememberedName forKey:@"rememberedName"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.currentUser = [decoder decodeObjectForKey:@"currentUser"];
        self.pwdRecoveryHash = [decoder decodeObjectForKey:@"pwdRecoveryHash"];
        self.rememberedName = [decoder decodeObjectForKey:@"rememberedName"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setCurrentUser:[[self.currentUser copy] autorelease]];
    [theCopy setPwdRecoveryHash:[[self.pwdRecoveryHash copy] autorelease]];
    [theCopy setRememberedName:[[self.rememberedName copy] autorelease]];
    
    return theCopy;
}
@end
