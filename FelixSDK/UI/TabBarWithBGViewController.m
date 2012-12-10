//
//  TabBarWithBGViewController.m
//  FelixSDK
//
//  Created by Yang Felix on 12-4-13.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import "TabBarWithBGViewController.h"

@interface TabBarWithBGViewController ()

@end

@implementation TabBarWithBGViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
	if (self = [super init]) {
		UIImageView* imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar.png"]];
		imgv.frame = CGRectMake(0,0,self.tabBar.frame.size.width,self.tabBar.frame.size.height);
		imgv.contentMode = UIViewContentModeScaleToFill;
		// imgv.frame = CGRectOffset(imgv.frame,0,1);
		[[self tabBar] insertSubview:imgv atIndex:0];
		[imgv release];
	}
	
	return self;
}
	
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
