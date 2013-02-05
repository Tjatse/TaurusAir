//
//  OrderRefundViewController.m
//  TaurusClient
//
//  Created by Tjatse on 13-2-5.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "OrderRefundViewController.h"
#import "CRTableViewCell.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIBarButtonItem+Blocks.h"
#import "NSDictionaryAdditions.h"
#import "MBProgressHUD.h"
#import "ALToastView.h"
#import "OrderHelper.h"
#import "AppConfig.h"

@interface OrderRefundViewController ()

@end

@implementation OrderRefundViewController

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
    _selectedFlights = [[NSMutableArray alloc] initWithCapacity:0];
    _selectedPassengers = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setTitle:@"申请退票"];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundView:nil];
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem generateNormalStyleButtonWithTitle:@"完成"
                                         andTapCallback:^(id control, UIEvent *event) {
                                             [self refund];
                                         }];
    
    
    NSString *psg = [_detail getStringValueForKey:@"Traveler" defaultValue:nil];
    if(psg != nil && (NSNull *)psg != [NSNull null]){
        NSArray *ts = [psg componentsSeparatedByString:@"^"];
        
        [_passengers release], _passengers = nil;
        _passengers = [[NSMutableArray alloc] initWithCapacity:0];
        for(NSString *t in ts){
            NSArray *ps = [t componentsSeparatedByString:@"_"];
            if([ps count] == 3){
                [_passengers addObject:@{@"name":ps[0],@"type":ps[1],@"chinaId":ps[2]}];
            }
        }
    }
    
    NSString *fls = [_detail getStringValueForKey:@"Flight" defaultValue:nil];
    if(fls != nil && (NSNull *)fls != [NSNull null]){
        NSArray *fs = [fls componentsSeparatedByString:@"^"];
        
        [_flights release], _flights = nil;
        _flights = [[NSMutableArray alloc] initWithCapacity:0];
        for(NSString *f in fs){
            NSArray *ps = [f componentsSeparatedByString:@"_"];
            [_flights addObject:ps[1]];
        }
    }
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [_detail release];
    [_passengers release];
    [_flights release];
    [_selectedFlights release];
    [_selectedPassengers release];
    [_reason release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSelectedFlights:nil];
    [self setSelectedPassengers:nil];
    [self setTableView:nil];
    [self setDetail:nil];
    [self setReason:nil];
    [super viewDidUnload];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return _passengers == nil ? 0 : [_passengers count];
    }else if(section == 1){
        return _flights == nil ? 0 : [_flights count];
    }else{
        return 1;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return @"乘客";
    }else if(section == 1){
        return @"航班";
    }else if(section == 2){
        return @"原因";
    }else{
        return @"";
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"CRCell";
    UITableViewCell *cell = (CRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil){
        if(indexPath.section == 2){
            StringInputTableViewCell *inputCell = [[[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
            inputCell.delegate = self;
            [inputCell.textField setPlaceholder:@"输入退票原因"];
            [inputCell.textField setReturnKeyType:UIReturnKeyDone];
            cell = inputCell;
        }else{
            cell = [[[CRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        }
    }
    [cell setNeedsDisplay];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    BOOL selected = NO;
    if(indexPath.section == 0){
        
        for(int i = [_selectedPassengers count] - 1; i >= 0; i--){
            if([[_selectedPassengers objectAtIndex:i] isEqualToString:cell.textLabel.text]){
                selected = YES;
            }
        }
        CRTableViewCell *myCell = (CRTableViewCell *)cell;
        myCell.isSelected = selected;
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setText:[_passengers[indexPath.row] getStringValueForKey:@"name" defaultValue:@""]];
        
    }else if(indexPath.section == 1){
        
        for(int i = [_selectedFlights count] - 1; i >= 0; i--){
            if([[_selectedFlights objectAtIndex:i] isEqualToString:cell.textLabel.text]){
                selected = YES;
            }
        }
        CRTableViewCell *myCell = (CRTableViewCell *)cell;
        myCell.isSelected = selected;
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setText:_flights[indexPath.row]];
        
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0 || indexPath.section == 1){
        CRTableViewCell *cell = (CRTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.isSelected = !cell.isSelected;
        if(cell.isSelected){
            if(indexPath.section == 0){
                [_selectedPassengers addObject:cell.textLabel.text];
            }else if(indexPath.section == 1){
                [_selectedFlights addObject:cell.textLabel.text];
            }
        }else{
            if(indexPath.section == 0){
                for(int i = [_selectedPassengers count] - 1; i >= 0; i--){
                    if([[_selectedPassengers objectAtIndex:i] isEqualToString:cell.textLabel.text]){
                        [_selectedPassengers removeObjectAtIndex:i];
                    }
                }
            }else if(indexPath.section == 1){
                for(int i = [_selectedFlights count] - 1; i >= 0; i--){
                    if([[_selectedFlights objectAtIndex:i] isEqualToString:cell.textLabel.text]){
                        [_selectedFlights removeObjectAtIndex:i];
                    }
                }
            }
        }
    }
    
    StringInputTableViewCell *cell = (StringInputTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    if([cell.textField canResignFirstResponder]){
        [cell.textField resignFirstResponder];
    }
}

- (void)tableViewCell:(StringInputTableViewCell *)cell didBeginEditingWithString:(NSString *)value
{
    [_tableView setContentOffset:CGPointMake(0, 200) animated:YES];
    [_tableView setScrollEnabled:NO];
}
- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)value
{
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    _reason = [[NSString alloc] initWithString:value];
    NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    _reason = [_reason stringByTrimmingCharactersInSet:ws];
    [cell.textField resignFirstResponder];
    [_tableView setScrollEnabled:YES];
}

- (void)refund
{
    if([_selectedPassengers count] == 0){
        [ALToastView toastInView:self.view withText:@"请选择退票乘客。" andBottomOffset:44 andType:ERROR];
        return;
    }
    if([_selectedFlights count] == 0){
        [ALToastView toastInView:self.view withText:@"请选择退票航班。" andBottomOffset:44 andType:ERROR];
        return;
    }
    if(_reason == nil || [_reason length] == 0){
        [ALToastView toastInView:self.view withText:@"必须填写退票原因。" andBottomOffset:44 andType:ERROR];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在退票..."];
    
    NSString *passengerAndFlights = @"";
    for(NSString *psg in _selectedPassengers){
        for(NSString *flt in _selectedFlights){
            passengerAndFlights = [NSString stringWithFormat:@"%@:%@;%@",psg,flt,passengerAndFlights];
        }
    }
    
    [OrderHelper refundWithId:[_detail getStringValueForKey:@"Tid" defaultValue:@""]
           passengerAndFlight:passengerAndFlights
                refundResonse:_reason
                         user:[AppConfig get].currentUser
                      success:^{
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_REFUND" object:nil];
                          [self.navigationController dismissModalViewControllerAnimated:YES];
                      }
                      failure:^(NSString *errorMsg) {
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          [ALToastView toastInView:self.view withText:errorMsg andBottomOffset:44 andType:ERROR];
                      }];
}
@end
