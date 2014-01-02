//
//  CCAcademiaViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-3-18.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCAcademiaViewController.h"

@interface CCAcademiaViewController ()
@end

@implementation CCAcademiaViewController

@synthesize academiaTitles, filePath, readFlags;

#pragma mark - Custom Actions

- (void)getData
{
    [ApplicationDelegate.academiaEngine getJSONFrom:@"wap/academiacontents.php"
                                  completionHandler:^(id InfoTitles) {
                                      
                                      self.academiaTitles = InfoTitles;
                                      [self performSelector:@selector(doneLoadingTableViewData)
                                                 withObject:nil afterDelay:0.2f];
                                      
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
    
    self.title = @"学术信息";
    
    NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *fileName = @"academiaReadFlags.plist";
    self.filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//alloc] init];
    
    if (![fileManager fileExistsAtPath:self.filePath]) {
        [fileManager createFileAtPath:self.filePath contents:nil attributes:nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"one", @"1", nil];
        [dic writeToFile:self.filePath atomically:YES];
    }
    
    self.readFlags = [NSMutableDictionary dictionaryWithContentsOfFile:self.filePath];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.readFlags writeToFile:self.filePath atomically:YES];
    [self viewWillDisappear:animated];
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
    return [self.academiaTitles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellContent = [self.academiaTitles objectAtIndex:indexPath.row];
    NSString *title = [cellContent objectForKey:@"title"];
    
    UIFont *font = [UIFont boldSystemFontOfSize:16.0f];
    CGSize constriant = CGSizeMake(VIEWFRAMESIZE.width - MARGIN * 4 - 35, 20000.0f);
    CGSize labelSize = [title sizeWithFont:font
                         constrainedToSize:constriant
                             lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + MARGIN * 2 + 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AcademiaCellIdentifier = @"AcademiaCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AcademiaCellIdentifier];
    
    UILabel *titleLabel = nil;
    UIImageView *titleImage = nil;
    //    UILabel *reporterLableL = nil;
    UIImageView *reporterImage = nil;
    UILabel *reporterLableR = nil;
    //    UILabel *timeLabelL = nil;
    UIImageView *timeImage = nil;
    UILabel *timeLabelR = nil;
    //    UILabel *placeLabelL = nil;
    UIImageView *placeImage = nil;
    UILabel *placeLabelR = nil;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AcademiaCellIdentifier];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.tag = 200;
        titleLabel.numberOfLines = 0;
        
        //        reporterLableL = [[UILabel alloc] initWithFrame:CGRectZero];
        //        reporterLableL.tag = 201;
        reporterImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        reporterImage.tag = 201;
        reporterLableR = [[UILabel alloc] initWithFrame:CGRectZero];
        reporterLableR.tag = 202;
        
        //        timeLabelL = [[UILabel alloc] initWithFrame:CGRectZero];
        //        timeLabelL.tag = 301;
        timeImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        timeImage.tag = 301;
        timeLabelR = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabelR.tag = 302;
        
        //        placeLabelL = [[UILabel alloc] initWithFrame:CGRectZero];
        //        placeLabelL.tag = 401;
        placeImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        placeImage.tag = 401;
        placeLabelR = [[UILabel alloc] initWithFrame:CGRectZero];
        placeLabelR.tag = 402;
        
        titleImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        titleImage.tag = 501;
        
    }
    
    //    if (!reporterLableL) {
    //        reporterLableL = (UILabel *)[cell viewWithTag:201];
    //    }
    if (!reporterImage) {
        reporterImage = (UIImageView *)[cell viewWithTag:201];
    }
    if (!reporterLableR) {
        reporterLableR = (UILabel *)[cell viewWithTag:202];
    }
    //    if (!timeLabelL) {
    //        timeLabelL = (UILabel *)[cell viewWithTag:301];
    //    }
    if (!timeImage) {
        timeImage = (UIImageView *)[cell viewWithTag:301];
    }
    if (!timeLabelR) {
        timeLabelR = (UILabel *)[cell viewWithTag:302];
    }
    //    if (!placeLabelL) {
    //        placeLabelL = (UILabel *)[cell viewWithTag:401];
    //    }
    if (!placeImage) {
        placeImage = (UIImageView *)[cell viewWithTag:401];
    }
    if (!placeLabelR) {
        placeLabelR = (UILabel *)[cell viewWithTag:402];
    }
    if (!titleImage) {
        titleImage = (UIImageView *)[cell viewWithTag:501];
    }
    if (!titleLabel) {
        titleLabel = (UILabel *)[cell viewWithTag:200];
    }
    
    
    
    // Configure the cell...
    NSDictionary *cellContent = [self.academiaTitles objectAtIndex:indexPath.row];
    
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    UIColor *color = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:1];
    UIColor *clearColor = [UIColor clearColor];
    UIColor *whiteColor = [UIColor whiteColor];
    CGSize shadowOffset = CGSizeMake(0, 1);
    
    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], [CCAcademiaViewController class], nil] setShadowColor:whiteColor];
    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], [CCAcademiaViewController class], nil] setShadowOffset:shadowOffset];
    
    NSString *title = [cellContent objectForKey:@"title"];
    UIFont *titleFont = [UIFont boldSystemFontOfSize:16.0f];
    CGSize constriant = CGSizeMake(VIEWFRAMESIZE.width - MARGIN * 4 - 35, 20000.0f);
    CGSize labelSize = [title sizeWithFont:titleFont
                         constrainedToSize:constriant
                             lineBreakMode:UILineBreakModeWordWrap];
    
    titleLabel.frame = CGRectMake(MARGIN + 35, MARGIN, labelSize.width, labelSize.height);
    titleLabel.text = title;
    titleLabel.font = titleFont;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithHexColor:@"#000000" alpha:1];
    
    
    //    reporterLableL.frame = CGRectMake(MARGIN, labelSize.height + MARGIN * 2, 80, 20);
    //    reporterLableL.font = font;
    //    reporterLableL.text = @"主讲人：";
    //    reporterLableL.textColor = [UIColor grayColor];
    //    reporterLableL.textAlignment = UITextAlignmentRight;
    reporterImage.frame = CGRectMake(MARGIN * 4, labelSize.height + MARGIN * 2, 17, 17);
    reporterImage.image = [UIImage imageWithContentsOfFile:PathInMainBundle(@"academia_cell_reporter", kPNGFileType)];
    
    reporterLableR.frame = CGRectMake(MARGIN + 50, labelSize.height + MARGIN * 2, VIEWFRAMESIZE.width - 80, 20);
    reporterLableR.font = font;
    reporterLableR.text = [cellContent objectForKey:@"reporter"];
    reporterLableR.textColor = color;
    reporterLableR.backgroundColor = clearColor;
    
    
    //    timeLabelL.frame = CGRectMake(MARGIN, labelSize.height + MARGIN * 2 + 20, 80, 20);
    //    timeLabelL.font = font;
    //    timeLabelL.text = @"讲座时间：";
    //    timeLabelL.textColor = [UIColor grayColor];
    //    timeLabelL.textAlignment = UITextAlignmentRight;
    timeImage.frame = CGRectMake(MARGIN * 4, labelSize.height + MARGIN * 2 + 20, 17, 17);
    timeImage.image = [UIImage imageWithContentsOfFile:PathInMainBundle(@"academia_cell_time", kPNGFileType)];
    
    timeLabelR.frame = CGRectMake(MARGIN + 50, labelSize.height + MARGIN * 2 + 20, VIEWFRAMESIZE.width - 80, 20);
    timeLabelR.font = font;
    timeLabelR.text = [cellContent objectForKey:@"time"];
    timeLabelR.textColor = color;
    timeLabelR.backgroundColor = clearColor;
    
    
    //    placeLabelL.frame = CGRectMake(MARGIN, labelSize.height + MARGIN * 2 + 40, 80, 20);
    //    placeLabelL.font = font;
    //    placeLabelL.text = @"地点：";
    //    placeLabelL.textColor = [UIColor grayColor];
    //    placeLabelL.textAlignment = UITextAlignmentRight;
    placeImage.frame = CGRectMake(MARGIN * 4, labelSize.height + MARGIN * 2 + 40, 17, 17);
    placeImage.image = [UIImage imageWithContentsOfFile:PathInMainBundle(@"academia_cell_place", kPNGFileType)];
    
    placeLabelR.frame = CGRectMake(MARGIN + 50, labelSize.height + MARGIN * 2 + 40, VIEWFRAMESIZE.width - 80, 20);
    placeLabelR.font = font;
    placeLabelR.text = [cellContent objectForKey:@"place"];
    placeLabelR.textColor = color;
    placeLabelR.backgroundColor = clearColor;
    
    
    titleImage.frame = CGRectMake(5, labelSize.height / 2 - 8, 35, 35);
    if ([[self.readFlags objectForKey:[cellContent objectForKey:@"title"]] intValue]) {
        titleImage.image = [UIImage imageWithContentsOfFile:PathInMainBundle(@"academia_cell_title_readed", kPNGFileType)];
    } else {
        titleImage.image = [UIImage imageWithContentsOfFile:PathInMainBundle(@"academia_cell_title_unread", kPNGFileType)];
    }
    
    
    [cell.contentView addSubview:titleImage];
    [cell.contentView addSubview:titleLabel];
    //    [cell.contentView addSubview:reporterLableL];
    [cell.contentView addSubview:reporterImage];
    [cell.contentView addSubview:reporterLableR];
    //    [cell.contentView addSubview:timeLabelL];
    [cell.contentView addSubview:timeImage];
    [cell.contentView addSubview:timeLabelR];
    //    [cell.contentView addSubview:placeLabelL];
    [cell.contentView addSubview:placeImage];
    [cell.contentView addSubview:placeLabelR];
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = CGRectMake(0, 0, VIEWFRAMESIZE.width, labelSize.height + MARGIN * 2 + 62);
//    UIColor *topColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
//    UIColor *bottomColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
//    gradient.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
//    
//    UIView *bgView = [[UIView alloc] init];
//    [bgView.layer insertSublayer:gradient atIndex:0];
//    cell.backgroundView = bgView;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"table_cell_bg", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 20, 0)]];

    
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *cellContent = [self.academiaTitles objectAtIndex:indexPath.row];
    
    if ([ApplicationDelegate.academiaEngine isReachable]) {
        [self.readFlags setObject:[NSNumber numberWithInt:1] forKey:[cellContent objectForKey:@"title"]];
    }
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://meeting.xidian.edu.cn/wap/detail.php?id=%d",
                           [cellContent[@"id"] intValue]];
    
    CCWebViewController *webview = [[CCWebViewController alloc] initWithAddress:urlString];
    
    [self.navigationController pushViewController:webview animated:YES];
}

@end

