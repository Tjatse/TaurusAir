//
//  EditMyInfoViewController.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-31.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "EditMyInfoViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIBarButtonItem+Blocks.h"
#import "BBlock.h"
#import "MBProgressHUD.h"
#import "AppConfig.h"
#import "ALToastView.h"
#import "UserHelper.h"

@interface EditMyInfoViewController ()

@end

@implementation EditMyInfoViewController

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
    [_datas release];
    [_tableView release];
    [_user release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _datas = [[NSMutableArray arrayWithObjects:@"编        号",@"登  录  名",@"显  示  名",@"手  机  号",@"邮件地址",@"性        别",@"生        日",@"说        明", nil] retain];
    _user = [[AppConfig get].currentUser retain];
    [self setTitle:@"编辑个人信息"];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }];
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem generateNormalStyleButtonWithTitle:@"保存"
                                         andTapCallback:^(id control, UIEvent *event) {
                                             [self saveInfo];
                                         }];
    [_tableView setBackgroundView:nil];
    [_tableView setBackgroundColor:[UIColor clearColor]];
}
- (void)saveInfo
{
    // TODO: save traveler here.
    if(_focusedTextField && [_focusedTextField canResignFirstResponder]){
        [_focusedTextField resignFirstResponder];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"保存中...";
    
    if([_user.name length] == 0){
        _user.name = _user.loginName;
    }
    [UserHelper editUserInfo:_user
                     success:^{
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                         [[AppConfig get] setCurrentUser:_user];
                         [_user release];
                         [[AppConfig get] saveState];
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_MYINFO" object:nil userInfo:nil];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"INFO_OPERATION" object:nil userInfo:[NSDictionary dictionaryWithObject:@"修改个人信息成功。" forKey:@"MSG"]];
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                     failure:^(NSString *errorMsg) {
                         [ALToastView toastInView:self.view withText:errorMsg andBottomOffset:44 andType:ERROR];
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                     }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super viewWillDisappear:animated];
}
- (void)keyboardHide:(NSNotification *)notifictaion{
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
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
    if(section == 0){
        return [_datas count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
        if ((indexPath.row >= 2 && indexPath.row <= 4) || indexPath.row == 7) {
            StringInputTableViewCell *inputCell = [[[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
            inputCell.delegate = self;
            cell = inputCell;
        } else if(indexPath.row == 5){
            cell = [[[GenderPickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
        } else if(indexPath.row == 6){
            DateInputTableViewCell *dateCell = [[[DateInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
            dateCell.delegate = self;
            cell = dateCell;
        } else{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
        }
    }
    [cell setNeedsDisplay];
    [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.textLabel setText:_datas[indexPath.row]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    
    switch (indexPath.row) {
        case 0:{
            [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
            [cell.detailTextLabel setTextColor:[UIColor grayColor]];
            [cell.detailTextLabel setText:_user.userId];
        }
            break;
        case 1:{
            [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
            [cell.detailTextLabel setTextColor:[UIColor grayColor]];
            [cell.detailTextLabel setText:_user.loginName];
        }
            break;
        case 2:{
            [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
            StringInputTableViewCell *inputCell = (StringInputTableViewCell *)cell;
            [inputCell.textField setPlaceholder:@"您的姓名"];
            [inputCell setStringValue:_user.name];
        }
            break;
        case 3:{
            [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
            StringInputTableViewCell *inputCell = (StringInputTableViewCell *)cell;
            [inputCell.textField setKeyboardType:UIKeyboardTypePhonePad];
            [inputCell.textField setPlaceholder:@"手机号码"];
            [inputCell setStringValue:_user.phone];
        }
            break;
        case 4:{
            [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
            StringInputTableViewCell *inputCell = (StringInputTableViewCell *)cell;
            [inputCell.textField setKeyboardType:UIKeyboardTypeEmailAddress];
            [inputCell.textField setPlaceholder:@"Email地址"];
            [inputCell setStringValue:_user.email];
        }
            break;
        case 5:{
            NSString *str = _user.gender ? @"男":@"女";
            GenderPickerInputTableViewCell *pickerCell = (GenderPickerInputTableViewCell *)cell;
            pickerCell.delegate = self;
            [pickerCell setValue:str];
        }
            break;
        case 6:{
            DateInputTableViewCell *dateCell = (DateInputTableViewCell *)cell;
            
            NSDate *date = nil;
            if((NSNull *)_user.birthday == [NSNull null] || _user.birthday == nil || [_user.birthday length] == 0){
                date = [NSDate date];
            }else{
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"yyyy-MM-dd"];
                [dateCell setMaxDate:[NSDate date]];
                [dateCell setMinDate:[formatter dateFromString:@"1900-1-1"]];
                
                date = [formatter dateFromString:_user.birthday];
                [formatter release];
            }
            
            [dateCell setDateValue:date];
        }
            break;
        case 7:{
            [cell.detailTextLabel setNumberOfLines:0];
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
            [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
            StringInputTableViewCell *inputCell = (StringInputTableViewCell *)cell;
            [inputCell.textField setPlaceholder:@"个人说明"];
            [inputCell setStringValue:_user.remark];
        }
            break;
        default:
            break;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 5){
        [_tableView setContentOffset:CGPointMake(0, 198) animated:YES];
    }else if(indexPath.row == 6){
        [_tableView setContentOffset:CGPointMake(0, 230) animated:YES];
    }
}
- (void)tableViewCell:(StringInputTableViewCell *)cell didBeginEditingWithString:(NSString *)value
{
    _focusedTextField = cell.textField;
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if(indexPath.row == 2){
        [_tableView setContentOffset:CGPointMake(0, 44) animated:YES];
    }else if(indexPath.row == 3){
        [_tableView setContentOffset:CGPointMake(0, 110) animated:YES];
    }else if(indexPath.row == 4){
        [_tableView setContentOffset:CGPointMake(0, 132) animated:YES];
    }else if(indexPath.row == 7){
        [_tableView setContentOffset:CGPointMake(0, 252) animated:YES];
    }
}
- (void)tableViewCell:(DateInputTableViewCell *)cell didEndEditingWithDate:(NSDate *)value
{
    [cell setDateValue:value];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [formatter stringFromDate:value];
    _user.birthday = date;
    [formatter release];
}
- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)value
{
    int row = [_tableView indexPathForCell:cell].row;
    if(row == 2){
        _user.name = value;
    }else if(row == 3){
        _user.phone = value;
    }else if(row == 4){
        _user.email = value;
    }else if(row == 7){
        _user.remark = value;
    }
}
- (void)tableViewCell:(PickerInputTableViewCell *)cell didEndEditingWithValue:(NSString *)value
{
    int row = [_tableView indexPathForCell:cell].row;
    
    if(row == 5){
        BOOL gender = NO; // female
        if([value isEqualToString:@"男"]){
            gender = YES; // male
        }
        _user.gender = gender;
    }
}
@end
