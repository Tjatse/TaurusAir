//
//  PrepareOrderViewController.h
//  TaurusClient
//
//  Created by Simon on 13-1-12.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlightSelectViewController;

@interface PrepareOrderViewController : UIViewController

@property (nonatomic, retain) NSString*		sendAddress;

- (id)initWithFlightSelectVC:(FlightSelectViewController*)aParentVC;

@end
