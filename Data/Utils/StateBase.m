//
//  StateBase.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "StateBase.h"

@interface StateBase (Private)
+(NSString*) makeKey:(NSString *)naming saveNumber:(int)saveNumber;
+(NSString*) makeSavePath:(NSString *)key;
@end

@implementation StateBase

-(void) dealloc
{
    [super dealloc];
}

-(id) initWithCoder:(NSCoder*)coder
{
    self = [super init];
    return self;
}

-(void) encodeWithCoder:(NSCoder*)coder
{
    
}

-(id) loadState:(NSString*)naming {
   
    return [self loadState:naming number:STATE_DEFAULT_NUMBER];
}

-(id) loadState:(NSString*)naming number:(int)number {
    NSString* key = [StateBase makeKey:naming saveNumber:number];
    NSString* path = [StateBase makeSavePath:key];
    NSData* filedata = [[[NSData alloc] initWithContentsOfFile:path] autorelease];
    
    // couldn't load?
    if(filedata == nil)
    {
        NSLog(@"Couldn't load state(%@), so initialized with defaults", path);
        return nil;
    }else {
        NSLog(@"Loading state (%@) success!!!", path);
        return [NSKeyedUnarchiver unarchiveObjectWithData:filedata];
    }
}

-(void) saveState:(NSString*)naming object:(id)obj {
    [self saveState:naming number:STATE_DEFAULT_NUMBER object:obj];
}

-(void) saveState:(NSString*)naming number:(int)number object:(id)obj {
    NSString* key = [StateBase makeKey:naming saveNumber:number];
    NSString* path = [StateBase makeSavePath:key];
    NSData* objData = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [objData writeToFile:path atomically:TRUE];
}

+(NSString*) makeKey:(NSString *)naming saveNumber:(int)saveNumber
{
    NSString* key = [[[NSString alloc] initWithFormat:STATE_DEFAULT_FILENAME, naming, saveNumber] autorelease];
    return key;
}

+(NSString*) makeSavePath:(NSString *)key
{
    // get our app's document directory
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* savePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:key];
    
    return savePath;
}

@end
