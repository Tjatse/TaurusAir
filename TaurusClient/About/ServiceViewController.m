//
//  ServiceViewController.m
//  TaurusClient
//
//  Created by Tjatse on 13-2-19.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "ServiceViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDefines.h"

@interface ServiceViewController ()

@end

@implementation ServiceViewController

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
    [self setTitle:@"服务条款"];
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
    [self loadServiceInfo];
}

- (void)loadServiceInfo
{
    NSString *content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"service" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    [_textView setText:content];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_textView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
