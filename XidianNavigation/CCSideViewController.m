//
//  CCSideViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-2-20.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCSideViewController.h"
#import "CCMainViewController.h"
#import "CCFeedbackViewController.h"
#import "CCSettingViewController.h"
#import "CCTelViewController.h"
#import "CCTelViewController.h"
//#import "CCCurriculumSelectViewController.h"
//#import "CCCurriculumStudentViewController.h"
//#import "CCCurriculumTeacherViewController.h"
#import "CCNewsViewController.h"
#import "CCRecuitmentViewController.h"
#import "CCAcademiaViewController.h"
#import "CCSinaWeiboViewController.h"
#import "CCLostAndFindViewController.h"

@interface CCSideViewController ()

- (void)showFeedbackView;
- (void)showSettingView;

@end

@implementation CCSideViewController

@synthesize table, toolbar, settingBarButton, feedbackBarButton;
@synthesize list, selectedIndexpath;



#pragma mark - Custom Methods

- (void)showFeedbackView
{
//    CCFeedbackViewController *feedbackViewController = [[CCFeedbackViewController alloc] initWithNibName:@"CCFeedbackViewController" bundle:nil];
    SVModalWebViewController *feedbackViewController = [[SVModalWebViewController alloc] initWithAddress:@"http://www.xidian.cc/app/plus/guestbook.php"];
    feedbackViewController.title = @"意见反馈";
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    feedbackViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:feedbackViewController animated:YES completion:nil];
}

- (void)showSettingView
{
    CCSettingViewController *settingViewController = [[CCSettingViewController alloc] initWithNibName:@"CCSettingViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}



#pragma mark - Application LifeCycle Methods

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
    
    //    UIImageView *tableHeaderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top-logo.png"]];
    UIImageView *tableHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, -100, 200, 90)];
    tableHeaderImage.image = [UIImage imageWithContentsOfFile:PathInMainBundle(@"sidebar_top_logo", kPNGFileType)];
    [self.table addSubview:tableHeaderImage];
    
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.table setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"sidebar_bg", kPNGFileType)]]];
    
    [self.toolbar setBackgroundImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"sidebar_footer_bg", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 2, 0)] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self.feedbackBarButton setBackgroundImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"SidebarToolbarButton", kPNGFileType)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.feedbackBarButton setBackgroundImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"SidebarToolbarButtonHighlighted", kPNGFileType)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    UIImageView *feedbackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 25, 25)];
    feedbackImageView.image = [UIImage imageWithContentsOfFile:PathInMainBundle(@"sidebar_feedback", kPNGFileType)];
    [self.toolbar addSubview:feedbackImageView];
    
    [self.settingBarButton setBackgroundImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"SidebarToolbarButton", kPNGFileType)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.settingBarButton setBackgroundImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"SidebarToolbarButtonHighlighted", kPNGFileType)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    UIImageView *settingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(136, 10, 25, 25)];
    settingImageView.image = [UIImage imageWithContentsOfFile:PathInMainBundle(@"sidebar_setting", kPNGFileType)];
    [self.toolbar addSubview:settingImageView];
    
    [self.feedbackBarButton setAction:@selector(showFeedbackView)];
    [self.settingBarButton setAction:@selector(showSettingView)];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int selectedRow = [defaults integerForKey:@"selectedRow"];
    int selectedSection = [defaults integerForKey:@"selectedSection"];
    [self.table selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:selectedSection]
                            animated:NO
                      scrollPosition:UITableViewScrollPositionNone];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return XDTotalCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"sidebar_cell_bg", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 0, 1.0, 0)]];
        
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"sidebar_cell_bg_selected", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 0, 1.0, 0)]];
    }
    
    // Configure the cell...
    [cell.textLabel setTextColor:[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1.0]];
    [cell.textLabel setShadowColor:[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0]];
    [cell.textLabel setShadowOffset:CGSizeMake(0, 1)];
    
    switch (indexPath.row) {
            
        case XDIndexPage:
            cell.textLabel.text = @"首页";
            break;
            
        case XDTimeIndex:
            cell.textLabel.text = @"西电时间";
            break;
            
        case XDTelephoneIndex:
            cell.textLabel.text = @"西电电话";
            break;
            
        case XDCurriculumScheduleIndex:
            cell.textLabel.text = @"西电课表";
            break;
            
        case XDNewsIndex:
            cell.textLabel.text = @"西电新闻";
            break;
            
        case XDTeacherPagesIndex:
            cell.textLabel.text = @"教师主页";
            break;
            
        case XDRecuitmentIndex:
            cell.textLabel.text = @"西电招聘";
            break;
            
        case XDAcademiaIndex:
            cell.textLabel.text = @"学术报告";
            break;
            
        case XDSinaWeiboIndex:
            cell.textLabel.text = @"微博广场";
            break;
            
        case XDLostAndFindIndex:
            cell.textLabel.text = @"失物招领";
            break;
            
        case XDCEERIndex:
            cell.textLabel.text = @"高考录取";
            break;
            
        case XDWelcomeNewbieIndex:
            cell.textLabel.text = @"新生指南";
            break;
            
        case XDMapIndex:
            cell.textLabel.text = @"西电地图";
            break;
            
        default:
            break;
    }
    
    NSArray *cellImageArray = [NSArray arrayWithObjects:@"side_cell_time", @"side_cell_tel", @"side_cell_curriculum", @"side_cell_news", @"side_cell_teacher", @"side_cell_recuitment", @"side_cell_academia", @"side_cell_welcomenewbie", @"side_cell_map", @"side_cell_ceer",  @"side_cell_weibo", @"side_cell_lostandfound", nil];
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageWithContentsOfFile:PathInMainBundle(@"sidebar_posts", kPNGFileType)];
    }
    else {
        cell.imageView.image = [UIImage imageWithContentsOfFile:PathInMainBundle([cellImageArray objectAtIndex:indexPath.row - 1], kPNGFileType)];
    }
    
    return cell;
}


#pragma mark - Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 48.0;
    }
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger oldSelectedRow = [defaults integerForKey:@"selectedRow"];
    
    if (oldSelectedRow != indexPath.row) {
        
        [defaults setInteger:indexPath.section forKey:@"selectedSection"];
        [defaults setInteger:indexPath.row forKey:@"selectedRow"];
        [defaults synchronize];
        
        switch (indexPath.row) {
                
            case XDIndexPage:
            {
                [ApplicationDelegate.globalNavController popToRootViewControllerAnimated:NO];
                [self.revealSideViewController popViewControllerAnimated:YES];
                
                break;
            }
                
            case XDTimeIndex:
            {
                SVWebViewController *webView = [[SVWebViewController alloc] initWithAddress:@"http://time.xidian.cc"];
                
                [ApplicationDelegate.globalNavController popToRootViewControllerAnimated:NO];
                [ApplicationDelegate.globalNavController pushViewController:webView animated:NO];
                
                [self.revealSideViewController popViewControllerAnimated:YES];
                
                break;
            }
                
            case XDTelephoneIndex:
            {
                CCTelViewController *telView = [[CCTelViewController alloc] initWithNibName:@"CCTelViewController" bundle:nil];
                [ApplicationDelegate.globalNavController popToRootViewControllerAnimated:NO];
                [ApplicationDelegate.globalNavController pushViewController:telView animated:NO];
                
                [self.revealSideViewController popViewControllerAnimated:YES];
                
                break;
            }
                
            case XDCurriculumScheduleIndex:
            {
                SVWebViewController *webView = [[SVWebViewController alloc] initWithAddress:@"http://kb.xidian.cc/m/index.php"];
                [ApplicationDelegate.globalNavController popToRootViewControllerAnimated:NO];
                [ApplicationDelegate.globalNavController pushViewController:webView animated:NO];
                
                [self.revealSideViewController popViewControllerAnimated:YES];

//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                id viewController = nil;
//                NSString *value = [defaults objectForKey:@"curriculumClassNumberOrTeacherName"];
//                if ([value intValue]) {
//                    viewController = [[CCCurriculumStudentViewController alloc] init];
//                } else if (value.length > 1 && value.length < 6) {
//                    viewController = [[CCCurriculumTeacherViewController alloc] init];
//                } else {
//                    viewController = [[CCCurriculumSelectViewController alloc] initWithNibName:@"CCCurriculumSelectViewController" bundle:nil];
//                }
//
//                [ApplicationDelegate.globalNavController popToRootViewControllerAnimated:NO];
//                [ApplicationDelegate.globalNavController pushViewController:viewController animated:NO];
//                
//                [self.revealSideViewController popViewControllerAnimated:YES];
                
                break;
            }
                
            case XDNewsIndex:
            {
                CCNewsViewController *news = [[CCNewsViewController alloc] initWithNibName:@"CCNewsViewController" bundle:nil];
                
                [ApplicationDelegate.globalNavController popToRootViewControllerAnimated:NO];
                [ApplicationDelegate.globalNavController pushViewController:news animated:NO];
                
                [self.revealSideViewController popViewControllerAnimated:YES];
                
                break;
            }
                
            case XDTeacherPagesIndex:
            {
                SVWebViewController *webView = [[SVWebViewController alloc] initWithAddress:@"http://web.xidian.edu.cn/wap/"];
                [ApplicationDelegate.globalNavController popToRootViewControllerAnimated:NO];
                [ApplicationDelegate.globalNavController pushViewController:webView animated:NO];
                
                [self.revealSideViewController popViewControllerAnimated:YES];
                
                break;
            }
                
            case XDRecuitmentIndex:
            {
                CCRecuitmentViewController *recuitmentView = [[CCRecuitmentViewController alloc] initWithNibName:@"CCRecuitmentViewController" bundle:nil];
                [ApplicationDelegate.globalNavController popToRootViewControllerAnimated:NO];
                [ApplicationDelegate.globalNavController pushViewController:recuitmentView animated:NO];
                
                [self.revealSideViewController popViewControllerAnimated:YES];
                
                break;
            }
                
            case XDAcademiaIndex:
            {
                CCAcademiaViewController *academiaView = [[CCAcademiaViewController alloc] initWithNibName:@"CCAcademiaViewController" bundle:nil];
                [ApplicationDelegate.globalNavController popToRootViewControllerAnimated:NO];
                [ApplicationDelegate.globalNavController pushViewController:academiaView animated:NO];
                
                [self.revealSideViewController popViewControllerAnimated:YES];
                
                break;
            }
                
            case XDSinaWeiboIndex:
            {
                CCSinaWeiboViewController *weiboView = [[CCSinaWeiboViewController alloc] initWithNibName:@"CCSinaWeiboViewController" bundle:nil];
                [ApplicationDelegate.globalNavController popToRootViewControllerAnimated:NO];
                [ApplicationDelegate.globalNavController pushViewController:weiboView animated:NO];
                
                [self.revealSideViewController popViewControllerAnimated:YES];
                break;
            }
                
            case XDLostAndFindIndex:
            {
                CCLostAndFindViewController *lost = [[CCLostAndFindViewController alloc] init];
                [ApplicationDelegate.globalNavController popToRootViewControllerAnimated:NO];
                [ApplicationDelegate.globalNavController pushViewController:lost animated:NO];
                
                [self.revealSideViewController popViewControllerAnimated:YES];
                break;
            }
                
            case XDCEERIndex:
            {
                CCWebViewController *webView = [[CCWebViewController alloc] initWithAddress:@"http://www.xidian.cc/app/all2013/2013query.html"];
                [ApplicationDelegate.globalNavController popToRootViewControllerAnimated:NO];
                [ApplicationDelegate.globalNavController pushViewController:webView animated:NO];
                
                [self.revealSideViewController popViewControllerAnimated:YES];
                break;
            }
                
            case XDWelcomeNewbieIndex:
            {
                SVWebViewController *webView = [[SVWebViewController alloc] initWithAddress:@"http://new.xidian.cc/m"];
                [ApplicationDelegate.globalNavController popToRootViewControllerAnimated:NO];
                [ApplicationDelegate.globalNavController pushViewController:webView animated:NO];
                
                [self.revealSideViewController popViewControllerAnimated:YES];
                break;
            }
                
            case XDMapIndex:
            {
                SVWebViewController *webView = [[SVWebViewController alloc] initWithAddress:@"http://map.xidian.cc/m"];
                [ApplicationDelegate.globalNavController popToRootViewControllerAnimated:NO];
                [ApplicationDelegate.globalNavController pushViewController:webView animated:NO];
                
                [self.revealSideViewController popViewControllerAnimated:YES];
                break;
            }
                
            default:
                break;
        }
    } else {
        [self.revealSideViewController popViewControllerAnimated:YES];
    }
}


@end

