//
//  HelpViewController.m
//  EnterpriseIM
//
//  Created by john on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

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
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _arrayImageView = [[NSArray alloc] initWithObjects:
                            @"help1.jpg",
                            @"help2.jpg",
                            @"help3.jpg",
                            @"help4.jpg",
                            @"help5.jpg",
                            @"help6.jpg", nil];
    kNumberOfPages = [_arrayImageView count];
    
    // views	
    _imageViews = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [_arrayImageView count]; i++) {
        [_imageViews addObject:[NSNull null]];
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * kNumberOfPages, _scrollView.frame.size.height);
    
    // load the page
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
    // replace the placeholder if necessary
    UIImageView *view = [_imageViews objectAtIndex:page];
    if ((NSNull *)view == [NSNull null]) {
        UIImage *img = [UIImage imageNamed:[_arrayImageView objectAtIndex:page]];
        view = [[UIImageView alloc] initWithImage:img];
        view.alpha = 0.7;
        [_imageViews replaceObjectAtIndex:page withObject:view];
		[view release];
    }
	
    // add the controller's view to the scroll view
    if (nil == view.superview) {
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        view.frame = frame;
        [_scrollView addSubview:view];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pagesControl.currentPage = page;
    if (_pagesControl.currentPage == kNumberOfPages - 1) {
        _buttonIn.hidden = NO;
    }else {
        _buttonIn.hidden = YES;
    }
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = _pagesControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}
- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [self setArrayImageView:nil];
    [self setPagesControl:nil];
    [self setButtonIn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_scrollView release];
    [_imageView release];
    [_arrayImageView release];
    [_pagesControl release];
    [_buttonIn release];
    [super dealloc];
}
- (IBAction)actionIn:(id)sender {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
