//
//  StateBase.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define STATE_DEFAULT_FILENAME @"%@-%d.dat"
#define STATE_DEFAULT_NUMBER 0

@interface StateBase : NSObject <NSCoding> {
    
}

// load specific state from localstorage
-(id) loadState:(NSString*)naming;
// load specific state from localstorage
-(id) loadState:(NSString*)naming number:(int)number;
// save state to localstorage
-(void) saveState:(NSString*)naming object:(id)obj;
// save state to localstorage
-(void) saveState:(NSString*)naming number:(int)number object:(id)obj;

@end
