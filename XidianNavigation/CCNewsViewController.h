//
//  CCNewsViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-3-17.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMainTableViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface CCNewsViewController : CCMainTableViewController <EGORefreshTableHeaderDelegate>

@property (strong, nonatomic) NSMutableArray *newsData;
//@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
//@property BOOL isLoading;
//@property (strong, nonatomic) NSString *firstTimetoRefresh;
//
//- (void)reloadTableViewDataSource;
//- (void)doneLoadingTableViewData;

@end
