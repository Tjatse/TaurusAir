//
//  HelpViewController.h
//  TaurusClient
//
//  Created by Tjatse on 13-2-19.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController<UIScrollViewDelegate>{
    NSInteger         kNumberOfPages;

    // To be used when scrolls originate from the UIPageControl
    BOOL              pageControlUsed;

}

@property (retain, nonatomic) IBOutlet UIScrollView     *scrollView;
@property (retain, nonatomic) IBOutlet UIImageView      *imageView;
@property (retain, nonatomic) NSArray                   *arrayImageView; 
@property (retain, nonatomic) NSMutableArray            *imageViews;
@property (retain, nonatomic) IBOutlet UIPageControl    *pagesControl;
@property (retain, nonatomic) IBOutlet UIButton         *buttonIn;

- (IBAction)actionIn:(id)sender;

@end
