//
//  TravelerDetailViewController.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-27.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "TravelerDetailViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIBarButtonItem+Blocks.h"
#import "BBlock.h"
#import "EditTravelerViewController.h"

@interface TravelerDetailViewController ()

@end

@implementation TravelerDetailViewController
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
    
    [self setTitle:@"详细信息"];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    if(_contacterType == CONTACTER){
        _datas = [[NSArray alloc] initWithArray: @[@"编       号", @"姓       名", @"手机号码", @"邮件地址", @"通信地址"]];
    }else{
        _datas = [[NSArray alloc] initWithArray: @[@"编       号", @"姓       名", @"性       别", @"身份证号", @"手机号码", @"生       日", @"类       型"]];
    }
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }];
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem generateNormalStyleButtonWithTitle:@"编辑"
                                         andTapCallback:^(id control, UIEvent *event) {
                                             EditTravelerViewController *vc = [[EditTravelerViewController alloc] init];
                                             vc.contacterType = _contacterType;
                                             vc.detail = [NSMutableDictionary dictionaryWithDictionary:_detail];
                                             [self.navigationController pushViewController:vc animated:YES];
                                             [vc release];
                                         }];
    [_tableView setBackgroundView:nil];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTraveler:) name:@"REFRESH_TRAVELER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshContacter:) name:@"REFRESH_CONTACTER" object:nil];
}
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REFRESH_TRAVELER" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REFRESH_CONTACTER" object:nil];
    [super viewDidUnload];
}
- (void)refreshTraveler:(NSNotification *)notification
{
    NSDictionary *_traveler = [[notification userInfo] objectForKey:@"TRAVELER"];
    [_detail release];
    _detail = [[NSDictionary alloc] initWithDictionary:_traveler];
    [_tableView reloadData];
}
- (void)refreshContacter:(NSNotification *)notification
{
    NSDictionary *_contacter = [[notification userInfo] objectForKey:@"CONTACTER"];
    [_detail release];
    _detail = [[NSDictionary alloc] initWithDictionary:_contacter];
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
    return [_datas count];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.textLabel setText:_datas[indexPath.row]];
    
    
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    
    if(_contacterType == CONTACTER){
        switch (indexPath.row) {
            case 0:{
                [cell.detailTextLabel setText:[[_detail objectForKey:@"ContactorId"] stringValue]];
            }
                break;
            case 1:{
                [cell.detailTextLabel setText:[_detail objectForKey:@"Name"]];
            }
                break;
            case 2:{
                [cell.detailTextLabel setText:[_detail objectForKey:@"Phone"]];
            }
                break;
            case 3:{
                NSString *email = [_detail objectForKey:@"Email"];
                [cell.detailTextLabel setText:(NSNull *)email != [NSNull null] ? email: @"-"];
            }
                break;
            case 4:{
                [cell.detailTextLabel setNumberOfLines:0];
                NSString *address = [_detail objectForKey:@"Address"];
                [cell.detailTextLabel setText:(NSNull *)address != [NSNull null] ? address: @"-"];
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                [cell.detailTextLabel setText:[[_detail objectForKey:@"PassengerId"] stringValue]];
                break;
            case 1:
                [cell.detailTextLabel setText:[_detail objectForKey:@"Name"]];
                break;
            case 2:{
                BOOL gender = [[_detail objectForKey:@"Gender"] boolValue];
                [cell.detailTextLabel setText:gender ? @"男":@"女"];
            }
                break;
            case 3:
                [cell.detailTextLabel setText:[_detail objectForKey:@"ChinaId"]];
                break;
            case 4:{
                NSString *phone = [_detail objectForKey:@"Phone"];
                [cell.detailTextLabel setText: (NSNull *)phone != [NSNull null]?phone:@"-"];
            }
                break;
            case 5:{
                NSString *_birthday = [_detail objectForKey:@"Birthday"];
                [cell.detailTextLabel setText:(NSNull *)_birthday != [NSNull null] ? [_birthday componentsSeparatedByString:@" "][0]:@"-"];
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
                [cell.detailTextLabel setText:type];
            }
                break;
            default:
                break;
        }
    }
    return cell;
}
@end