//
//  AboutViewController.m
//  TaurusClient
//
//  Created by Simon on 13-1-2.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "AboutViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "CorpInfoViewController.h"
#import "AppDefines.h"
#import "ServiceViewController.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "ASIHTTPRequest.h"
#import "ALToastView.h"
#import <QuartzCore/QuartzCore.h>
#import "HelpViewController.h"

@interface AboutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView*		tableView;

@end

@implementation AboutViewController

- (void)dealloc
{
	self.tableView = nil;
	[_url release];
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
    self.title = @"关于我们";
	
	self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController dismissModalViewControllerAnimated:YES];
                                       }];
    
	self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem generateNormalStyleButtonWithTitle:@"条款"
                                         andTapCallback:^(id control, UIEvent *event) {
                                             ServiceViewController *vc = [[ServiceViewController alloc] init];
                                             [self.navigationController pushViewController:vc animated:YES];
                                             [vc release];
                                         }];
    
    [self renderView];
}

- (void)renderView
{
    CGFloat w = SCREEN_RECT.size.width;
    // logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
    [logo setFrame:CGRectMake((w - 57)/2, 40, 57, 57)];
    [logo.layer setCornerRadius:5];
    [logo.layer setShadowColor:[UIColor blackColor].CGColor];
    [logo.layer setShadowOffset:CGSizeMake(2, 2)];
    [logo.layer setShadowOpacity:0.5];
    [logo setClipsToBounds:YES];
    
    [self.view addSubview:logo];
    [logo release];
    
    // name
    UILabel *labelName = [self generateLabel:CGRectMake(0, 100, w, 40)
                                withFontSize:[UIFont boldSystemFontOfSize:28]
                                    andColor:[UIColor blackColor]];
    [labelName setTextAlignment:UITextAlignmentCenter];
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    [labelName setText:[info objectForKey:@"CFBundleDisplayName"]];
    [self.view addSubview:labelName];

    // version
    UILabel *labelVersion =  [self generateLabel:CGRectMake(0, 145, w, 18)
                                    withFontSize:[UIFont systemFontOfSize:12]
                                        andColor:[UIColor darkGrayColor]];
    [labelVersion setTextAlignment:UITextAlignmentCenter];
    [labelVersion setText:APP_VERSION];
    [self.view addSubview:labelVersion];
    
    // other
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((w - 220)/2, 180, 220, 70)];
    UILabel *labelPhoneK = [self generateLabel:CGRectMake(0, 0, 80, 35)
                                  withFontSize:[UIFont systemFontOfSize:14]
                                      andColor:[UIColor darkGrayColor]];
    [labelPhoneK setText:@"客服电话："];
    [view addSubview:labelPhoneK];
    
    UILabel *labelPhoneV = [self generateLabel:CGRectMake(70, 0, 150, 35)
                                  withFontSize:[UIFont systemFontOfSize:14]
                                      andColor:[UIColor blueColor]];
    [labelPhoneV setText:APP_PHONE];
    
    [labelPhoneV setUserInteractionEnabled:YES];
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dialPhone:)];
    [recognizer1 setNumberOfTapsRequired:1];
    [labelPhoneV addGestureRecognizer:recognizer1];
    [recognizer1 release];
    [view addSubview:labelPhoneV];
    
    UILabel *labelUrlK = [self generateLabel:CGRectMake(0, 35, 80, 35)
                                  withFontSize:[UIFont systemFontOfSize:14]
                                      andColor:[UIColor darkGrayColor]];
    [labelUrlK setText:@"官方网址："];
    [view addSubview:labelUrlK];
    
    UILabel *labelUrlV = [self generateLabel:CGRectMake(70, 35, 150, 35)
                                  withFontSize:[UIFont systemFontOfSize:14]
                                      andColor:[UIColor blueColor]];
    [labelUrlV setText:APP_URL];
    [labelUrlV setUserInteractionEnabled:YES];
    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openHomePage:)];
    [recognizer1 setNumberOfTapsRequired:1];
    [labelUrlV addGestureRecognizer:recognizer2];
    [recognizer2 release];
    [view addSubview:labelUrlV];
    
    [self.view addSubview:view];
    [view release];
    
    // buttons.
    UIButton *buttonModules = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonModules setFrame:CGRectMake((w - 230)/2, 280, 230, 40)];
    [buttonModules setTitle:@"功能介绍" forState:UIControlStateNormal];
    [buttonModules.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonModules addTarget:self action:@selector(showHelp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonModules];
    
    UIButton *buttonUpdates = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonUpdates setFrame:CGRectMake((w - 230)/2, 330, 230, 40)];
    [buttonUpdates setTitle:@"检查更新" forState:UIControlStateNormal];
    [buttonUpdates.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonUpdates addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonUpdates];
    
    // copyright
    UILabel *labelCP =  [self generateLabel:CGRectMake(0, 380, w, 40)
                                    withFontSize:[UIFont systemFontOfSize:10]
                                        andColor:[UIColor darkGrayColor]];
    [labelCP setTextAlignment:UITextAlignmentCenter];
    [labelCP setNumberOfLines:2];
    [labelCP setText:APP_COPYRIGHT];
    [self.view addSubview:labelCP];
    
}
-(void)showHelp
{
    HelpViewController *vc = [[HelpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}
- (void)dialPhone:(UITapGestureRecognizer *)recognizer
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", APP_PHONE]]];
}
- (void)openHomePage:(UITapGestureRecognizer *)recognizer
{
    CorpInfoViewController *vc = [[CorpInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (UILabel *)generateLabel: (CGRect)frame
              withFontSize: (UIFont *)font
                  andColor: (UIColor *)color
{
    UILabel *labelTime = [[[UILabel alloc] initWithFrame:frame] autorelease];
    [labelTime setFont:font];
    [labelTime setTextColor:color];
    [labelTime setBackgroundColor:[UIColor clearColor]];
    return labelTime;
}

- (void)updateVersion{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"检查更新...";
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:VERSION_CHECK]];
    [request setCompletionBlock:^{
        if([request responseStatusCode] == 404){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [ALToastView toastInView:self.view withText:@"已经是最新版本"];
        }else {
            id JSON = [[request responseString] objectFromJSONString];
            if(JSON != nil && (NSNull *)JSON != [NSNull null]){
                float v = [[JSON objectForKey:@"v"] floatValue];
                _url = [[NSString alloc] initWithString:[JSON objectForKey:@"l"]];
                if(v > APP_SHORTVERSION){
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                                        message:@"已有更新的版本，是否立即下载？" delegate:self
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:@"开始下载", nil];
                    
                    [alertView show];
                    [alertView release];
                }else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [ALToastView toastInView:self.view withText:@"已经是最新版本"];
                }
            }else{
                [ALToastView toastInView:self.view withText:@"无法检测版本" andBottomOffset:44 andType:ERROR];
            }
        }
    }];
    [request setFailedBlock:^{
        [ALToastView toastInView:self.view withText:@"检测版本失败" andBottomOffset:44 andType:ERROR];
    }];
    [request startAsynchronous];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", _url]]];
        [_url release];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
