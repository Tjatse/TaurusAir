//
//  OrderState.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-26.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderState : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *title;
- (id)initWithCode:(NSString*)theCode title:(NSString*)theTitle;

@end
