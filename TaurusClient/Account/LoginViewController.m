//
//  LoginViewController.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-14.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "LoginViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIBarButtonItem+Blocks.h"
#import "AppDefines.h"

#define TAG_NAME    100
#define TAG_PWD     101
#define TAG_RMB     102
#define TAG_TBV     103
#define TAG_REG     104
#define TAG_FPWD    105

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    self.title = @"登录/注册";
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController dismissModalViewControllerAnimated:YES];
                                       }];
    
    
    [self initComponent];
}

- (void)initComponent
{
    // init tableview.
    _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 10, SCREEN_RECT.size.width, SCREEN_RECT.size.height - NAVBAR_HEIGHT - STATUSBAR_FRAME.size.height) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundView:nil];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:NO];
    [_tableView setTag: TAG_TBV];
    [self.view addSubview:_tableView];
    
    // tap gesture.
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [_tableView addGestureRecognizer:recognizer];
    [recognizer release];
    
    // login button
    UIButton *buttonLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLogin setBackgroundImage:[UIImage imageNamed:@"fs_btn.png"] forState:UIControlStateNormal];
    [buttonLogin setTitle:@"登 录" forState:UIControlStateNormal];
    CGFloat x = (SCREEN_RECT.size.width - 278)/2;
    [buttonLogin setFrame:CGRectMake(x, NAVBAR_HEIGHT + 130, 278, 45)];
    [buttonLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonLogin];
    [self.view bringSubviewToFront:buttonLogin];
    
    UILabel *labelRegister = [[UILabel alloc] initWithFrame:CGRectMake(x, NAVBAR_HEIGHT + 190, 100, 24)];
    [labelRegister setFont:[UIFont systemFontOfSize:14]];
    [labelRegister setTextColor:[UIColor blueColor]];
    [labelRegister setText:@"免费注册>>"];
    [labelRegister setBackgroundColor:[UIColor clearColor]];
    
    // tap gesture.
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [labelRegister addGestureRecognizer:recognizer1];
    [recognizer1 release];
    [labelRegister setUserInteractionEnabled:YES];
    
    [labelRegister setTag:TAG_REG];
    [self.view addSubview:labelRegister];
    [labelRegister release];
    
    
    UILabel *labelForgotPwd = [[UILabel alloc] initWithFrame:CGRectMake(x + 278 - 100, NAVBAR_HEIGHT + 190, 100, 24)];
    [labelForgotPwd setFont:[UIFont systemFontOfSize:14]];
    [labelForgotPwd setTextColor:[UIColor blueColor]];
    [labelForgotPwd setText:@"忘记密码"];
    [labelForgotPwd setTextAlignment:UITextAlignmentRight];
    [labelForgotPwd setBackgroundColor:[UIColor clearColor]];
    
    // tap gesture.
    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [labelForgotPwd addGestureRecognizer:recognizer2];
    [recognizer2 release];
    [labelForgotPwd setUserInteractionEnabled:YES];
    
    [labelForgotPwd setTag:TAG_FPWD];
    [self.view addSubview:labelForgotPwd];
    [labelForgotPwd release];
    
}
- (void)login
{
    
}
- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    switch (recognizer.view.tag) {
        case TAG_TBV:{
            [[_tableView viewWithTag:TAG_NAME] resignFirstResponder];
            [[_tableView viewWithTag:TAG_PWD] resignFirstResponder];
        }
            break;
        case TAG_REG:
            NSLog(@"register.");
            break;
        case TAG_FPWD:
            NSLog(@"forgot password.");
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
            cell.textLabel.text = @"用户名";
            UITextField *textFieldName = [[UITextField alloc] initWithFrame:CGRectMake(80, 14, 200, 30)];
            [textFieldName setFont:[UIFont systemFontOfSize:14]];
            [textFieldName setPlaceholder:@"请输入用户名"];
            [textFieldName setReturnKeyType:UIReturnKeyNext];
            [textFieldName setTag:TAG_NAME];
            [textFieldName becomeFirstResponder];
            [textFieldName setDelegate:self];
            [cell addSubview:textFieldName];
            [textFieldName release];
            }
            break;
        case 1: {
            cell.textLabel.text = @"密  码";
            UITextField *textFieldPwd = [[UITextField alloc] initWithFrame:CGRectMake(80, 14, 200, 30)];
            [textFieldPwd setFont:[UIFont systemFontOfSize:14]];
            [textFieldPwd setSecureTextEntry:YES];
            [textFieldPwd setPlaceholder:@"请输入密码"];
            [textFieldPwd setReturnKeyType:UIReturnKeyNext];
            [textFieldPwd setTag:TAG_PWD];
            [textFieldPwd setDelegate:self];
            [cell addSubview:textFieldPwd];
            [textFieldPwd release];
        }
            break;
        case 2: {
            cell.textLabel.text = @"自动登录";
            UISwitch *switchRememberMe = [[UISwitch alloc] init];
            [switchRememberMe addTarget:self action:@selector(onSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            [switchRememberMe setOn:YES];
            switchRememberMe.tag = TAG_RMB;
            cell.accessoryView = switchRememberMe;
            [switchRememberMe release];
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma Switch event
- (void)onSwitchChanged: (UISwitch *)sender
{
    _rememberMe = sender.on;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case TAG_NAME:
            [[_tableView viewWithTag:TAG_PWD] becomeFirstResponder];
            break;
        case TAG_PWD:
            [textField resignFirstResponder];
            break;
        default:
            break;
    }
    return true;
}

@end
