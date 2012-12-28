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
#import "TravelerDetailViewController.h"

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
    
    currentTableView = TRAVELERS;
    _travelers = [[@"[{\"Birthday\":\"1967-12-1\",\"ChinaId\":\"4130261234987609871\",\"Gender\":true,\"Name\":\"李韦\",\"PassengerId\":36023,\"Phone\":null,\"TravelerType\":1},{\"Birthday\":\"1983-4-21\",\"ChinaId\":\"4130261234987609871\",\"Gender\":false,\"Name\":\"孔乐乐\",\"PassengerId\":36021,\"Phone\":\"13800102132\",\"TravelerType\":1},{\"Birthday\":\"2009-8-10\",\"ChinaId\":\"4130261234987609871\",\"Gender\":false,\"Name\":\"孔墨\",\"PassengerId\":36024,\"Phone\":null,\"TravelerType\":2}]" objectFromJSONString] retain];
    
    _contactors = [[@"[{\"Address\":\"北京市朝阳区东三环北路辛2号迪阳大厦1609\",\"ContactorId\":36025,\"Email\":\"xiongjun@beyondlink.net\",\"Name\":\"熊俊\",\"Phone\":\"15810591307\"},{\"Address\":\"武汉市中山路1024号504#\",\"ContactorId\":36024,\"Email\":\"zhangc@qq.com\",\"Name\":\"张超\",\"Phone\":\"13712341234\"}]" objectFromJSONString] retain];
    
    [self setTitle:@"常旅客"];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.tableViewTravelers setBackgroundColor:[UIColor clearColor]];
    [self.tableViewTravelers setBackgroundView:nil];
    [self.tableViewContactors setBackgroundColor:[UIColor clearColor]];
    [self.tableViewContactors setBackgroundView:nil];
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    if(indexPath.row != 0){
        if(tableView.tag == TRAVELERS){
            TravelerDetailViewController *vc = [[TravelerDetailViewController alloc] init];
            vc.detail = _travelers[indexPath.row - 1];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
    }
}

@end
