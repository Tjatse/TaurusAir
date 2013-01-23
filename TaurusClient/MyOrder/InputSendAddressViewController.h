//
//  InputSendAddressViewController.h
//  TaurusClient
//
//  Created by Simon on 13-1-23.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrepareOrderViewController;

@interface InputSendAddressViewController : UIViewController

@property (nonatomic, retain) NSString*				sendAddress;
@property (nonatomic, retain) IBOutlet UITextView*	sendAddressTextVw;

- (id)initWithParentVC:(PrepareOrderViewController*)aParentVC;

@end
