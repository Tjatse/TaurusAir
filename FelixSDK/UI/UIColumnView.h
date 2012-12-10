//
//  UIColumnView.h
//  iProduct
//
//  Created by Hager Hu on 5/23/11.
//  Copyright 2011 dreamblock.net. All rights reserved.
//

//  This class provides the view whose content is larger than its frame.
//  It just like UITableView, you can use it easily.

#import <UIKit/UIKit.h>


@protocol UIColumnViewDelegate;
@protocol UIColumnViewDataSource;


@interface UIColumnView : UIScrollView <UIScrollViewDelegate> {
    NSMutableDictionary         *onScreenViewDic; //cache for all cells shown on screen
    NSMutableDictionary         *offScreenViewDic; //cache for all cells that can be reused
    
    NSUInteger					numberOfColumns;  //total count of columns of column view
    
    NSUInteger					startIndex; //current start index of view cell on screen
    NSUInteger					endIndex; //current end index of view cell on screen
    
    NSArray						*itemDataList;
    id<UIColumnViewDelegate>    viewDelegate;
    id<UIColumnViewDataSource>  viewDataSource;
    
    NSMutableArray              *originPointList; //store the view cell's left origin for all view cells
}

/*
 The data model for column view
 */
@property (nonatomic, retain) NSArray *itemDataList;

/*
 UIColumnView delegate
 */
@property (nonatomic, assign) id<UIColumnViewDelegate> viewDelegate;

/*
 UIColumnView data source
 */
@property (nonatomic, assign) id<UIColumnViewDataSource> viewDataSource;

/*
 Return the reused view cell for this column view, nil if no cell can be reused
 @param identifier the reused identifier
 */
- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;


/*
 Update view manully after the data model updated
 */
- (void)reloadData;

@end



@protocol UIColumnViewDelegate <NSObject>

/*
 This method is invoked when user select an view cell of it
 @param index the index user selected
 */
- (void)columnView:(UIColumnView *)columnView didSelectColumnAtIndex:(NSUInteger)index;


/*
 The width for column at the index
 UIColumnView will get the width of column at the index from this method
 @param index the index of column view cell
 */
- (CGFloat)columnView:(UIColumnView *)columnView widthForColumnAtIndex:(NSUInteger)index;

@end



@protocol UIColumnViewDataSource <NSObject>

/*
 The count of column view cell in this column view
 @param columnView the object of UIColumnView
 */
- (NSUInteger)numberOfColumnsInColumnView:(UIColumnView *)columnView;


/*
 The relative view for the column at the index
 @param index the index for the column view
 */
- (UITableViewCell *)columnView:(UIColumnView *)columnView viewForColumnAtIndex:(NSUInteger)index;

@end