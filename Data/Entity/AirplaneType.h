//
//  AirplaneType.h
//  TaurusClient
//
//  Created by Simon on 13-1-12.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirplaneType : NSObject

@property (nonatomic, retain) NSString *tid;
@property (nonatomic, retain) NSString *shortModel;
@property (nonatomic, retain) NSString *remark;
@property (nonatomic, retain) NSString *planeType;
- (id)initWithTid:(NSString*)aTid shortModel:(NSString*)aShortModel remark:(NSString*)aRemark planeType:(NSString*)aPlaneType;

@end
