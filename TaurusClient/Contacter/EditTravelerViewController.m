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
#import "AppDefines.h"
#import "BBlock.h"

@interface EditTravelerViewController ()

@end

@implementation EditTravelerViewController
@synthesize detail = _detail;
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
    [_datas release];
    [_tableView release];
    [_detail release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _datas = [[NSArray alloc] initWithArray: @[@"编       号", @"姓       名", @"性       别", @"身份证号", @"手机号码", @"生       日", @"类       型"]];
    
    [self setTitle:@"编辑信息"];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }];
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem generateNormalStyleButtonWithTitle:@"完成"
                                         andTapCallback:^(id control, UIEvent *event) {
                                             [self.navigationController popViewControllerAnimated:YES];
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
    if(indexPath.row == 7){
        return 56;
    }
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count] + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
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
    [cell setNeedsDisplay];
    [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
    
    if(indexPath.row != 7){
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setText:_datas[indexPath.row]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    }
    
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
            NSDate *date=[formatter dateFromString:birthday];
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
        case 7:{
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
    return cell;
}
- (void)delTraveler
{
    NSLog(@"del");
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2){
        [_tableView setContentOffset:CGPointMake(0, 88) animated:YES];
    }else if(indexPath.row == 5){
        [_tableView setContentOffset:CGPointMake(0, 176) animated:YES];
    }else if(indexPath.row == 6){
        [_tableView setContentOffset:CGPointMake(0, 198) animated:YES];
    }
}
- (void)tableViewCell:(StringInputTableViewCell *)cell didBeginEditingWithString:(NSString *)value
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if(indexPath.row == 1){
        [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if(indexPath.row == 3){
        [_tableView setContentOffset:CGPointMake(0, 110) animated:YES];
    }else if(indexPath.row == 4){
        [_tableView setContentOffset:CGPointMake(0, 132) animated:YES];
    }
}
- (void)tableViewCell:(DateInputTableViewCell *)cell didEndEditingWithDate:(NSDate *)value
{
    [cell setDateValue:value];
    NSLog(@"date: %@", value);
}
- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)value
{
    NSLog(@"string: %@", value);
}
- (void)tableViewCell:(PickerInputTableViewCell *)cell didEndEditingWithValue:(NSString *)value
{
    NSLog(@"picker: %@", value);
}
@end
