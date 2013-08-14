//
//  CCMainTableViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-3-22.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCMainTableViewController.h"

@interface CCMainTableViewController ()

@end

@implementation CCMainTableViewController


- (void)showLeft
{
//    CCSideViewController *sideView = [[CCSideViewController alloc] init];
//    [self.revealSideViewController pushViewController:sideView onDirection:PPRevealSideDirectionLeft animated:YES];
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
}

- (void)getData
{
    
}

- (void)showNetworkErrorNotifier
{
    [BWStatusBarOverlay setAnimation:BWStatusBarOverlayAnimationTypeFromTop];
    [BWStatusBarOverlay showSuccessWithMessage:@"连接错误，请检查你的网络或稍后再试" duration:4.0 animated:YES];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (ApplicationDelegate.newsEngine && ApplicationDelegate.academiaEngine) {
        [self.refreshHeaderView refreshLastUpdatedDate];
    }
    
    if (self.refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc]
                                           initWithFrame:CGRectMake(0,
                                                                    - self.tableView.bounds.size.height,
                                                                    self.view.frame.size.width,
                                                                    self.tableView.bounds.size.height)
                                           arrowImageName:@"grayArrow.png"
                                           textColor:[UIColor grayColor]];
        view.delegate = self;
        [self.tableView addSubview:view];
        self.refreshHeaderView = view;
    }
    
    
    
    
    
    UIImage *barButtonImageNormal = [UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_common", kPNGFileType)];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setBackgroundImage:barButtonImageNormal
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsDefault];
    
    
    
    
    UIImage *backButtonImageNormal = [[UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_back", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 5)];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setBackButtonBackgroundImage:backButtonImageNormal
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsDefault];
    
    
    
    
    
    UIImage *backButtonImageActive = [[UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_back_active", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 5)];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setBackButtonBackgroundImage:backButtonImageActive
     forState:UIControlStateHighlighted
     barMetrics:UIBarMetricsDefault];
    
    
    


    
//    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
//                                   initWithTitle:@""
//                                   style:UIBarButtonItemStyleBordered
//                                   target:self
//                                   action:@selector(showLeft)];
//    
//    menuButton.image = [UIImage imageWithContentsOfFile:PathInMainBundle(@"navbar_toggle", kPNGFileType)];
//    
//    [menuButton setBackgroundImage:barButtonImageNormal
//                          forState:UIControlStateNormal
//                        barMetrics:UIBarMetricsDefault];
//    self.navigationItem.leftBarButtonItem = menuButton;

    
    
    
    
    
    
//    UIImage *navBarImageNormal = [[UIImage imageWithContentsOfFile:PathInMainBundle(@"nav_top", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
//    
//    [self.navigationController.navigationBar setBackgroundImage:navBarImageNormal
//                                                  forBarMetrics:UIBarMetricsDefault];
    
    
    
    
    
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor blackColor], UITextAttributeTextColor,
                                [UIColor colorWithWhite:1.0 alpha:0.8], UITextAttributeTextShadowColor,
                                [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                nil];
    
    NSDictionary *attributesHighlighted = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIColor whiteColor], UITextAttributeTextColor,
                                           [UIColor colorWithWhite:0 alpha:0.8], UITextAttributeTextShadowColor,
                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                           nil];
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:attributes
                                                                                            forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:attributesHighlighted
                                                                                            forState:UIControlStateHighlighted];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    
    
    
    
    // Swipe to right will appear reveal view
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showLeft)];
    
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeRight];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.refreshHeaderView egoRefreshScrollViewDataSourceStartManualLoading:self.tableView];
    [self getData];
    
//    CCSideViewController *sideView = [[CCSideViewController alloc] init];
//    [self.revealSideViewController preloadViewController:sideView forSide:PPRevealSideDirectionLeft];

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:NO];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
    [self getData];
    self.isLoading = YES;
}

- (void)doneLoadingTableViewData
{
    self.isLoading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.tableView reloadData];
}


#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}



#pragma mark - EGO Refresh Table Header View Delegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return self.isLoading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}


@end
