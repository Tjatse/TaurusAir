//
//  CorpInfoViewController.m
//  TaurusClient
//
//  Created by Simon on 13-1-2.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "CorpInfoViewController.h"

@interface CorpInfoViewController () <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView*					webVw;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView*		loadingVw;

@end

@implementation CorpInfoViewController

- (void)dealloc
{
	self.webVw = nil;
	self.loadingVw = nil;
	
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
	
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.loadingVw] autorelease];
	
	self.loadingVw.hidden = NO;
	[self.loadingVw startAnimating];
	
    self.title = @"公司信息";
	[self.webVw loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jinniuit.com"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - webview delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self.loadingVw stopAnimating];
	self.loadingVw.hidden = YES;
}

@end
