//
//  CreateTravelerViewController.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "CreateTravelerViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIBarButtonItem+Blocks.h"
#import "BBlock.h"
#import "MBProgressHUD.h"

@interface CreateTravelerViewController ()

@end

@implementation CreateTravelerViewController
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
        _datas = [[NSArray alloc] initWithArray: @[@"姓       名", @"手机号码", @"邮件地址", @"通信地址"]];
    }else{
        _datas = [[NSArray alloc] initWithArray: @[@"姓       名", @"性       别", @"身份证号", @"手机号码", @"生       日", @"类       型"]];
    }
    
    _detail = [[NSMutableDictionary alloc] initWithCapacity:0];
    [_detail setObject:[NSNumber numberWithInt:1] forKey:@"Gender"];
    if(_contacterType == TRAVELER){
        [_detail setObject:[NSNumber numberWithInt:1] forKey:@"TravelerType"];
        [_detail setObject:@"1900-1-1" forKey:@"Birthday"];
        
        [self setTitle:@"添加常旅客"];
    }else{
        [self setTitle:@"添加联系人"];
    }
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }];
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem generateNormalStyleButtonWithTitle:@"创建"
                                         andTapCallback:^(id control, UIEvent *event) {
                                             // TODO: save traveler here.
                                             if(_focusedTextField && [_focusedTextField canResignFirstResponder]){
                                                 [_focusedTextField resignFirstResponder];
                                             }
                                             NSString *name = [_detail objectForKey:@"Name"];
                                             
                                             if(_contacterType == CONTACTER){
                                                 if((NSNull *)name == [NSNull null] || [name length] == 0){
                                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"“姓名”必须填写。" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                                                     [alert show];
                                                     [alert release];
                                                     return;
                                                 }
                                             }else{
                                                 NSString *chinaId = [_detail objectForKey:@"ChinaId"];
                                                 if((NSNull *)name == [NSNull null] || [name length] == 0 ||
                                                    (NSNull *)chinaId == [NSNull null] || [chinaId length] == 0){
                                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"“姓名”和“身份证号”必须填写。" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                                                     [alert show];
                                                     [alert release];
                                                     return;
                                                 }
                                             }
                                             
                                             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                             hud.labelText = @"保存中...";
                                             [BBlock dispatchAfter:1 onMainThread:^{
                                                 [hud hide:YES];
                                                 if(_contacterType == CONTACTER){
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_CONTACTER" object:nil userInfo:[NSDictionary dictionaryWithObject:_detail forKey:@"CONTACTER"]];
                                                 }else{
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_TRAVELER" object:nil userInfo:[NSDictionary dictionaryWithObject:_detail forKey:@"TRAVELER"]];
                                                 }
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }];
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


#pragma mark -TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
        if(_contacterType == CONTACTER){
            StringInputTableViewCell *inputCell = [[[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
            inputCell.delegate = self;
            cell = inputCell;
        }else{
            if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3) {
                StringInputTableViewCell *inputCell = [[[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
                inputCell.delegate = self;
                cell = inputCell;
            } else if(indexPath.row == 1){
                cell = [[[GenderPickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
            } else if(indexPath.row == 4){
                DateInputTableViewCell *dateCell = [[[DateInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
                dateCell.delegate = self;
                cell = dateCell;
            } else if(indexPath.row == 5){
                cell = [[[TravelerTypePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
            } else{
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
            }
        }
    }
    [cell setNeedsDisplay];
    [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.textLabel setText:_datas[indexPath.row]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    
    if(_contacterType == CONTACTER){
        switch (indexPath.row) {
            case 0:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                [(StringInputTableViewCell *)cell setStringValue:[_detail objectForKey:@"Name"]];
            }
                break;
            case 1:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                StringInputTableViewCell *inputCell = (StringInputTableViewCell *)cell;
                [inputCell.textField setKeyboardType:UIKeyboardTypePhonePad];
                NSString *phone = [_detail objectForKey:@"Phone"];
                [inputCell setStringValue: (NSNull *)phone != [NSNull null]?phone:@""];
            }
                break;
            case 2:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                StringInputTableViewCell *inputCell = (StringInputTableViewCell *)cell;
                [inputCell.textField setKeyboardType:UIKeyboardTypeEmailAddress];
                NSString *phone = [_detail objectForKey:@"Email"];
                [inputCell setStringValue: (NSNull *)phone != [NSNull null]?phone:@""];
            }
                break;
            case 3:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                StringInputTableViewCell *inputCell = (StringInputTableViewCell *)cell;
                NSString *address = [_detail objectForKey:@"Address"];
                [inputCell setStringValue: (NSNull *)address != [NSNull null]?address:@""];
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                [(StringInputTableViewCell *)cell setStringValue:[_detail objectForKey:@"Name"]];
            }
                break;
            case 1:{
                BOOL gender = [[_detail objectForKey:@"Gender"] boolValue];
                NSString *str = gender ? @"男":@"女";
                GenderPickerInputTableViewCell *pickerCell = (GenderPickerInputTableViewCell *)cell;
                pickerCell.delegate = self;
                [pickerCell setValue:str];
            }
                break;
            case 2:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                StringInputTableViewCell *inputCell = (StringInputTableViewCell *)cell;
                [inputCell setStringValue:[_detail objectForKey:@"ChinaId"]];
                [inputCell.textField setKeyboardType:UIKeyboardTypeNumberPad];
            }
                break;
            case 3:{
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                StringInputTableViewCell *inputCell = (StringInputTableViewCell *)cell;
                [inputCell.textField setKeyboardType:UIKeyboardTypePhonePad];
                NSString *phone = [_detail objectForKey:@"Phone"];
                [inputCell setStringValue: (NSNull *)phone != [NSNull null]?phone:@""];
            }
                break;
            case 4:{
                DateInputTableViewCell *dateCell = (DateInputTableViewCell *)cell;
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"yyyy-MM-dd"];
                [dateCell setMaxDate:[NSDate date]];
                [dateCell setMinDate:[formatter dateFromString:@"1900-1-1"]];
                
                NSString *birthday = [_detail objectForKey:@"Birthday"];
                if((NSNull *)birthday == [NSNull null]){
                    birthday = @"1900-1-1";
                }
                NSDate *date=[formatter dateFromString:birthday];
                [formatter release];
                [dateCell setDateValue:date];
            }
                break;
            case 5:{
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
        if(row == 0){
            [_detail setValue:value forKey:@"Name"];
        }else if(row == 1){
            [_detail setValue:value forKey:@"Phone"];
        }else if(row == 2){
            [_detail setValue:value forKey:@"Email"];
        }else if(row == 3){
            [_detail setValue:value forKey:@"Address"];
        }
    }else{
        if(row == 0){
            [_detail setValue:value forKey:@"Name"];
        }else if(row == 2){
            [_detail setValue:value forKey:@"ChinaId"];
        }else if(row == 3){
            [_detail setValue:value forKey:@"Phone"];
        }
    }
}
- (void)tableViewCell:(PickerInputTableViewCell *)cell didEndEditingWithValue:(NSString *)value
{
    int row = [_tableView indexPathForCell:cell].row;
    if(_contacterType == CONTACTER){
        if(row == 1){
            NSString *gender = @"0"; // female
            if([value isEqualToString:@"男"]){
                gender = @"1"; // male
            }
            [_detail setValue:gender forKey:@"Gender"];
        }
    }else{
        if(row == 1){
            NSString *gender = @"0"; // female
            if([value isEqualToString:@"男"]){
                gender = @"1"; // male
            }
            [_detail setValue:gender forKey:@"Gender"];
        }else if(row == 5){
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