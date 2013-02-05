//
//  CRUDViewController.m
//  TaurusClient
//
//  Created by Tjatse on 13-2-5.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "CRUDViewController.h"
#import "MBProgressHUD.h"
#import "OrderHelper.h"
#import "AppConfig.h"
#import "NSDictionaryAdditions.h"
#import "ALToastView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDefines.h"

@interface CRUDViewController ()

@end

@implementation CRUDViewController
@synthesize textView = _textView;

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
    
    [self setTitle:@"退改签"];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    CGRect fs = [self.view bounds];
    NSLog(@"%@", NSStringFromCGRect(fs));
    float bounce = 5;
    CGRect f = CGRectMake(bounce, bounce, fs.size.width - bounce * 2, fs.size.height - bounce * 2);
    [_textView setFrame:f];
    
    _textView.clipsToBounds = YES;
    _textView.alpha = 0.9;
    
    [_textView setBackgroundColor: UIColorFromRGB(0xf4f9fb)];
    _textView.layer.frame = f;
    _textView.layer.shadowColor = [UIColor blackColor].CGColor;
    _textView.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    //_textView.layer.shadowOpacity = 0.5;
    _textView.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.cornerRadius = 5;
    [self loadCRUDInfo];
}

- (void)loadCRUDInfo
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在查询...";
    
    [OrderHelper performGetCabinRemark:[AppConfig get].currentUser
                                andEzm:_ezm
                              andCabin:_cabin
                               success:^(NSDictionary * jsonObj) {
                                   [MBProgressHUD hideHUDForView:self.view
                                                        animated:YES];
                                   
                                   NSString* response = [jsonObj getStringValueForKey:@"Response"
                                                                         defaultValue:@""];
                                   
                                   if (response.length == 0)
                                       response = @"暂无信息。";
                                   
                                   [_textView setText:response];
                               }
                               failure:^(NSString *errorMsg) {
                                   [MBProgressHUD hideHUDForView:self.view
                                                        animated:YES];
                                   
                                   [ALToastView toastInView:self.view
                                                   withText:errorMsg
                                            andBottomOffset:44.0f
                                                    andType:ERROR];
                               }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.textView = nil;
	self.ezm = nil;
	self.cabin = nil;
	
    [super dealloc];
}

@end
