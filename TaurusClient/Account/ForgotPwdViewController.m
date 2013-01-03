//
//  ForgotPwdViewController.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-23.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "ForgotPwdViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIBarButtonItem+Blocks.h"
#import "MBProgressHUD.h"
#import "BBlock.h"
#import "AppDefines.h"
#import "UserHelper.h"
#import "ALToastView.h"
#import "AppConfig.h"
#import "NSDateAdditions.h"
#import "NSDictionaryAdditions.h"

#define TAG_NAME    100
#define TAG_PHONE   101


@interface ForgotPwdViewController ()

@end

@implementation ForgotPwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [_tableView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"忘记密码";
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }];
    
    
    [self initComponent];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Components
#pragma mark initialization 
// init tableview.
- (void) initComponent{
    _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 10, SCREEN_RECT.size.width, SCREEN_RECT.size.height - NAVBAR_HEIGHT - STATUSBAR_FRAME.size.height) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundView:nil];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:NO];
    [self.view addSubview:_tableView];

    // tap gesture.
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [_tableView addGestureRecognizer:recognizer];
    [recognizer release];

    // send sms button
    UIButton *buttonSend = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSend setBackgroundImage:[UIImage imageNamed:@"fs_btn.png"] forState:UIControlStateNormal];
    [buttonSend setTitle:@"发送密码至手机" forState:UIControlStateNormal];
    CGFloat x = (SCREEN_RECT.size.width - 278)/2;
    [buttonSend setFrame:CGRectMake(x, NAVBAR_HEIGHT + 100, 278, 45)];
    [buttonSend addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSend];
    [self.view bringSubviewToFront:buttonSend];

    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, NAVBAR_HEIGHT + 70, SCREEN_RECT.size.width - 20, 24)];
	[infoLabel setFont:[UIFont systemFontOfSize:14.0f]];
	[infoLabel setTextColor:[UIColor redColor]];
    [infoLabel setTextAlignment:UITextAlignmentCenter];
	[infoLabel setBackgroundColor:[UIColor clearColor]];
	[infoLabel setNumberOfLines:0];
	[infoLabel setText:@"密码重置每天限用三次"];
	[self.view addSubview:infoLabel];
    [infoLabel release];
}
// TODO: Change this to the production version.
- (void)sendSMS
{
    UITextField *fieldLoginName = (UITextField *)[_tableView viewWithTag:TAG_NAME];
    if([[fieldLoginName text] length] == 0){
        [fieldLoginName becomeFirstResponder];
        return;
    }
    
    UITextField *fieldPhone = (UITextField *)[_tableView viewWithTag:TAG_PHONE];
    if([[fieldPhone text] length] == 0){
        [fieldPhone becomeFirstResponder];
        return;
    }
    
    [self singleTap:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中...";
    
    NSString *date = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    int c = 0;
    NSMutableDictionary *hash = [[AppConfig get].pwdRecoveryHash mutableCopy];
    if(hash == nil){
        hash = [[NSMutableDictionary alloc] initWithCapacity:0];
    }else{
        c = [hash getIntValueForKey:date defaultValue:0];
        
        if(c >= 3){
            [ALToastView toastInView:self.view withText:@"您已达到今日最大尝试次数。" andBottomOffset:44 andType:ERROR];
            [hash release];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
    }
    [hash setObject:[NSNumber numberWithInt:c + 1] forKey:date];
    [[AppConfig get] setPwdRecoveryHash:hash];
    [hash release];
    [[AppConfig get] saveState];
    
    [UserHelper pwdRecoveryWithLoginName:fieldLoginName.text
                                   phone:fieldPhone.text
                                 success:^{
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     [self.navigationController popViewControllerAnimated:YES];
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ACCOUNT_OPERATION"
                                                                                         object:nil
                                                                                       userInfo:[NSDictionary dictionaryWithObject:@"密码已经发送到您的手机。" forKey:@"MSG"]];
                                 }
                                 failure:^(NSString *errorMsg) {
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     [ALToastView toastInView:self.view withText:errorMsg andBottomOffset:44 andType:ERROR];
                                 }];
}
- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    [[_tableView viewWithTag:TAG_NAME] resignFirstResponder];
    [[_tableView viewWithTag:TAG_PHONE] resignFirstResponder];
}

#pragma mark -TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify]
                autorelease];
    }
    [cell setNeedsDisplay];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"登录名";
            UITextField *textFieldName = [[UITextField alloc] initWithFrame:CGRectMake(80, 14, 200, 30)];
            [textFieldName setFont:[UIFont systemFontOfSize:14]];
            [textFieldName setPlaceholder:@"请输入用户名/手机号"];
            [textFieldName setReturnKeyType:UIReturnKeyNext];
            [textFieldName setTag:TAG_NAME];
            //[textFieldName becomeFirstResponder];
            [textFieldName setDelegate:self];
            [cell addSubview:textFieldName];
            [textFieldName release];
        }
            break;
        case 1: {
            cell.textLabel.text = @"手机号";
            UITextField *textFieldPhone = [[UITextField alloc] initWithFrame:CGRectMake(80, 14, 200, 30)];
            [textFieldPhone setFont:[UIFont systemFontOfSize:14]];
            [textFieldPhone setPlaceholder:@"请输入接收短信的手机号"];
            [textFieldPhone setKeyboardType:UIKeyboardTypePhonePad];
            [textFieldPhone setReturnKeyType:UIReturnKeyNext];
            [textFieldPhone setTag:TAG_PHONE];
            [textFieldPhone setDelegate:self];
            [cell addSubview:textFieldPhone];
            [textFieldPhone release];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case TAG_NAME:
            [[_tableView viewWithTag:TAG_PHONE] becomeFirstResponder];
            break;
        default:
            break;
    }
    return true;
}

@end
