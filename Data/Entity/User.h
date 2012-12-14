//
//  User.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

@property (nonatomic, retain) NSString      *clientIP;
@property (nonatomic, retain) NSString      *guid;
@property (nonatomic, retain) NSString      *tId;
@property (nonatomic, retain) NSString      *userName;

- (id)initWithClientIP:(NSString*)theClientIP guid:(NSString*)theGuid tId:(NSString*)theTId userName:(NSString*)theUserName;

@end
