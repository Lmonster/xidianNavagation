//
//  CCMainTableViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-3-22.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCSideViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface CCMainTableViewController : UITableViewController <EGORefreshTableHeaderDelegate>

@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property BOOL isLoading;
@property (strong, nonatomic) NSString *firstTimetoRefresh;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)getData;
- (void)showLeft;
- (void)showNetworkErrorNotifier;

@end
