//
//  NSObject+Serialize.h
//  FelixSDK
//
//  Created by Yang Felix on 12-5-7.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Serialize)

- (void)serializeObjectToFile:(NSString*)fileName 
				 serializeKey:(NSString*)serializeKey;

+ (id)deserializeObjectFromFile:(NSString*)fileName
				   serializeKey:(NSString*)serializeKey;

@end
