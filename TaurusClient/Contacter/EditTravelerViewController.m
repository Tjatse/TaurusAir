//
//  EditTravelerViewController.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-27.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "EditTravelerViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIBarButtonItem+Blocks.h"
#import "BBlock.h"
#import "MBProgressHUD.h"
#import "AppContext.h"
#import "ContacterHelper.h"
#import "ALToastView.h"

@interface EditTravelerViewController ()

@end

@implementation EditTravelerViewController
@synthesize detail = _detail;
@synthesize tableView = _tableView;
@synthesize contacterType = _contacterType;

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
    [_detail release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(_contacterType == CONTACTER){
        _datas = [[NSArray alloc] initWithArray: @[@"编       号", @"姓       名", @"手机号码", @"邮件地址", @"通信地址"]];
    }else{
        _datas = [[NSArray alloc] initWithArray: @[@"编       号", @"姓       名", @"性       别", @"身份证号", @"手机号码", @"生       日", @"类       型"]];
    }
        
    [self setTitle:@"编辑信息"];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }];
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem generateNormalStyleButtonWithTitle:@"保存"
                                         andTapCallback:^(id control, UIEvent *event) {
                                             [self save];
                                         }];
    [_tableView setBackgroundView:nil];
    [_tableView setBackgroundColor:[UIColor clearColor]];
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
#pragma mark - Save
- (void)save
{
    if(_focusedTextField && [_focusedTextField canResignFirstResponder]){
        [_focusedTextField resignFirstResponder];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"保存中...";
    hud.dimBackground = YES;
    if(_contacterType == CONTACTER){
        [ContacterHelper contacterOperateWithData:_detail
                                      operateType:kModify
                                          success:^(NSString *identification) {
                                              [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_CONTACTER" object:nil userInfo:[NSDictionary dictionaryWithObject:_detail forKey:@"CONTACTER"]];
                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                          }
                                          failure:^(NSString *errorMsg) {
                                              [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                              [ALToastView toastInView:self.view withText:errorMsg andBottomOffset:44 andType:ERROR];
                                          }];
    }else{
        
        [ContacterHelper passengerOperateWithData:_detail
                                      operateType:kModify
                                          success:^(NSString *identification) {
                                              [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_TRAVELER" object:nil userInfo:[NSDictionary dictionaryWithObject:_detail forKey:@"TRAVELER"]];
                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                          }
                                          failure:^(NSString *errorMsg) {
                                              [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                              [ALToastView toastInView:self.view withText:errorMsg andBottomOffset:44 andType:ERROR];
                                          }];
    }
}

#pragma mark -TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        return 64;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(_contacterType == CONTACTER){
            if(indexPath.row == 5){
                return 56;
            }
        }else{
            if(indexPath.row == 7){
                return 56;
            }
        }
    }
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
        if(_contacterType == CONTACTER){
            if (indexPath.row != 0) {
                StringInputTableViewCell *inputCell = [[[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
                inputCell.delegate = self;
                cell = inputCell;
            } else{
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
            }
        }else{
            if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 4) {
                StringInputTableViewCell *inputCell = [[[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
                inputCell.delegate = self;
                cell = inputCell;
            } else if(indexPath.row == 2){
                cell = [[[GenderPickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
            } else if(indexPath.row == 5){
                DateInputTableViewCell *dateCell = [[[DateInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
                dateCell.delegate = self;
                cell = dateCell;
            } else if(indexPath.row == 6){
                cell = [[[TravelerTypePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
            } else{
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
            }
        }
    }
    [cell setNeedsDisplay];
    [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
    
    if((indexPath.row != 7 && _contacterType == TRAVELER) || (_contacterType == CONTACTER && indexPath.row != 5)){
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setText:_datas[indexPath.row]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    }
    
    if(_contacterType == CONTACTER){
        switch (indexPath.row) {
            case 0:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                [cell.detailTextLabel setText:[[_detail objectForKey:@"ContactorId"] stringValue]];
            }
                break;
            case 1:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                [(StringInputTableViewCell *)cell setStringValue:[_detail objectForKey:@"Name"]];
            }
                break;
            case 2:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                StringInputTableViewCell *inputCell = (StringInputTableViewCell *)cell;
                [inputCell.textField setKeyboardType:UIKeyboardTypePhonePad];
                [inputCell setStringValue:[_detail objectForKey:@"Phone"]];
            }
                break;
            case 3:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                StringInputTableViewCell *inputCell = (StringInputTableViewCell *)cell;
                [inputCell.textField setKeyboardType:UIKeyboardTypeEmailAddress];
                NSString *email = [_detail objectForKey:@"Email"];
                [inputCell setStringValue:(NSNull *)email == [NSNull null] ? @"":email];
            }
                break;
            case 4:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                NSString *address = [_detail objectForKey:@"Address"];
                [(StringInputTableViewCell *)cell setStringValue:(NSNull *)address == [NSNull null] ? @"":address];
            }
                break;
            case 5:{
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundImage:[UIImage imageNamed:@"fs_btn.png"] forState:UIControlStateNormal];
                [button setTitle:@"删  除" forState:UIControlStateNormal];
                CGFloat x = (cell.frame.size.width - 278)/2;
                [button setFrame:CGRectMake(x, 5, 278, 45)];
                [button addTarget:self action:@selector(delTraveler) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:button];
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                [cell.detailTextLabel setText:[[_detail objectForKey:@"PassengerId"] stringValue]];
            }
                break;
            case 1:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                [(StringInputTableViewCell *)cell setStringValue:[_detail objectForKey:@"Name"]];
            }
                break;
            case 2:{
                BOOL gender = [[_detail objectForKey:@"Gender"] boolValue];
                NSString *str = gender ? @"男":@"女";
                GenderPickerInputTableViewCell *pickerCell = (GenderPickerInputTableViewCell *)cell;
                pickerCell.delegate = self;
                [pickerCell setValue:str];
            }
                break;
            case 3:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                StringInputTableViewCell *inputCell = (StringInputTableViewCell *)cell;
                [inputCell setStringValue:[_detail objectForKey:@"ChinaId"]];
                [inputCell.textField setKeyboardType:UIKeyboardTypeNumberPad];
            }
                break;
            case 4:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                StringInputTableViewCell *inputCell = (StringInputTableViewCell *)cell;
                [inputCell.textField setKeyboardType:UIKeyboardTypePhonePad];
                NSString *phone = [_detail objectForKey:@"Phone"];
                [inputCell setStringValue: (NSNull *)phone != [NSNull null]?phone:@""];
            }
                break;
            case 5:{
                DateInputTableViewCell *dateCell = (DateInputTableViewCell *)cell;
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"yyyy-MM-dd"];
                [dateCell setMaxDate:[NSDate date]];
                [dateCell setMinDate:[formatter dateFromString:@"1900-1-1"]];
                
                NSString *birthday = [_detail objectForKey:@"Birthday"];
                if((NSNull *)birthday == [NSNull null]){
                    birthday = @"1900-1-1";
                }
                NSDate *date=[formatter dateFromString:[birthday componentsSeparatedByString:@" "][0]];
                [formatter release];
                [dateCell setDateValue:date];
            }
                break;
            case 6:{
                NSString *type = @"成人";
                switch ([[_detail objectForKey:@"TravelerType"] intValue]) {
                    case 1:
                        type = @"成人";
                        break;
                    case 2:
                        type = @"儿童";
                        break;
                    default:
                        break;
                }
                TravelerTypePickerTableViewCell *pickerCell = (TravelerTypePickerTableViewCell *)cell;
                pickerCell.delegate = self;
                [pickerCell setValue:type];
            }
                break;
            default:
                break;
        }
    }
    return cell;
}
// TODO: Delete traveler here.
- (void)delTraveler
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"信息删除后将不可恢复，确定继续吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    [actionSheet showFromTabBar:[AppContext get].navController.tabBar];
    [actionSheet release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText = @"删除中...";
        hud.dimBackground = YES;
        if(_contacterType == CONTACTER){
            [ContacterHelper contacterOperateWithData:_detail
                                          operateType:kDelete
                                              success:^(NSString *identification) {
                                                  [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"DELETE_CONTACTER" object:nil userInfo:[NSDictionary dictionaryWithObject:[_detail objectForKey:@"ContactorId"] forKey:@"ContactorId"]];
                                                  [self.navigationController popToRootViewControllerAnimated:YES];
                                              }
                                              failure:^(NSString *errorMsg) {
                                                  [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                                  [ALToastView toastInView:self.view withText:errorMsg andBottomOffset:44 andType:ERROR];
                                              }];
        }else{
            
            [ContacterHelper passengerOperateWithData:_detail
                                          operateType:kDelete
                                              success:^(NSString *identification) {
                                                  [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"DELETE_TRAVELER" object:nil userInfo:[NSDictionary dictionaryWithObject:[_detail objectForKey:@"PassengerId"] forKey:@"PassengerId"]];
                                                  [self.navigationController popToRootViewControllerAnimated:YES];
                                              }
                                              failure:^(NSString *errorMsg) {
                                                  [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                                  [ALToastView toastInView:self.view withText:errorMsg andBottomOffset:44 andType:ERROR];
                                              }];
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 64)] autorelease];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"fs_btn.png"] forState:UIControlStateNormal];
        [button setTitle:@"删除" forState:UIControlStateNormal];
        CGFloat x = (tableView.frame.size.width - 278)/2;
        [button setFrame:CGRectMake(x, 5, 278, 45)];
        [button addTarget:self action:@selector(delTraveler) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        return view;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_contacterType == TRAVELER){
        if(indexPath.row == 2){
            [_tableView setContentOffset:CGPointMake(0, 88) animated:YES];
        }else if(indexPath.row == 5){
            [_tableView setContentOffset:CGPointMake(0, 176) animated:YES];
        }else if(indexPath.row == 6){
            [_tableView setContentOffset:CGPointMake(0, 198) animated:YES];
        }
    }
}
- (void)tableViewCell:(StringInputTableViewCell *)cell didBeginEditingWithString:(NSString *)value
{
    _focusedTextField = cell.textField;
    if(_contacterType == TRAVELER){
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        if(indexPath.row == 1){
            [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if(indexPath.row == 3){
            [_tableView setContentOffset:CGPointMake(0, 110) animated:YES];
        }else if(indexPath.row == 4){
            [_tableView setContentOffset:CGPointMake(0, 132) animated:YES];
        }
    }else if(_contacterType == CONTACTER){
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        if(indexPath.row == 1 || indexPath.row == 2){
            [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if(indexPath.row == 3){
            [_tableView setContentOffset:CGPointMake(0, 44) animated:YES];
        }else if(indexPath.row == 4){
            [_tableView setContentOffset:CGPointMake(0, 88) animated:YES];
        }
    }
}
- (void)tableViewCell:(DateInputTableViewCell *)cell didEndEditingWithDate:(NSDate *)value
{
    [cell setDateValue:value];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [formatter stringFromDate:value];
    [_detail setValue:date forKey:@"Birthday"];
    [formatter release];
}
- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)value
{
    int row = [_tableView indexPathForCell:cell].row;
    if(_contacterType == CONTACTER){
        if(row == 1){
            [_detail setValue:value forKey:@"Name"];
        }else if(row == 2){
            [_detail setValue:value forKey:@"Phone"];
        }else if(row == 3){
            [_detail setValue:value forKey:@"Email"];
        }else if(row == 4){
            [_detail setValue:value forKey:@"Address"];
        }
    }else{
        if(row == 1){
            [_detail setValue:value forKey:@"Name"];
        }else if(row == 3){
            [_detail setValue:value forKey:@"ChinaId"];
        }else if(row == 4){
            [_detail setValue:value forKey:@"Phone"];
        }
    }
}
- (void)tableViewCell:(PickerInputTableViewCell *)cell didEndEditingWithValue:(NSString *)value
{
    int row = [_tableView indexPathForCell:cell].row;
    if(_contacterType == TRAVELER){
        if(row == 2){
            NSString *gender = @"0"; // female
            if([value isEqualToString:@"男"]){
                gender = @"1"; // male
            }
            [_detail setValue:gender forKey:@"Gender"];
        }else if(row == 6){
            NSString *type = @"0";
            if([value isEqualToString:@"成人"]){
                type = @"1";
            }else if([value isEqualToString:@"儿童"]){
                type = @"2";
            }
            [_detail setValue:type forKey:@"TravelerType"];
        }
    }
}
@end
