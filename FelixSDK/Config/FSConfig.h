//
//  NSConfig.h
//  SalesUnion
//
//  Created by Felix on 11-11-5.
//  Copyright 2011 deep. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Domain_Key 			@"Domain"
#define configPath_Key 		@"configPath"
#define configType_Key 		@"configType"

@interface FSConfig : NSObject 

@property (nonatomic, retain) NSString* serverURL;

+ (FSConfig*)engine;
+ (NSString*)getConfigPath;

+ (NSArray*)readArrayWithKey:(NSString*)key;
+ (NSObject*)readObjectWithKey:(NSString*)key;
+ (NSString*)readValueWithKey:(NSString*)key;
+ (NSString*)readMainValueWithKey:(NSString*)key;
+ (int)readIntegerWithKey:(NSString*)key;
+ (BOOL)readBoolWithKey:(NSString*)key;

+ (NSArray*)readArrayWithKey:(NSString*)key defaultValue:(NSArray*)defValue;
+ (NSObject*)readObjectWithKey:(NSString*)key defaultValue:(NSObject*)defValue;
+ (NSString*)readValueWithKey:(NSString*)key defaultValue:(NSString*)defValue;
+ (NSString*)readMainValueWithKey:(NSString*)key defaultValue:(NSString*)defValue;
+ (int)readIntegerWithKey:(NSString*)key defaultValue:(int)defValue;
+ (BOOL)readBoolWithKey:(NSString*)key defaultValue:(BOOL)defValue;

+ (BOOL)setArray:(NSArray*)array withKey:(NSString*)key;
+ (BOOL)setValue:(NSString*)value withKey:(NSString*)key;
+ (BOOL)setObject:(NSObject*)object withKey:(NSString*)key;
+ (BOOL)setBoolValue:(BOOL)value withKey:(NSString*)key;
+ (BOOL)setIntegerValue:(int)value withKey:(NSString*)key;

@end
