//
//  FlightSelectViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "FlightSelectViewController.h"

@interface FlightSelectViewController ()

@end

@implementation FlightSelectViewController

#pragma mark - life cycle

- (void)dealloc
{
	self.dateLabel = nil;
	self.cityFromToLabel = nil;
	self.ticketCountLabel = nil;
	self.ticketResultsVw = nil;
	self.timeSortImgVw = nil;
	self.priceSortImgVw = nil;
	
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

@end
