//
//  ChangePwdViewController.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-31.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIBarButtonItem+Blocks.h"
#import "MBProgressHUD.h"
#import "BBlock.h"
#import "AppDefines.h"
#import "ALToastView.h"
#import "AppConfig.h"
#import "UserHelper.h"

#define TAG_OLD_PWD     100
#define TAG_NEW_PWD     101
#define TAG_CFM_PWD     102

@interface ChangePwdViewController ()

@end

@implementation ChangePwdViewController

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
    [self setTitle:@"修改密码"];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }];
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem generateNormalStyleButtonWithTitle:@"修改"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self updatePwd];
                                       }];
    
    [self initComponent];

}

#pragma mark - Components
#pragma mark initialization
// init tableview.
- (void) initComponent{
    
    [_tableView setBackgroundView:nil];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    // tap gesture.
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [_tableView addGestureRecognizer:recognizer];
    [recognizer release];
    
}
// TODO: Change this to the production version.
- (void)updatePwd;
{
    UITextField *fieldOldPwd = (UITextField *)[_tableView viewWithTag:TAG_OLD_PWD];
    if([[fieldOldPwd text] length] == 0){
        [fieldOldPwd becomeFirstResponder];
        return;
    }
    
    UITextField *fieldNewPwd = (UITextField *)[_tableView viewWithTag:TAG_NEW_PWD];
    if([[fieldNewPwd text] length] == 0){
        [fieldNewPwd becomeFirstResponder];
        return;
    }
    
    UITextField *fieldCfmPwd = (UITextField *)[_tableView viewWithTag:TAG_CFM_PWD];
    if([[fieldCfmPwd text] length] == 0){
        [fieldCfmPwd becomeFirstResponder];
        return;
    }
    if(![[fieldCfmPwd text] isEqualToString:[fieldNewPwd text]]){
        [ALToastView toastInView:self.view withText:@"“新密码”和“确认密码”不一致。" andBottomOffset:SCREEN_RECT.size.height/2 andType:ERROR];
        return;
    }
    
    [self singleTap:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中...";
    
    [UserHelper pwdEditWithId:[AppConfig get].currentUser.userId
                  oldPassword:fieldOldPwd.text
                  newPassword:fieldNewPwd.text
                      success:^{
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          [self.navigationController popViewControllerAnimated:YES];
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"INFO_OPERATION"
                                                                              object:nil
                                                                            userInfo:[NSDictionary dictionaryWithObject:@"密码已成功修改。" forKey:@"MSG"]];
                      }
                      failure:^(NSString *errorMsg) {
                          [ALToastView toastInView:self.view withText:errorMsg andBottomOffset:44 andType:ERROR];
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                      }];
}
- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    [[_tableView viewWithTag:TAG_NEW_PWD] resignFirstResponder];
    [[_tableView viewWithTag:TAG_OLD_PWD] resignFirstResponder];
    [[_tableView viewWithTag:TAG_CFM_PWD] resignFirstResponder];
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
            cell.textLabel.text = @"旧  密  码";
            UITextField *textOldPwd = [[UITextField alloc] initWithFrame:CGRectMake(90, 14, 200, 30)];
            [textOldPwd setSecureTextEntry:YES];
            [textOldPwd setFont:[UIFont systemFontOfSize:14]];
            [textOldPwd setPlaceholder:@"请输入当前密码"];
            [textOldPwd setReturnKeyType:UIReturnKeyNext];
            [textOldPwd setTag:TAG_OLD_PWD];
            [textOldPwd setDelegate:self];
            [cell addSubview:textOldPwd];
            [textOldPwd release];
        }
            break;
        case 1: {
            cell.textLabel.text = @"新  密  码";
            UITextField *textNewPwd = [[UITextField alloc] initWithFrame:CGRectMake(90, 14, 200, 30)];
            [textNewPwd setSecureTextEntry:YES];
            [textNewPwd setFont:[UIFont systemFontOfSize:14]];
            [textNewPwd setPlaceholder:@"请输入您的新密码"];
            [textNewPwd setReturnKeyType:UIReturnKeyNext];
            [textNewPwd setTag:TAG_NEW_PWD];
            [textNewPwd setDelegate:self];
            [cell addSubview:textNewPwd];
            [textNewPwd release];
        }
            break;
        case 2: {
            cell.textLabel.text = @"确认密码";
            UITextField *textCfmPwd = [[UITextField alloc] initWithFrame:CGRectMake(90, 14, 200, 30)];
            [textCfmPwd setSecureTextEntry:YES];
            [textCfmPwd setFont:[UIFont systemFontOfSize:14]];
            [textCfmPwd setPlaceholder:@"请确认您的新密码"];
            [textCfmPwd setReturnKeyType:UIReturnKeyNext];
            [textCfmPwd setTag:TAG_CFM_PWD];
            [textCfmPwd setDelegate:self];
            [cell addSubview:textCfmPwd];
            [textCfmPwd release];
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
        case TAG_OLD_PWD:
            [[_tableView viewWithTag:TAG_NEW_PWD] becomeFirstResponder];
            break;
        case TAG_NEW_PWD:
            [[_tableView viewWithTag:TAG_CFM_PWD] becomeFirstResponder];
            break;
        default:
            break;
    }
    return true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
	_tableView = nil;
    [super dealloc];
}

@end
