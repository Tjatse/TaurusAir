//
//  TwoCharCode.h
//  TaurusClient
//
//  Created by Simon on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwoCharCode : NSObject

@property (nonatomic, retain) NSString *charCode;
@property (nonatomic, retain) NSString *corpFullName;
@property (nonatomic, retain) NSString *corpAbbrName;
@property (nonatomic, assign) int flightAreaCode;
- (id)initWithCharCode:(NSString*)aCharCode corpFullName:(NSString*)aCorpFullName corpAbbrName:(NSString*)aCorpAbbrName flightAreaCode:(int)aFlightAreaCode;
+ (id)objectWithCharCode:(NSString*)aCharCode corpFullName:(NSString*)aCorpFullName corpAbbrName:(NSString*)aCorpAbbrName flightAreaCode:(int)aFlightAreaCode;
@end
