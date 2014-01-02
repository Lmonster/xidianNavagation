//
//  CCMainViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-3-6.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCMainViewController.h"
#import "CCTelViewController.h"
#import "CCNewsViewController.h"
#import "CCRecuitmentViewController.h"
#import "CCAcademiaViewController.h"
#import "CCCurriculumSelectViewController.h"
#import "CCCurriculumStudentViewController.h"
#import "CCCurriculumTeacherViewController.h"
#import "CCSinaWeiboViewController.h"
#import "CCLostAndFindViewController.h"
#import "CCAboutViewController.h"
#import "CCReachability.h"


@interface CCMainViewController ()

- (void)showLeftInMainView;

@end

@implementation CCMainViewController

@synthesize list, icons;
@synthesize reachability;

#pragma mark - Custom Methods

- (IBAction)aboutButtonPressed:(id)sender
{
    CCAboutViewController *about = [[CCAboutViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:about];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showNetworkErrorNotifier
{
    [BWStatusBarOverlay setAnimation:BWStatusBarOverlayAnimationTypeFromTop];
    [BWStatusBarOverlay showSuccessWithMessage:@"连接错误，请检查你的网络或稍后再试" duration:4.0 animated:YES];
}

- (void)showNetwrokRecoverNotifier
{
    [BWStatusBarOverlay setAnimation:BWStatusBarOverlayAnimationTypeFromTop];
    [BWStatusBarOverlay showSuccessWithMessage:@"网络恢复" duration:4.0 animated:YES];
}



#pragma mark - Application Lifecycle Methods

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
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    
    self.title = @"西电导航主页";
    
    
    // Define some Modules
    self.list = [NSArray arrayWithObjects:@"西电时间",
                 @"西电电话", @"西电课表", @"西电新闻", @"教师主页", @"西电招聘", @"学术报告", @"新生指南", @"西电地图", nil];
    
    self.icons = [NSArray arrayWithObjects:@"main_time",
                  @"main_tel", @"main_curriculum", @"main_news",
                  @"main_teacher", @"main_recuitment", @"main_academia", @"main_welcomenewbie", @"main_map", nil];
    
    for (int i=0; i<[self.icons count]; i++) {
        
        float positionX = 0, positionY = 0;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            positionX = i % 3 * 100 + 20;
            positionY = ((i / 3) == 0) ? 20 : (i / 3 * 100 + (i / 3 + 1) * 20);
        } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            positionX = i % 4 * 176 + 80;
            positionY = ((i / 4) == 0) ? 40 : (i / 4 * 100 + (i / 4 + 1) * 40);
        }
//        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(positionX, positionY, 80, 80)];
//        item.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:PathInMainBundle([self.icons objectAtIndex:i], kPNGFileType)]];
//        item.userInteractionEnabled = YES;
//        // For the Index Page at index:0
//        [item setTag:100 + i + 1];
//
//        // Set Actions
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushCorrespondingController:)];
//        [item addGestureRecognizer:tapGesture];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(positionX, positionY, 80, 80);
        [button setBackgroundImage:[UIImage imageWithContentsOfFile:PathInMainBundle([self.icons objectAtIndex:i], kPNGFileType)] forState:UIControlStateNormal];
        button.tag = 100 + i + 1;
        [button addTarget:self action:@selector(pushCorrespondingController:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];

        
//        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"CCCurrentThemeName"] isEqualToString:kThemeMetro]) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(positionX, positionY + 80, 80, 20)];
        label.tag = 200 + i + 1;
        label.text = [self.list objectAtIndex:i];
        label.textAlignment = UITextAlignmentCenter;
        [label setFont:[UIFont systemFontOfSize:12]];
        label.textColor = [UIColor blackColor];
        label.shadowColor = [UIColor colorWithWhite:.7 alpha:1];
        label.shadowOffset = CGSizeMake(0, 1);
        label.backgroundColor = [UIColor clearColor];
//        label.hidden = YES;
        [self.view addSubview:label];
//        }
        
    }
    
    
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
    

    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"nav_top", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(showLeftInMainView)];
    
    menuButton.image = [UIImage imageWithContentsOfFile:PathInMainBundle(@"navbar_toggle", kPNGFileType)];
    [menuButton setBackgroundImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_common", kPNGFileType)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = menuButton;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor blackColor], UITextAttributeTextColor,
                                [UIColor colorWithWhite:1.0 alpha:0.8], UITextAttributeTextShadowColor,
                                [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                nil];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeTitle)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.reachability = [CCReachability reachabilityWithHostname:@"www.baidu.com"];
    [self.reachability startNotifier];
    
    
    CCSideViewController *left = [[CCSideViewController alloc] initWithNibName:@"CCSideViewController" bundle:nil];
    [self.revealSideViewController preloadViewController:left forSide:PPRevealSideDirectionLeft];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeTheme:)
                                                 name:kThemeDidChangeNotification
                                               object:nil];
    
    NSString *currentThemeName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CCCurrentThemeName"];
    if (currentThemeName) {
        [[ThemeManager sharedInstance] setTheme:currentThemeName];
    } else {
        [[ThemeManager sharedInstance] setTheme:kThemeDefault];
    }
    [self changeTheme:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showLeftInMainView)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:0 forKey:@"selectedRow"];
    [defaults synchronize];
    
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


#pragma mark - Custom Actions

- (void)changeTitle
{
    if ([self.reachability currentReachabilityStatus] == NotReachable) {
        self.title = @"西电导航（无网络）";
        [self showNetworkErrorNotifier];
    } else {
        self.title = @"西电导航";
    }
}

- (void)changeTheme:(NSNotification *)notificaton
{
    for (int i=0; i<[self.icons count]; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:100 + i + 1];
        [btn setImage:ThemeImage(self.icons[i]) forState:UIControlStateNormal];
    }
    
    // Custom view
    NSDictionary *bgNames = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"main_bg_dandelion_dark", kThemeMetro,
                             @"main_bg_fantasy", kThemeGlass,
                             @"main_bg_white", kThemeDefault, nil];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        NSString *iphone5Name = [NSString stringWithFormat:@"%@-568h@2x", [bgNames objectForKey:[ThemeManager sharedInstance].theme]];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:PathInMainBundle(iphone5Name, kPNGFileType)]]];
//        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"main_bg_dandelion-568h@2x", kPNGFileType)]]];
    } else {
//        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"main_bg", kPNGFileType)]]];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:PathInMainBundle([bgNames objectForKey:[ThemeManager sharedInstance].theme], kPNGFileType)]]];
    }
    
    for (int i=0; i<[self.icons count]; i++) {
        UILabel *label = (UILabel *)[self.view viewWithTag:200 + i + 1];

        if ([[ThemeManager sharedInstance].theme isEqualToString:kThemeMetro]) {
            label.hidden = YES;
        } else
            label.hidden = NO;
    }

}

- (void)showLeftInMainView
{
//    CCSideViewController *left = [[CCSideViewController alloc] initWithNibName:@"CCSideViewController" bundle:nil];
//    [self.revealSideViewController pushViewController:left onDirection:PPRevealSideDirectionLeft animated:YES];
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
}

- (void)pushCorrespondingController:(id)sender
{
//    NSUInteger tag = ((UIGestureRecognizer *)sender).view.tag;
    NSUInteger tag = ((UIButton *)sender).tag;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:tag - 100 forKey:@"selectedRow"];
    [defaults synchronize];
    
    switch (tag - 100) {
            
        case XDTimeIndex:
		{
			SVWebViewController *webView = [[SVWebViewController alloc] initWithAddress:@"http://time.xidian.cc"];
            
			[self.navigationController pushViewController:webView animated:YES];
            
			break;
		}
            
        case XDTelephoneIndex:
		{
            //			SVWebViewController *webView = [[SVWebViewController alloc] initWithAddress:@"http://tel.xidian.cc/m/"];
            CCTelViewController *telView = [[CCTelViewController alloc] init];
            
			[self.navigationController pushViewController:telView animated:YES];
            
			break;
		}
            
        case XDCurriculumScheduleIndex:
		{
//			SVWebViewController *webView = [[SVWebViewController alloc] initWithAddress:@"http://kb.xidian.cc/m/index.php"];
//            
//			[self.navigationController pushViewController:webView animated:YES];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            id viewController = nil;
            NSString *value = [defaults objectForKey:@"curriculumClassNumberOrTeacherName"];
            if ([value intValue]) {
                viewController = [[CCCurriculumStudentViewController alloc] init];
            } else if (value.length > 1 && value.length < 6) {
                viewController = [[CCCurriculumTeacherViewController alloc] init];
            } else {
                viewController = [[CCCurriculumSelectViewController alloc] initWithNibName:@"CCCurriculumSelectViewController" bundle:nil];
            }
            [self.navigationController pushViewController:viewController animated:YES];
            
			break;
		}
            
        case XDNewsIndex:
		{
            CCNewsViewController *news = [[CCNewsViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:news animated:YES];
            
			break;
		}
            
        case XDTeacherPagesIndex:
		{
			SVWebViewController *webView = [[SVWebViewController alloc] initWithAddress:@"http://web.xidian.edu.cn/wap/"];
            
			[self.navigationController pushViewController:webView animated:YES];
            
			break;
		}
            
        case XDRecuitmentIndex:
		{
            CCRecuitmentViewController *recuitView = [[CCRecuitmentViewController alloc] initWithNibName:@"CCRecuitmentViewController" bundle:nil];
            
			[self.navigationController pushViewController:recuitView animated:YES];
            
			break;
		}
            
        case XDAcademiaIndex:
		{            
            CCAcademiaViewController *academiaView = [[CCAcademiaViewController alloc] initWithNibName:@"CCAcademiaViewController" bundle:nil];
            
			[self.navigationController pushViewController:academiaView animated:YES];
            
			break;
		}
//            
//        case XDSinaWeiboIndex:
//        {
//            CCSinaWeiboViewController *sinaWeiboView = [[CCSinaWeiboViewController alloc] initWithNibName:@"CCSinaWeiboViewController" bundle:nil];
//            
//            [self.navigationController pushViewController:sinaWeiboView animated:YES];
//            
//            break;
//        }
//            
//        case XDLostAndFindIndex:
//        {
//            CCLostAndFindViewController *lost = [[CCLostAndFindViewController alloc] init];
//            [self.navigationController pushViewController:lost animated:YES];
//            
//            break;
//        }
            
        case XDWelcomeNewbieIndex:
        {
            SVWebViewController *welcome = [[SVWebViewController alloc] initWithAddress:@"http://new.xidian.cc/m"];
            [self.navigationController pushViewController:welcome animated:YES];
            
            break;
        }
            
        case XDMapIndex:
        {
            SVWebViewController *map = [[SVWebViewController alloc] initWithAddress:@"http://map.xidian.cc/m"];
            [self.navigationController pushViewController:map animated:YES];
            
            break;
        }
            
        default:
            break;
    }
    
    
}


@end
