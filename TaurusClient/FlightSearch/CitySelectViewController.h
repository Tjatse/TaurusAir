//
//  CitySelectViewController.h
//  TaurusClient
//
//  Created by Simon on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class City;

typedef void (^OnCitySelectedBlock)(City* city);

@interface CitySelectViewController : UIViewController
<UITableViewDataSource
, UITableViewDelegate
, UISearchBarDelegate
, UISearchDisplayDelegate>

@property (nonatomic, retain) IBOutlet UISearchBar*		filterKeyBar;
@property (nonatomic, retain) IBOutlet UITableView*		cityListView;
@property (nonatomic, copy) OnCitySelectedBlock			citySelectedBlock;
@property (nonatomic, retain) NSString*					defaultCityName;

@end
