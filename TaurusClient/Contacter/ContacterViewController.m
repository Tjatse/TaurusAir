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
#import "ContacterHelper.h"
#import "MBProgressHUD.h"
#import "ContacterSelectViewController.h"

@interface ContacterViewController ()
{
	BOOL		isNotificationsPushed_;
}

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
	
	if (isNotificationsPushed_) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"REFRESH_TRAVELER" object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"DELETE_TRAVELER" object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"ADD_TRAVELER" object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"REFRESH_CONTACTER" object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"DELETE_CONTACTER" object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"ADD_CONTACTER" object:nil];
	}
	
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
        [ALToastView toastPinInView:self.view withText:@"登录后才能访问“常旅客”。" andBottomOffset: 208 andType: ERROR];
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
    _isLoading = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"读取常旅客...";
    [ContacterHelper passengersWithId:[AppConfig get].currentUser.userId
                              success:^(NSArray *passengers) {
                                  [self renderView:passengers];
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  _isLoading = NO;
                              }
                              failure:^(NSString *errorMsg) {
                                  [ALToastView toastPinInView:self.view withText:errorMsg andBottomOffset: 208 andType: ERROR];
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  _isLoading = NO;
                                  [self setRightButton:NO];
                              }];
}
- (void)renderView: (NSArray *)travelers{
    
    _currentTableView = TRAVELERS;
    _travelers = [travelers mutableCopy];
    
    [tableViewContactors setHidden:NO];
    [tableViewTravelers setHidden:NO];
    [buttonContactors setHidden:NO];
    [buttonTravelers setHidden:NO];
    
    [self setRightButton:NO];
    
    // notifications.
	isNotificationsPushed_ = YES;
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTraveler:) name:@"REFRESH_TRAVELER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteTraveler:) name:@"DELETE_TRAVELER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTraveler:) name:@"ADD_TRAVELER" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshContacter:) name:@"REFRESH_CONTACTER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteContacter:) name:@"DELETE_CONTACTER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addContacter:) name:@"ADD_CONTACTER" object:nil];
    
    [tableViewTravelers reloadData];
    [tableViewContactors reloadData];
}
#pragma mark Refresh
- (void)setRightButton: (BOOL)refreshing{
    if(!refreshing){
        [self.navigationItem setRightBarButtonItem:nil];
        self.navigationItem.rightBarButtonItem =
        [UIBarButtonItem generateNormalStyleButtonWithTitle:@"刷新"
                                             andTapCallback:^(id control, UIEvent *event) {
                                                 [self refresh];
                                             }];
    }else{
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 61, 30)];
        [imageView setImage:[UIImage imageNamed:@"t_btn_right.png"]];
        
        UIActivityIndicatorView *ind = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [ind setFrame:CGRectMake(20, 5, 20, 20)];
        [imageView addSubview:ind];
        self.navigationItem.rightBarButtonItem.customView = imageView;
        [ind startAnimating];
        [ind release];
        [imageView release];
    }
}
- (void)refresh
{
    if(_isLoading){ return; }
    [self setRightButton:YES];
    
    if(_currentTableView == TRAVELERS){
        _isLoading = YES;
        [ContacterHelper passengersWithId:[AppConfig get].currentUser.userId
                                  success:^(NSArray *passengers) {
                                      [_travelers release], _travelers = nil;
                                      _travelers = [passengers mutableCopy];
                                     
                                      [tableViewTravelers reloadData];
                                      [self setRightButton:NO];
                                      _isLoading = NO;
                                  }
                                  failure:^(NSString *errorMsg) {
                                      [self setRightButton:NO];
                                      [ALToastView toastInView:self.view withText:errorMsg andBottomOffset:44 andType:ERROR];
                                      _isLoading = NO;
                                  }];
    }else if(_currentTableView == CONTACTORS){
        _isLoading = YES;
        [ContacterHelper contactersWithId:[AppConfig get].currentUser.userId
                                  success:^(NSArray *contacters) {
                                      [_contactors release], _contactors = nil;
                                      _contactors = [contacters mutableCopy];
                                      [tableViewContactors reloadData];
                                      [self setRightButton:NO];
                                      _isLoading = NO;
                                  }
                                  failure:^(NSString *errorMsg) {
                                      [self setRightButton:NO];
                                      [ALToastView toastPinInView:self.view withText:errorMsg andBottomOffset: 208 andType: ERROR];
                                      _isLoading = NO;
                                  }];

    }
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
- (void)loadContacters
{
    _isLoading = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"读取联系人...";
    
    [ContacterHelper contactersWithId:[AppConfig get].currentUser.userId
                              success:^(NSArray *contacters) {
                                  _contactors = [contacters mutableCopy];
                                  [tableViewContactors reloadData];
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  _isLoading = NO;
                              }
                              failure:^(NSString *errorMsg) {
                                  [ALToastView toastPinInView:self.view withText:errorMsg andBottomOffset: 208 andType: ERROR];
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  _isLoading = NO;
                              }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Events
-(void)swithTableView:(id)sender
{
    if(_isLoading){ return; }
    
    int tag = ((UIButton *)sender).tag;
    if(tag == _currentTableView){
        return;
    }
    
    if(tag == TRAVELERS){
        [self setButtonHightlight:buttonContactors isHightlight:@"tab_btn_right_off.png"];
        [self setButtonHightlight:buttonTravelers isHightlight:@"tab_btn_left_on.png"];
    }else if(tag == CONTACTORS){
        [self setButtonHightlight:buttonTravelers isHightlight:@"tab_btn_left_off.png"];
        [self setButtonHightlight:buttonContactors isHightlight:@"tab_btn_right_on.png"];
    }
    [self slideTableView:(tag == TRAVELERS)];
    _currentTableView = tag;
}
- (void)setButtonHightlight: (UIButton *)button
         isHightlight: (NSString *)highlightImage
{
    [button setBackgroundImage:[UIImage imageNamed:highlightImage] forState:UIControlStateNormal];
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
                         if(_currentTableView == CONTACTORS && _contactors == nil){
                             [self loadContacters];
                         }
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
