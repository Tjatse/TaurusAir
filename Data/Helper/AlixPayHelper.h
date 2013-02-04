//
//  AlixPayHelper.h
//  TaurusClient
//
//  Created by Simon on 13-2-4.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlixPayHelper : NSObject

+ (void)performAlixPayWithOrderId:(NSString*)orderId
				   andProductName:(NSString*)productName
				   andProductDesc:(NSString*)productDesc
				  andProductPrice:(float)productPrice;

@end
