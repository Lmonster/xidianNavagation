//
//  CCRecuitmentViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-3-19.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCRecuitmentViewController.h"
#import "SVWebViewController.h"

@interface CCRecuitmentViewController ()
- (IBAction)segmentValueChanged:(id)sender;
@end

@implementation CCRecuitmentViewController

@synthesize datalist, selectedSegmentIndex, callbackPaths;
@synthesize segmentedControl;

#pragma mark - Custom Actions

- (IBAction)segmentValueChanged:(id)sender
{
    self.selectedSegmentIndex = ((UISegmentedControl *)sender).selectedSegmentIndex;
    
    // update title and restart baidu statistics
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
    self.title = self.segmentItems[self.selectedSegmentIndex];
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
    
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect newframe = self.view.frame;
        newframe.origin.y = - self.view.frame.size.height;
        self.view.frame = newframe;
    } completion:^(BOOL finished){
        self.datalist = nil;
        [self.tableView reloadData];
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect oldframe = self.view.frame;
            oldframe.origin.y = GTE_IOS7 ? 64 : 0;
            self.view.frame = oldframe;
        } completion:^(BOOL finished){
//            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                CGRect anotherframe = self.view.frame;
//                anotherframe.origin.y = 0;
//                self.view.frame = anotherframe;
//            } completion:^(BOOL finished){
                [self.refreshHeaderView egoRefreshScrollViewDataSourceStartManualLoading:self.tableView];
//            }];
        }];
    }];
    
    
    
}

- (void)getData
{
    [ApplicationDelegate.recuitmentEngine getJSONFrom:[self.callbackPaths objectAtIndex:self.selectedSegmentIndex]
                                    completionHandler:^(NSMutableArray *InfoTitles) {
                                        
                                        self.datalist = InfoTitles;
                                        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5f];
                                        
                                    } errorHandler:^(NSError *error) {
                                        
                                        [self doneLoadingTableViewData];
                                        [self showNetworkErrorNotifier];
                                        
                                    }];
    
}


#pragma mark - View Lifecycle

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.callbackPaths = [NSArray arrayWithObjects:@"ios/south.php", @"ios/wap.php", @"ios/north.php", nil];
    
    self.segmentItems = [NSArray arrayWithObjects:@"南校区", @"全部", @"北校区", nil];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:self.segmentItems];
    self.segmentedControl.frame = CGRectMake(0, 0, 200, 30);
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    if (GTE_IOS7) {
        self.segmentedControl.tintColor = [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:1.0];
    } else {
        self.segmentedControl.tintColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1.0];
    }
    [self.segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    id lastSelection = [[NSUserDefaults standardUserDefaults] valueForKey:@"CCRecuitmentLastSelected"];
    if (lastSelection != nil) {
        self.selectedSegmentIndex = [lastSelection intValue];
        self.segmentedControl.selectedSegmentIndex = [lastSelection intValue];
    } else {
        self.selectedSegmentIndex = kRecuitmentTotalIndex;
        self.segmentedControl.selectedSegmentIndex = kRecuitmentTotalIndex;
    }
    self.navigationItem.titleView = self.segmentedControl;
    self.title = self.segmentItems[self.selectedSegmentIndex];
    
    
    
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
    
    
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.segmentedControl setTitleTextAttributes:attributesHighlighted forState:UIControlStateHighlighted];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithInteger:self.selectedSegmentIndex] forKey:@"CCRecuitmentLastSelected"];
    [defaults synchronize];
    
    [super viewWillDisappear:animated];
    
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
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
    return [self.datalist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *text = nil;
    if (self.selectedSegmentIndex == kRecuitmentTotalIndex) {
        text = [[self.datalist objectAtIndex:indexPath.row] objectForKey:@"title"];
    } else {
        text = [[self.datalist objectAtIndex:indexPath.row] objectForKey:@"arrangecompany"];
        
    }
    UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
    CGSize constriant = CGSizeMake(VIEWFRAMESIZE.width - MARGIN * 4, 20000.0f);
    CGSize size = [text sizeWithFont:font constrainedToSize:constriant lineBreakMode:UILineBreakModeWordWrap];
    if (self.selectedSegmentIndex == kRecuitmentTotalIndex) {
        return size.height + MARGIN * 3 + 20;
    } else {
        return size.height + MARGIN * 3 + 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TotalCellIdentifier = @"RecuitmentTotalCell";
    static NSString *NorthCellIdnetifier = @"RecuitmentNorthCell";
    static NSString *SouthCellIdentifier = @"RecuitmentSouthCell";
    static NSString *CellIdentifier = nil;
    
    
    
    switch (self.selectedSegmentIndex) {
        case kRecuitmentTotalIndex:
            CellIdentifier = TotalCellIdentifier;
            break;
            
        case kRecuitmentNorthIndex:
            CellIdentifier = NorthCellIdnetifier;
            break;
            
        case kRecuitmentSouthIndex:
            CellIdentifier = SouthCellIdentifier;
            break;
            
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *titleLabel, *dateLabel, *timeLabel, *placeLabel;
    NSDictionary *cellContent = [self.datalist objectAtIndex:indexPath.row];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.tag = kTitleTag;
        titleLabel.numberOfLines = 0;
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        dateLabel.tag = kDateTag;
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel.tag = kTimeTag;
        
        placeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        placeLabel.tag = kPlaceTag;
        
    } else {
        titleLabel = (UILabel *)[cell.contentView viewWithTag:kTitleTag];
        dateLabel = (UILabel *)[cell.contentView viewWithTag:kDateTag];
        timeLabel = (UILabel *)[cell.contentView viewWithTag:kTimeTag];
        placeLabel = (UILabel *)[cell.contentView viewWithTag:kPlaceTag];
    }
    
    switch (self.selectedSegmentIndex) {
        case kRecuitmentTotalIndex:
        {
            
            NSString *titleLabelText = [cellContent objectForKey:@"title"];
            UIFont *titleFont = [UIFont boldSystemFontOfSize:18.0f];
            CGSize constriant = CGSizeMake(VIEWFRAMESIZE.width - MARGIN * 4, 20000.0f);
            CGSize labelSize = [titleLabelText sizeWithFont:titleFont constrainedToSize:constriant lineBreakMode:UILineBreakModeWordWrap];
            titleLabel.frame = CGRectMake(MARGIN, MARGIN, labelSize.width, labelSize.height);
            titleLabel.text = titleLabelText;
            titleLabel.font = titleFont;
            [cell.contentView addSubview:titleLabel];
            
            NSString *dateLabelText = [NSString stringWithFormat:@"发布日期：%@", [cellContent objectForKey:@"pubdate"]];
            UIFont *dateFont = [UIFont systemFontOfSize:14.0f];
            dateLabel.frame = CGRectMake(MARGIN, labelSize.height + MARGIN * 2 , VIEWFRAMESIZE.width - 40, 20);
            dateLabel.text = dateLabelText;
            dateLabel.textAlignment = UITextAlignmentRight;
            dateLabel.textColor = [UIColor darkGrayColor];
            dateLabel.font = dateFont;
            [cell.contentView addSubview:dateLabel];
            
//            CAGradientLayer *gradient = [CAGradientLayer layer];
//            gradient.frame = CGRectMake(0, 0, VIEWFRAMESIZE.width, labelSize.height + MARGIN * 3 + 20);
//            UIColor *topColor = [UIColor colorWithRed:.93 green:.93 blue:.93 alpha:1];
//            UIColor *bottomColor = [UIColor colorWithRed:.8 green:0.8 blue:0.8 alpha:1];
//            gradient.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
//            
//            UIView *bgView = [[UIView alloc] init];
//            [bgView.layer insertSublayer:gradient atIndex:0];
//            cell.backgroundView = bgView;
//            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"table_cell_bg", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 20, 0)]];

            
            break;
        }
        case kRecuitmentNorthIndex:
        {
            NSString *titleLabelText = [cellContent objectForKey:@"arrangecompany"];
            UIFont *titleFont = [UIFont boldSystemFontOfSize:18.0f];
            CGSize constriant = CGSizeMake(VIEWFRAMESIZE.width - MARGIN * 4, 20000.0f);
            CGSize labelSize = [titleLabelText sizeWithFont:titleFont constrainedToSize:constriant lineBreakMode:UILineBreakModeWordWrap];
            titleLabel.frame = CGRectMake(MARGIN, MARGIN, labelSize.width, labelSize.height);
            titleLabel.text = titleLabelText;
            titleLabel.font = titleFont;
            [cell.contentView addSubview:titleLabel];
            
            NSString *dateLabelText = [NSString stringWithFormat:@"时间：%@ %@", [cellContent objectForKey:@"orderid"], [cellContent objectForKey:@"arrangetime"]];
            UIFont *dateFont = [UIFont systemFontOfSize:14.0f];
            dateLabel.frame = CGRectMake(MARGIN, labelSize.height + MARGIN * 2 , VIEWFRAMESIZE.width - 40, 20);
            dateLabel.text = dateLabelText;
            dateLabel.textAlignment = UITextAlignmentLeft;
            dateLabel.textColor = [UIColor darkGrayColor];
            dateLabel.font = dateFont;
            [cell.contentView addSubview:dateLabel];
            
            NSString *placeLabelText = [NSString stringWithFormat:@"地点：%@", [cellContent objectForKey:@"arrangeaddress"]];
            placeLabel.font = dateFont;
            placeLabel.frame = CGRectMake(MARGIN, labelSize.height + MARGIN * 2 + 20, VIEWFRAMESIZE.width - 40, 20);
            placeLabel.textAlignment = UITextAlignmentLeft;
            placeLabel.textColor = [UIColor darkGrayColor];
            placeLabel.text = placeLabelText;
            [cell.contentView addSubview:placeLabel];
            
//            CAGradientLayer *gradient = [CAGradientLayer layer];
//            gradient.frame = CGRectMake(0, 0, VIEWFRAMESIZE.width, labelSize.height + MARGIN * 3 + 40);
//            UIColor *topColor = [UIColor colorWithRed:.93 green:.93 blue:.93 alpha:1];
//            UIColor *bottomColor = [UIColor colorWithRed:.8 green:0.8 blue:0.8 alpha:1];
//            gradient.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
//            
//            UIView *bgView = [[UIView alloc] init];
//            [bgView.layer insertSublayer:gradient atIndex:0];
//            cell.backgroundView = bgView;
//            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"table_cell_bg", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 20, 0)]];
            
            
            
            break;
        }
        case kRecuitmentSouthIndex:
        {
            NSString *titleLabelText = [cellContent objectForKey:@"arrangecompany"];
            UIFont *titleFont = [UIFont boldSystemFontOfSize:18.0f];
            CGSize constriant = CGSizeMake(VIEWFRAMESIZE.width - MARGIN * 4, 20000.0f);
            CGSize labelSize = [titleLabelText sizeWithFont:titleFont constrainedToSize:constriant lineBreakMode:UILineBreakModeWordWrap];
            titleLabel.frame = CGRectMake(MARGIN, MARGIN, labelSize.width, labelSize.height);
            titleLabel.text = titleLabelText;
            titleLabel.font = titleFont;
            [cell.contentView addSubview:titleLabel];
            
            NSString *dateLabelText = [NSString stringWithFormat:@"时间：%@ %@", [cellContent objectForKey:@"orderid"], [cellContent objectForKey:@"arrangetime"]];
            UIFont *dateFont = [UIFont systemFontOfSize:14.0f];
            dateLabel.frame = CGRectMake(MARGIN, labelSize.height + MARGIN * 2 , VIEWFRAMESIZE.width - 40, 20);
            dateLabel.text = dateLabelText;
            dateLabel.textAlignment = UITextAlignmentLeft;
            dateLabel.textColor = [UIColor darkGrayColor];
            dateLabel.font = dateFont;
            [cell.contentView addSubview:dateLabel];
            
            NSString *placeLabelText = [NSString stringWithFormat:@"地点：%@", [cellContent objectForKey:@"arrangeaddress"]];
            placeLabel.font = dateFont;
            placeLabel.frame = CGRectMake(MARGIN, labelSize.height + MARGIN * 2 + 20, VIEWFRAMESIZE.width - 40, 20);
            placeLabel.textAlignment = UITextAlignmentLeft;
            placeLabel.textColor = [UIColor darkGrayColor];
            placeLabel.text = placeLabelText;
            [cell.contentView addSubview:placeLabel];
            
//            CAGradientLayer *gradient = [CAGradientLayer layer];
//            gradient.frame = CGRectMake(0, 0, VIEWFRAMESIZE.width, labelSize.height + MARGIN * 3 + 40);
//            UIColor *topColor = [UIColor colorWithRed:.93 green:.93 blue:.93 alpha:1];
//            UIColor *bottomColor = [UIColor colorWithRed:.8 green:0.8 blue:0.8 alpha:1];
//            gradient.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
//            
//            UIView *bgView = [[UIView alloc] init];
//            [bgView.layer insertSublayer:gradient atIndex:0];
//            cell.backgroundView = bgView;
//            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"table_cell_bg", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 20, 0)]];


            
            break;
        }
        default:
            break;
    }
    
    //    static NSString *CellIdentifier = @"RecuitmentCell";
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //
    //    if (!cell) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //    }
    //
    //    // Configure the cell...
    //    if (self.selectedSegmentIndex == kRecuitmentTotalIndex) {
    //
    //        cell.textLabel.text = [[self.datalist objectAtIndex:indexPath.row] objectForKey:@"title"];
    //
    //    }
    //    else {
    //
    //        cell.textLabel.text = [[self.datalist objectAtIndex:indexPath.row] objectForKey:@"arrangecompany"];
    //
    //    }
    //            cell.detailTextLabel.text = [[self.datalist objectAtIndex:indexPath.row] objectForKey:@"pubdate"];
        
    
    UIColor *clearColor = [UIColor clearColor];
    UIColor *whiteColor = [UIColor whiteColor];
    CGSize shadowOffset = CGSizeMake(0, 1);
    
    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], [CCRecuitmentViewController class], nil] setShadowColor:whiteColor];
    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], [CCRecuitmentViewController class], nil] setShadowOffset:shadowOffset];
    titleLabel.backgroundColor = clearColor;
    placeLabel.backgroundColor = clearColor;
    timeLabel.backgroundColor = clearColor;
    dateLabel.backgroundColor = clearColor;
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"table_cell_bg", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 20, 0)]];


    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlString = [NSString stringWithFormat:@"http://job.xidian.edu.cn/jobinfo.php?id=%d",
                           [((self.datalist)[indexPath.row])[@"id"] intValue]];
    
    CCWebViewController *webview = [[CCWebViewController alloc] initWithAddress:urlString];
    
    [self.navigationController pushViewController:webview animated:YES];}


@end
