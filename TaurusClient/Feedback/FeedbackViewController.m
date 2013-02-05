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
#import "UIViewAdditions.h"
#import "UIView+Hierarchy.h"
#import "AppDefines.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "UIApplicationAdditions.h"
#import "ALToastView.h"

@interface FeedbackViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) UIButton*					submitButton;
@property (nonatomic, retain) IBOutlet UITableViewCell*	phoneCell;
@property (nonatomic, retain) IBOutlet UITableViewCell*	emailCell;
@property (nonatomic, retain) IBOutlet UITableViewCell*	contentCell;
@property (nonatomic, retain) IBOutlet UILabel*			hintLabel;
@property (nonatomic, retain) IBOutlet UITextField*		phoneField;
@property (nonatomic, retain) IBOutlet UITextField*		emailField;
@property (nonatomic, retain) IBOutlet UITextView*		promptView;
@property (nonatomic, retain) IBOutlet UITableView*		tableView;

- (void)submitFeedback;
- (void)onSubmitButtonTap:(UIButton*)sender;

@end

@implementation FeedbackViewController

- (void)dealloc
{
	self.hintLabel = nil;
	self.promptView = nil;
	self.phoneField = nil;
	self.emailField = nil;
	self.phoneCell = nil;
	self.emailCell = nil;
	self.contentCell = nil;
	self.tableView = nil;
	
	self.submitButton = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
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
																				   [self.navigationController dismissModalViewControllerAnimated:YES];
																			   }];
	
	self.submitButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
	self.submitButton.enabled = NO;
	
	[self.phoneField becomeFirstResponder];
	
	// 文案
	self.hintLabel.text = @"欢迎提出您的宝贵意见，谢谢支持！";
	self.title = @"意见反馈";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)onSubmitButtonTap:(UIButton *)sender
{
	[self submitFeedback];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
	NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardBounds;
	[keyboardBoundsValue getValue:&keyboardBounds];
	UIEdgeInsets e = UIEdgeInsetsMake(0, 0, keyboardBounds.size.height, 0);
	[[self tableView] setScrollIndicatorInsets:e];
	[[self tableView] setContentInset:e];
}

- (void)submitFeedback
{
	if (self.promptView.text.length <= 0)
		return;
	
//	[self.promptView resignFirstResponder];
//	
//	NSString* prompt = [self.promptView.text URLEncodedString];
//	NSString* param = [NSString stringWithFormat:@"feedbacks/addFeedback/%@", prompt];
//	
//	__block FSActionRequest* req;
//	req = [[FSActionRequest alloc] initWithParams:param
//									 withPostData:nil
//									   parseClass:[FSCommonJsonParser class]
//									   onComplete:^(FSActionParser *parse) {
//										   MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:[UIApplication mainWindow]
//																					 animated:YES];
//										   hud.labelText = NSLocalizedString(@"FeedbackOK", nil);
//										   hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notify_complete.png"]] autorelease];
//										   hud.mode = MBProgressHUDModeCustomView;
//										   [hud hide:YES afterDelay:2];
//										   
//										   [self.navigationController popViewControllerAnimated:YES];
//									   }
//										  onError:^(NSError *error) {
//											  
//										  }];
//	
//	[req execute];
//	SAFE_RELEASE(req);
	
	[self.phoneField resignFirstResponder];
	[self.emailField resignFirstResponder];
	[self.promptView resignFirstResponder];
	
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = @"正在发送反馈...";
	
	NSString *url = [NSString stringWithFormat:@"%@/%@", REACHABLE_HOST, kFeedbackURL];
	__block ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
	
//	Phone		手机
//	Email		邮箱
//	Content	Y	内容
	[request setPostValue:self.phoneField.text forKey:@"Phone"];
	[request setPostValue:self.emailField.text forKey:@"Email"];
	[request setPostValue:self.promptView.text forKey:@"Content"];
	
	setRequestAuth(request);
	
	[request setCompletionBlock:^{
		[MBProgressHUD hideHUDForView:self.view
							 animated:YES];
		
		id jsonObj = [[request responseString] mutableObjectFromJSONString];
		NSString* msg = [jsonObj getStringValueForKeyPath:@"Meta.Message" defaultValue:@"提交反馈信息成功。"];
		
		
		
		[ALToastView toastInView:[UIApplication mainWindow]
						withText:msg
				 andBottomOffset:84 andType:INFOMATION];
		
		[self dismissModalViewControllerAnimated:YES];
	}];
	
	[request setFailedBlock:^{
		[MBProgressHUD hideHUDForView:self.view
							 animated:YES];
	}];
	
	[request startAsynchronous];
}

#pragma mark - textfield delagate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.phoneField) {
		if ([self.emailField becomeFirstResponder]) {
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom
										  animated:YES];
		}
	} else if (textField == self.emailField) {
		if ([self.promptView becomeFirstResponder]) {
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionBottom
										  animated:YES];
		}
	}
	
	return YES;
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

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
		return self.phoneCell.height;
	else if (indexPath.section == 1)
		return self.emailCell.height;
	else
		return self.contentCell.height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return @"手机(可选)";
	else if (section == 1)
		return @"邮箱(可选)";
	else
		return @"内容(必填)";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	if (indexPath.section == 0)
		[self.phoneField becomeFirstResponder];
	else if (indexPath.section == 1)
		[self.emailField becomeFirstResponder];
	else
		[self.promptView becomeFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
		return self.phoneCell;
	else if (indexPath.section == 1)
		return self.emailCell;
	else
		return self.contentCell;
}

@end
