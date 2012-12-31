//
//  ContacterViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-12.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "ContacterViewController.h"
#import "AppConfig.h"
#import "UIBGNavigationController.h"
#import "UIBarButtonItem+Blocks.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "AppDefines.h"
#import "JSONKit.h"
#import "BBlock.h"
#import "TravelerDetailViewController.h"
#import "CreateTravelerViewController.h"
#import "LoginViewController.h"
#import "ALToastView.h"

@interface ContacterViewController ()

@end

@implementation ContacterViewController
@synthesize buttonContactors, buttonTravelers, tableViewContactors, tableViewTravelers;

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
    [tableViewTravelers release];
    [tableViewContactors release];
    [buttonContactors release];
    [buttonTravelers release];
    [_travelers release];
    [_contactors release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"常旅客"];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.tableViewTravelers setBackgroundColor:[UIColor clearColor]];
    [self.tableViewTravelers setBackgroundView:nil];
    [self.tableViewContactors setBackgroundColor:[UIColor clearColor]];
    [self.tableViewContactors setBackgroundView:nil];
    
    if(![[AppConfig get] isLogon]){
        [tableViewContactors setHidden:YES];
        [tableViewTravelers setHidden:YES];
        [buttonContactors setHidden:YES];
        [buttonTravelers setHidden:YES];
        
        [self showLoginViewController];
        self.navigationItem.rightBarButtonItem =
        [UIBarButtonItem generateNormalStyleButtonWithTitle:@"登录"
                                             andTapCallback:^(id control, UIEvent *event) {
                                                 [self showLoginViewController];
                                             }];
        [ALToastView toastPinInView:self.view withText:@"登录后才能访问“常旅客”。" andBottomOffset: 205];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"LOGIN_SUC" object:nil];
    }else{
        [self initComponent];
    }
    
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
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REFRESH_TRAVELER" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DELETE_TRAVELER" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ADD_TRAVELER" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REFRESH_CONTACTER" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DELETE_CONTACTER" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ADD_CONTACTER" object:nil];
    [super viewDidUnload];
}
#pragma mark - InitComponents
- (void)initComponent
{
    self.navigationItem.rightBarButtonItem = nil;
    NSArray *subViews = [self.view subviews];
    if(subViews && [subViews count] > 0){
        for(UIView *v in subViews){
            if(v.tag == 0){
                [v removeFromSuperview];
            }
        }
    }
    
    [tableViewContactors setHidden:NO];
    [tableViewTravelers setHidden:NO];
    [buttonContactors setHidden:NO];
    [buttonTravelers setHidden:NO];
    
    currentTableView = TRAVELERS;
    _travelers = [[@"[{\"Birthday\":\"1967-12-1\",\"ChinaId\":\"4130261234987609871\",\"Gender\":true,\"Name\":\"李韦\",\"PassengerId\":36023,\"Phone\":null,\"TravelerType\":1},{\"Birthday\":\"1983-4-21\",\"ChinaId\":\"4130261234987609871\",\"Gender\":false,\"Name\":\"孔乐乐\",\"PassengerId\":36021,\"Phone\":\"13800102132\",\"TravelerType\":1},{\"Birthday\":\"2009-8-10\",\"ChinaId\":\"4130261234987609871\",\"Gender\":false,\"Name\":\"孔墨\",\"PassengerId\":36024,\"Phone\":null,\"TravelerType\":2}]" objectFromJSONString] mutableCopy];
    
    _contactors = [[@"[{\"Address\":\"北京市朝阳区东三环北路辛2号迪阳大厦1609\",\"ContactorId\":36025,\"Email\":\"xiongjun@beyondlink.net\",\"Name\":\"熊俊\",\"Phone\":\"15810591307\"},{\"Address\":\"武汉市中山路1024号504#\",\"ContactorId\":36024,\"Email\":\"zhangc@qq.com\",\"Name\":\"张超\",\"Phone\":\"13712341234\"}]" objectFromJSONString] mutableCopy];
    
    // notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTraveler:) name:@"REFRESH_TRAVELER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteTraveler:) name:@"DELETE_TRAVELER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTraveler:) name:@"ADD_TRAVELER" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshContacter:) name:@"REFRESH_CONTACTER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteContacter:) name:@"DELETE_CONTACTER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addContacter:) name:@"ADD_CONTACTER" object:nil];
    
    [tableViewTravelers reloadData];
    [tableViewContactors reloadData];
}
#pragma mark - Notifications
- (void)refreshTraveler:(NSNotification *)notification
{
    NSDictionary *_traveler = [[notification userInfo] objectForKey:@"TRAVELER"];
    NSNumber *passengerId = [_traveler objectForKey:@"PassengerId"];
    if([_travelers count] > 0){
        for(int i = 0; i < [_travelers count]; i++){
            if([[_travelers[i] objectForKey:@"PassengerId"] isEqualToNumber:passengerId]){
                [_travelers replaceObjectAtIndex:i withObject:_traveler];
            }
        }
    }else{
        [_travelers addObject:_traveler];
    }
    [tableViewTravelers reloadData];
}
- (void)deleteTraveler:(NSNotification *)notification
{
    NSNumber *passengerId = [[notification userInfo] objectForKey:@"PassengerId"];
    if([_travelers count] > 0){
        for(int i = 0; i < [_travelers count]; i++){
            if([[_travelers[i] objectForKey:@"PassengerId"] isEqualToNumber:passengerId]){
                [_travelers removeObjectAtIndex:i];
                break;
            }
        }
        [tableViewTravelers reloadData];
    }
}
- (void)addTraveler:(NSNotification *)notification
{
    NSDictionary *traveler = [[notification userInfo] objectForKey:@"TRAVELER"];
    [_travelers addObject:traveler];
    [tableViewTravelers reloadData];
}

- (void)refreshContacter:(NSNotification *)notification
{
    NSDictionary *_contacter = [[notification userInfo] objectForKey:@"CONTACTER"];
    NSNumber *cId = [_contacter objectForKey:@"ContactorId"];
    if([_contactors count] > 0){
        for(int i = 0; i < [_contactors count]; i++){
            if([[_contactors[i] objectForKey:@"ContactorId"] isEqualToNumber:cId]){
                [_contactors replaceObjectAtIndex:i withObject:_contacter];
            }
        }
    }else{
        [_contactors addObject:_contacter];
    }
    [tableViewContactors reloadData];
}
- (void)deleteContacter:(NSNotification *)notification
{
    NSNumber *cId = [[notification userInfo] objectForKey:@"ContactorId"];
    if([_contactors count] > 0){
        for(int i = 0; i < [_contactors count]; i++){
            if([[_contactors[i] objectForKey:@"ContactorId"] isEqualToNumber:cId]){
                [_contactors removeObjectAtIndex:i];
                break;
            }
        }
        [tableViewContactors reloadData];
    }
}
- (void)addContacter:(NSNotification *)notification
{
    NSDictionary *contacter = [[notification userInfo] objectForKey:@"CONTACTER"];
    [_contactors addObject:contacter];
    [tableViewContactors reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Events
-(void)swithTableView:(id)sender
{
    int tag = ((UIButton *)sender).tag;
    if(tag == currentTableView){
        return;
    }
    
    if(tag == TRAVELERS){
        [buttonContactors setBackgroundImage:[UIImage imageNamed:@"tab_btn_right_off.png"] forState:UIControlStateNormal];
        [buttonTravelers setBackgroundImage:[UIImage imageNamed:@"tab_btn_left_on.png"] forState:UIControlStateNormal];
    }else if(tag == CONTACTORS){
        [buttonTravelers setBackgroundImage:[UIImage imageNamed:@"tab_btn_left_off.png"] forState:UIControlStateNormal];
        [buttonContactors setBackgroundImage:[UIImage imageNamed:@"tab_btn_right_on.png"] forState:UIControlStateNormal];
    }
    [self slideTableView:(tag == TRAVELERS)];
    currentTableView = tag;
}
- (void)slideTableView: (BOOL)origin
{
    CGRect frameContators = self.tableViewContactors.frame;
    CGRect frameTravelers = self.tableViewTravelers.frame;
    
    if(origin){
        frameTravelers.origin.x = 0;
        frameContators.origin.x = frameContators.size.width;
    }else{
        frameTravelers.origin.x = -frameTravelers.size.width;
        frameContators.origin.x = 0;
    }
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.tableViewTravelers setFrame:frameTravelers];
                         [self.tableViewContactors setFrame:frameContators];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == TRAVELERS){
        return _travelers ? [_travelers count] + 1 : 1;
    }else if(tableView.tag == CONTACTORS){
        return _contactors ? [_contactors count] + 1 : 1;
    }
    return 0;
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
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    if(indexPath.row == 0){
        [cell.imageView setImage:[UIImage imageNamed:@"plus.png"]];
    }else{
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
    }
    
    if(tableView.tag == TRAVELERS){
        if(indexPath.row == 0){
            [cell.textLabel setText:@"添加常旅客"];
        }else{
            [cell.textLabel setText:[_travelers[indexPath.row - 1] objectForKey:@"Name"]];
            [cell.detailTextLabel setText:[_travelers[indexPath.row - 1] objectForKey:@"ChinaId"]];
        }
    }else if(tableView.tag == CONTACTORS){
        if(indexPath.row == 0){
            [cell.textLabel setText:@"添加联系人"];
        }else{
            [cell.textLabel setText:[_contactors[indexPath.row - 1] objectForKey:@"Name"]];
            [cell.detailTextLabel setText:[_contactors[indexPath.row - 1] objectForKey:@"Phone"]];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0){
        CreateTravelerViewController *vc = [[CreateTravelerViewController alloc] init];
        vc.contacterType = tableView.tag == TRAVELERS ? TRAVELER : CONTACTER;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }else{
        TravelerDetailViewController *vc = [[TravelerDetailViewController alloc] init];
        if(tableView.tag == TRAVELERS){
            vc.detail = _travelers[indexPath.row - 1];
        }else{
            vc.detail = _contactors[indexPath.row - 1];
        }
        vc.contacterType = tableView.tag == TRAVELERS ? TRAVELER : CONTACTER;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

@end
