//
//  CCNewsViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-3-17.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCNewsViewController.h"

@interface CCNewsViewController ()
- (void)clearCache;
@end

@implementation CCNewsViewController

@synthesize newsData, refreshHeaderView, isLoading;

#pragma mark - Custom Actions

- (void)clearCache
{
    [ApplicationDelegate.newsEngine emptyCache];
    self.newsData = nil;
    [self.tableView reloadData];
    
    [[[UIAlertView alloc] initWithTitle:@"缓存已经清理完毕" message:nil delegate:nil cancelButtonTitle:@"OKay" otherButtonTitles:nil, nil] show];
}


- (void)getData
{
    [ApplicationDelegate.newsEngine getJSONFrom:@"ios/newstitles.php"
                              completionHandler:^(id newsTitles) {
                                  
                                  self.newsData = newsTitles;
                                  [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.2f];
                                  
                              } errorHandler:^(NSError *error) {
                                  
                                  [self doneLoadingTableViewData];
                                  [self showNetworkErrorNotifier];
                                  
                              }];
    
}



#pragma mark - View Lifecycles

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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = @"新闻列表";
        
    if ([ApplicationDelegate.newsEngine isReachable]) {
        [self.refreshHeaderView refreshLastUpdatedDate];
    }
        
    
//    UIBarButtonItem *clearCacheButton = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存" style:UIBarButtonItemStyleBordered target:self action:@selector(clearCache)];
//    
//    self.navigationItem.rightBarButtonItem = clearCacheButton;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.newsData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NewsCellIdentifier = @"NewsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NewsCellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *cellContent = [self.newsData objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.text = [cellContent objectForKey:@"title"];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 来自:%@",
                                 cellContent[@"pubdate"],
                                 cellContent[@"source"]];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageWithContentsOfFile:PathInMainBundle(@"news_cell_image", kPNGFileType)];
    
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = CGRectMake(0, 0, VIEWFRAMESIZE.width, 90);
//    UIColor *topColor = [UIColor colorWithRed:.93 green:.93 blue:.93 alpha:1];
//    UIColor *bottomColor = [UIColor colorWithRed:.8 green:0.8 blue:0.8 alpha:1];
//    gradient.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
//    
//    UIView *bgView = [[UIView alloc] init];
//    [bgView.layer insertSublayer:gradient atIndex:0];
//    cell.backgroundView = bgView;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"table_cell_bg", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 0, 25, 0)]];

    
    
    UIColor *whiteColor = [UIColor whiteColor];
    CGSize shadowOffset = CGSizeMake(0, 1);
    
    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], [CCNewsViewController class], nil] setShadowColor:whiteColor];
    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], [CCNewsViewController class], nil] setShadowOffset:shadowOffset];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *newsURLString = [NSString stringWithFormat:@"http://news.xidian.cc/ios/newsdetail.php?id=%d",
                               [((self.newsData)[indexPath.row])[@"id"] intValue]];
    CCWebViewController *newsDetail = [[CCWebViewController alloc] initWithAddress:newsURLString];
    
    [self.navigationController pushViewController:newsDetail animated:YES];
}


//#pragma mark - Data Source Loading / Reloading Methods
//
//- (void)reloadTableViewDataSource
//{
//    [self refreshData];
//    self.isLoading = YES;
//}
//
//- (void)doneLoadingTableViewData
//{
//    self.isLoading = NO;
//    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
//    [self.tableView reloadData];
//}
//
//- (void)showRefreshHeaderViewAtStart
//{
//    [self.refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
//    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
//}
//
//
//#pragma mark - Scroll View Delegate Methods
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
//}
//
//
//
//#pragma mark - EGO Refresh Table Header View Delegate Methods
//
//- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
//{
//    [self reloadTableViewDataSource];
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
//}
//
//- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
//{
//    return self.isLoading;
//}
//
//- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
//{
//    return [NSDate date];
//}
//
//


@end
