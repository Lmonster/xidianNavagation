//
//  CCTelViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-3-20.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CCTelViewController.h"
#import "CCTelDetailViewController.h"
#import "CCTelSearchViewController.h"
#import "CCFeedbackViewController.h"

@interface CCTelViewController ()
- (void)switchToSearchView;
@end

@implementation CCTelViewController

@synthesize datalist, cellContentKeys, cellContentValues, commonlist;

- (void)switchToSearchView
{
    CCTelSearchViewController *searchViewController = [[CCTelSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)getData
{
    [ApplicationDelegate.telEngine getJSONFrom:@"ios/tel.php"
                             completionHandler:^(id InfoTitles) {
                                 
                                 self.datalist = InfoTitles;
                                 
                                 self.cellContentKeys = [self.datalist allKeys];
                                 self.cellContentValues = [self.datalist allValues];
                                 
                                 [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.2f];
                                 
                             } errorHandler:^(NSError *error) {
                                 [self doneLoadingTableViewData];
                                 [self showNetworkErrorNotifier];
                             }];
    
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
    
    self.title = @"电话查询";
    
    NSURL *urlForCommonPlist = [[NSBundle mainBundle] URLForResource:@"CommonTelNumbers" withExtension:@"plist"];
    self.commonlist = [NSDictionary dictionaryWithContentsOfURL:urlForCommonPlist];
    
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"navbar_tel_search", kPNGFileType)] style:UIBarButtonItemStylePlain target:self action:@selector(switchToSearchView)];
    //    UIImage *searchImage = [UIImage imageWithContentsOfFile:PathInMainBundle(@"nav_search", kPNGFileType)];
    //    UIButton *searchbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, searchImage.size.width, searchImage.size.height)];
    //    [searchbtn setBackgroundImage:searchImage forState:UIControlStateNormal];
    //
    ////    searchbtn.imageView.image = [UIImage imageWithContentsOfFile:PathInMainBundle(@"nav_search", kPNGFileType)];
    //    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)searchbtn];
    
    self.navigationItem.rightBarButtonItem = searchButton;
    
    self.tableView.separatorColor = [UIColor colorWithHexColor:@"#3ba3d0" alpha:.4];
    self.tableView.scrollsToTop = YES;
    
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
    return [self.cellContentKeys count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [[self.commonlist allKeys] count];
    }
    
    return [[self.cellContentValues objectAtIndex:section - 1] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *indexTitles = [[NSMutableArray alloc] initWithCapacity:[self.cellContentKeys count]];
    
    for (id key in self.cellContentKeys) {
        NSString *string = [[key substringToIndex:2] copy];
        [indexTitles addObject:string];
    }
    [indexTitles insertObject:@"常用" atIndex:0];
    
    return indexTitles;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"常用电话";
//    }
//
//    return [self.cellContentKeys objectAtIndex:section - 1];
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [[self.commonlist allKeys] objectAtIndex:indexPath.row];
    } else
        cell.textLabel.text = [[[self.cellContentValues objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row] objectForKey:@"Dname"];
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumFontSize = 8.0f;
    cell.textLabel.textColor = [UIColor colorWithWhite:.2 alpha:1];
    
    cell.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1];
    
//    UIColor *whiteColor = [UIColor whiteColor];
//    CGSize shadowOffset = CGSizeMake(0, 1);
//    
//    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], nil] setShadowColor:whiteColor];
//    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], nil] setShadowOffset:shadowOffset];
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    CCTelDetailViewController *telDetail = [[CCTelDetailViewController alloc] init];
    
    if (indexPath.section == 0) {
        NSDictionary *cellCommon = [[self.commonlist allValues] objectAtIndex:indexPath.row];
        telDetail.commonlist = cellCommon;
        
        telDetail.Dname = [[self.commonlist allKeys] objectAtIndex:indexPath.row];
        
    } else {
        NSDictionary *cellContent = [[self.cellContentValues objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
        
        telDetail.Dpid = [[cellContent objectForKey:@"Did"] integerValue];
        telDetail.Dname = [cellContent objectForKey:@"Dname"];
        telDetail.commonlist = nil;
        
    }
    
    [self.navigationController pushViewController:telDetail animated:YES];
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEWFRAMESIZE.width, 22)];
    headerView.backgroundColor = [UIColor colorWithRed:0 green:0.62 blue:0.88 alpha:1.0];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 22)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.4 alpha:1];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    titleLabel.text = (section == 0) ? @"常用电话" : [self.cellContentKeys objectAtIndex:section - 1];
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}


@end

