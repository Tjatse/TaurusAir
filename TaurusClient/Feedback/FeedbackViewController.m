//
//  FeedbackViewController.m
//  TaurusClient
//
//  Created by Simon on 13-1-2.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "NSStringAdditions.h"
#import "FSActionRequest.h"
#import "FSCommonJsonParser.h"
#import "UIApplicationAdditions.h"

@interface FeedbackViewController ()

@property (nonatomic, retain) UIButton*					submitButton;
@property (nonatomic, retain) IBOutlet UILabel*			hintLabel;
@property (nonatomic, retain) IBOutlet UITextView*		promptView;

- (void)submitFeedback;
- (void)onSubmitButtonTap:(UIButton*)sender;

@end

@implementation FeedbackViewController

- (void)dealloc
{
	self.hintLabel = nil;
	self.promptView = nil;
	
	self.submitButton = nil;
	
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
	
	self.navigationItem.rightBarButtonItem = [UIBarButtonItem generateNormalStyleButtonWithTitle:@"确定"
																				  andTapCallback:^(id control, UIEvent *event) {
																					  [self onSubmitButtonTap:nil];
																				  }];
	
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
																			   andTapCallback:^(id control, UIEvent *event) {
																				   [self dismissModalViewControllerAnimated:YES];
																			   }];
	self.submitButton.enabled = NO;
	
	[self.promptView becomeFirstResponder];
	
	// 文案
	self.hintLabel.text = @"欢迎提出您的宝贵意见，谢谢支持！";
	self.title = @"意见反馈";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSubmitButtonTap:(UIButton *)sender
{
	[self submitFeedback];
}

- (void)submitFeedback
{
	if (self.promptView.text.length <= 0)
		return;
	
	[self.promptView resignFirstResponder];
	
	NSString* prompt = [self.promptView.text URLEncodedString];
	NSString* param = [NSString stringWithFormat:@"feedbacks/addFeedback/%@", prompt];
	
	__block FSActionRequest* req;
	req = [[FSActionRequest alloc] initWithParams:param
									 withPostData:nil
									   parseClass:[FSCommonJsonParser class]
									   onComplete:^(FSActionParser *parse) {
										   MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:[UIApplication mainWindow]
																					 animated:YES];
										   hud.labelText = NSLocalizedString(@"FeedbackOK", nil);
										   hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notify_complete.png"]] autorelease];
										   hud.mode = MBProgressHUDModeCustomView;
										   [hud hide:YES afterDelay:2];
										   
										   [self.navigationController popViewControllerAnimated:YES];
									   }
										  onError:^(NSError *error) {
											  
										  }];
	
	[req execute];
	SAFE_RELEASE(req);
}

#pragma mark - textview delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (textView.text.length == 0) {
            return NO;
        }
		
        // 发送吐槽
        [self submitFeedback];
		
        return NO;
    }
    
	// 删除键
    if (text.length == 0) {
		
    }
	
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	self.hintLabel.hidden = textView.text.length != 0;
	self.submitButton.enabled = textView.text.length != 0;
}

@end
