//
//  MyInfoViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-12.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "MyInfoViewController.h"
#import "AppConfig.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UIBGNavigationController.h"
#import "UIBarButtonItem+Blocks.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "ALToastView.h"
#import "JSONKit.h"
#import "AppDefines.h"
#import "AppContext.h"
#import "ChangePwdViewController.h"
#import "EditMyInfoViewController.h"

@interface MyInfoViewController ()

@end

@implementation MyInfoViewController
@synthesize tableView = _tableView;

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
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self setTitle:@"我的商旅"];
    
    if(![[AppConfig get] isLogon]){
        [self showLoginViewController];
        self.navigationItem.rightBarButtonItem =
        [UIBarButtonItem generateNormalStyleButtonWithTitle:@"登录"
                                             andTapCallback:^(id control, UIEvent *event) {
                                                 [self showLoginViewController];
                                             }];
        [ALToastView toastPinInView:self.view withText:@"登录后才能访问“我的商旅”。" andBottomOffset: 120];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"LOGIN_SUC" object:nil];
    }else{
        [self initComponent];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGIN_SUC" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"INFO_OPERATION" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Login Required
- (void)loginSuccess
{
    [self initComponent];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGIN_SUC" object:nil];
}

- (void)showLoginViewController
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    UIBGNavigationController *nav = [[UIBGNavigationController alloc] initWithRootViewController: vc];
    [self.navigationController presentModalViewController:nav animated:YES];
    [vc release];
    [nav release];
}
#pragma mark -Login Already
- (void)initComponent
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoOperation:) name:@"INFO_OPERATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoRefresh:) name:@"REFRESH_MYINFO" object:nil];
    
    self.navigationItem.rightBarButtonItem = nil;
    NSArray *subViews = [self.view subviews];
    if(subViews && [subViews count] > 0){
        for(UIView *v in subViews){
            [v removeFromSuperview];
        }
    }
    // init tableview.
    _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_RECT.size.width, SCREEN_RECT.size.height - NAVBAR_HEIGHT - STATUSBAR_FRAME.size.height) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundView:nil];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:YES];
    [self.view addSubview:_tableView];
}
- (void)infoOperation:(NSNotification *)notification
{
    NSString *msg = [[notification userInfo] objectForKey:@"MSG"];
    [ALToastView toastInView:self.view withText:msg];
}
- (void)infoRefresh:(NSNotification *)notification
{
    [_tableView reloadData];
}


#pragma mark -TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 2){
        return 64;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 2){
        return 0;
    }else if(section == 0){
        return 4;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify]
                autorelease];
    }
    [cell setNeedsDisplay];
    if(indexPath.section == 0 && indexPath.row != 0){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if(indexPath.section == 0){
        User *user = [AppConfig get].currentUser;
        if(indexPath.row == 0){
            if(!user.gender){
                [cell.imageView setImage:[UIImage imageNamed:@"avatar-female.png"]];
            }else{
                [cell.imageView setImage:[UIImage imageNamed:@"avatar-male.png"]];
            }
            [cell.textLabel setText:user.name];
        }else if(indexPath.row == 1){
            [cell.textLabel setText:@"登录账号"];
            [cell.detailTextLabel setText:user.loginName && [user.loginName length] > 0 ? user.loginName : @"-"];
        }else if(indexPath.row == 2){
            [cell.textLabel setText:@"手机号码"];
            [cell.detailTextLabel setText:user.phone && [user.phone length] > 0 ? user.phone : @"-"];
        }else if(indexPath.row == 3){
            [cell.textLabel setText:@"邮件地址"];
            [cell.detailTextLabel setText:user.email && [user.email length] > 0 ? user.email : @"-"];
        }
    }else if(indexPath.section == 1){
        [cell.textLabel setText:@"修改密码"];
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 2){
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 64)] autorelease];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"fs_btn.png"] forState:UIControlStateNormal];
        [button setTitle:@"注销" forState:UIControlStateNormal];
        CGFloat x = (tableView.frame.size.width - 278)/2;
        [button setFrame:CGRectMake(x, 5, 278, 45)];
        [button addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        return view;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1 && indexPath.row == 0){
        ChangePwdViewController *vc = [[ChangePwdViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }else if(indexPath.section == 0 && indexPath.row == 0){
        EditMyInfoViewController *vc = [[EditMyInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}
- (void)logout:(UIButton *)button{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"注销后，部分功能将无法访问，确定继续吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:nil, nil];
    [actionSheet showFromTabBar:[AppContext get].navController.tabBar];
    [actionSheet release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [[AppConfig get] setCurrentUser:nil];
        [[AppConfig get] saveState];
        
        [__APP_NAVVC__ popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT" object:nil];
    }
}
@end
