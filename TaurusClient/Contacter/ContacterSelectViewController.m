//
//  ContacterSelectViewController.m
//  TaurusClient
//
//  Created by Tjatse on 13-1-13.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "ContacterSelectViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIBarButtonItem+Blocks.h"
#import "AppDefines.h"
#import "BBlock.h"
#import "CRTableViewCell.h"
#import "ContacterHelper.h"
#import "ALToastView.h"
#import "ContacterHelper.h"
#import "AppConfig.h"
#import "MBProgressHUD.h"
#import "NSDictionaryAdditions.h"

@interface ContacterSelectViewController ()

@end

@implementation ContacterSelectViewController
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithSelectType: (SelectType)theSelectType defaultSeletedData: (NSDictionary *)defaultSeletedData;
{
    self = [super init];
    if (self) {
        // Custom initialization
        _selectType = theSelectType;
        if(defaultSeletedData){
            _selectedPersons = [defaultSeletedData mutableCopy];
        }
    }
    return self;
}
- (void)setCompletionBlock:(SelectBlock)theCompletionBlock
{
    [_completionBlock release];
	_completionBlock = [theCompletionBlock copy];
}
- (void)dealloc
{
    [_datas release];
    [_tableView release];
    [_selectedPersons release];
    [_completionBlock release];
    [_roundRectButtonPopTipView release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *name = _selectType == SelectTypeContacter ? @"联系人":@"乘客";
    [self setTitle:[NSString stringWithFormat:@"选取%@", name]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController dismissModalViewControllerAnimated:YES];
                                       }];
    
    [_tableView setBackgroundView:nil];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    NSString *userId = [AppConfig get].currentUser.userId;
    if(_selectType == SelectTypeContacter){
        [ContacterHelper contactersWithId:userId
                                  success:^(NSArray *passengers) {
                                      if(passengers && [passengers count] > 0){
                                          [self wrapDatas:passengers];
                                      }else{
                                          [self showError:[NSString stringWithFormat:@"没有%@信息， 请在“常旅客”中添加。", name]];
                                      }
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  }
                                  failure:^(NSString *errorMsg) {
                                      [self showError:errorMsg];
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  }];
    }else if(_selectType == SelectTypePassenger){
        [ContacterHelper passengersWithId:userId
                                  success:^(NSArray *passengers) {
                                      if(passengers && [passengers count] > 0){
                                          [self wrapDatas:passengers];
                                      }else{
                                          [self showError:[NSString stringWithFormat:@"没有%@信息， 请在“常旅客”中添加。", name]];
                                      }
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  }
                                  failure:^(NSString *errorMsg) {
                                      [self showError:errorMsg];
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  }];
    }
}

- (void)showError:(NSString *)errMsg
{
    [ALToastView toastPinInView:self.navigationController.view withText:errMsg andBottomOffset:44 andType:ERROR];
}
- (void)wrapDatas: (NSArray *)contacters
{
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem generateNormalStyleButtonWithTitle:@"完成"
                                         andTapCallback:^(id control, UIEvent *event) {
                                             if(_completionBlock){
                                                 _completionBlock(_selectedPersons);
                                             }
                                             [self.navigationController dismissModalViewControllerAnimated:YES];
                                         }];
    
    _datas = [contacters retain];
    [_tableView reloadData];
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
    return _datas == nil ? 0 : [_datas count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"CRCell";
    CRTableViewCell *cell = (CRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil){
        cell = [[[CRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify]
                autorelease];
    }
    [cell setNeedsDisplay];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    BOOL selected = [self containsPerson:_datas[indexPath.row]];
    cell.isSelected = selected;
    if(selected && _selectType == SelectTypeContacter){
        _selectedRow = indexPath.row;
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.textLabel setText:[_datas[indexPath.row] getStringValueForKey:@"Name" defaultValue:@""]];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [infoButton addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
    infoButton.tag = indexPath.row;
    cell.accessoryView = infoButton;
    
    return cell;
}

- (BOOL)containsPerson: (NSDictionary *)person
{
    if(_selectedPersons == nil || [_selectedPersons count] == 0){
        return NO;
    }
    NSDictionary *p = [_selectedPersons objectForKey:[person getStringValueForKey:_selectType == CONTACTER ? @"ContactorId":@"PassengerId" defaultValue:@"-"]];
    return (p != nil && [p count] > 0);
}
- (IBAction)infoAction:(id)sender {
    if (nil == _roundRectButtonPopTipView) {
        NSString *content = @"";
        UIButton *button = (UIButton *)sender;
        NSDictionary *p = [_datas objectAtIndex:button.tag];
        if(_selectType == SelectTypePassenger){
            content = [NSString stringWithFormat:@"%@\n%@",
                       [p objectForKey:@"Name"],
                       [p getStringValueForKey:@"ChinaId" defaultValue:@"-"]];
        }else{
            content = [NSString stringWithFormat:@"%@\n%@",
                       [p objectForKey:@"Name"],
                       [p getStringValueForKey:@"Phone" defaultValue:@"-"]];
        }
        _roundRectButtonPopTipView = [[[CMPopTipView alloc] initWithMessage:content] autorelease];
        _roundRectButtonPopTipView.delegate = self;
        _roundRectButtonPopTipView.textAlignment = UITextAlignmentLeft;
        _roundRectButtonPopTipView.backgroundColor = [UIColor whiteColor];
        _roundRectButtonPopTipView.borderColor = [UIColor grayColor];
        _roundRectButtonPopTipView.textColor = [UIColor blackColor];
        _roundRectButtonPopTipView.dismissTapAnywhere = YES;
        
        [_roundRectButtonPopTipView presentPointingAtView:button inView:self.view animated:YES];
    }
    else {
        // Dismiss
        [_roundRectButtonPopTipView dismissAnimated:YES];
        _roundRectButtonPopTipView = nil;
    }
}

#pragma mark CMPopTipViewDelegate methods
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // User can tap CMPopTipView to dismiss it
    _roundRectButtonPopTipView = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CRTableViewCell *cell = (CRTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:NO animated:YES];
    if(_selectType == SelectTypePassenger){
        NSDictionary *p = [_datas objectAtIndex:indexPath.row];
        if(_selectedPersons == nil){
            _selectedPersons = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
        if(cell.isSelected){
            cell.isSelected = NO;
            [_selectedPersons removeObjectForKey:[p objectForKey:@"PassengerId"]];
        }else{
            cell.isSelected = YES;
            [_selectedPersons setObject:p forKey:[p objectForKey:@"PassengerId"]];
        }
    }else{
        if(cell.isSelected){
            return;
        }
        CRTableViewCell *oldCell = (CRTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0]];
        oldCell.isSelected = NO;
        
        CRTableViewCell *cell = (CRTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.isSelected = YES;
        _selectedRow = indexPath.row;
        [_selectedPersons release], _selectedPersons = [[NSMutableDictionary alloc] initWithCapacity:0];
        NSDictionary *p = [_datas objectAtIndex:_selectedRow];
        [_selectedPersons setObject:p forKey:[p objectForKey:@"ContactorId"]];
    }
}
@end
