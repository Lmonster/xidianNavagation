//
//  CCSettingViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-4-17.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCSettingViewController.h"
#import "CCAboutViewController.h"
#import "CCFeedbackViewController.h"
#import "MBProgressHUD.h"
#import "MBAlertView/MBHUDView.h"
#import "CCThemeListViewController.h"

@interface CCSettingViewController ()
- (void)dismissViewController;
@end

@implementation CCSettingViewController

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
    self.title = @"设置";
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"nav_top", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 20, 10)]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    if (!GTE_IOS7) {
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_common", kPNGFileType)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_common_active", kPNGFileType)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
    }
        
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor blackColor], UITextAttributeTextColor,
                                [UIColor colorWithWhite:1.0 alpha:0.8], UITextAttributeTextShadowColor,
                                [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                nil];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:attributes forState:UIControlStateDisabled];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController)];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    [super viewDidAppear:animated];
    
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom Actions

- (void)dismissViewController
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)checkNewVersion:(id)sender
{
    // With a version-file in remote server.
    if ([ApplicationDelegate.curriculumEngine isReachable]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:@"http://www.xidian.cc/ios/iosversion.php"];
        NSString *remoteVersion = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        NSString *localeVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

        if ([remoteVersion isEqualToString:localeVersion]) { // 和远程版本号相同
            hud.dimBackground = NO;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前已是最新版本";
            [hud hide:YES afterDelay:2.0f];
        } else if ([[remoteVersion substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"2"] && [localeVersion compare:@"1.0.4"] == NSOrderedAscending) {  // 本地版本号小于1.0.4 并且 远程版本号为2.x时 提示以下信息
            hud.dimBackground = NO;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"发现新版本";
            hud.detailsLabelText = [NSString stringWithFormat:@"新版本 v%@ 已经发布\n完美支持iOS7，请下载体验！", remoteVersion];
            [hud hide:YES afterDelay:6.0f];
        } else if ([remoteVersion compare:localeVersion] == NSOrderedDescending) { // 如果远程版本比本地版本高
            hud.dimBackground = NO;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"发现新版本"];
            hud.detailsLabelText = [NSString stringWithFormat:@"新版本：v%@，可去App Store更新！", remoteVersion];
            [hud hide:YES afterDelay:4.0f];
        } else {
            hud.dimBackground = NO;
            [hud hide:YES];
        }
    } else {
        [BWStatusBarOverlay setAnimation:BWStatusBarOverlayAnimationTypeFromTop];
        [BWStatusBarOverlay showSuccessWithMessage:@"连接错误，请检查你的网络或稍后再试" duration:4.0 animated:YES];

    }
}

- (IBAction)feedbackButtonPressed:(id)sender
{
//    CCFeedbackViewController *feedback = [[CCFeedbackViewController alloc] init];
    SVWebViewController *feedback = [[SVWebViewController alloc] initWithAddress:@"http://app.xidian.cc/feedback.php"];
    feedback.title = @"意见反馈";
    [self.navigationController pushViewController:feedback animated:YES];
}

- (IBAction)aboutButtonPressed:(id)sender
{
    CCAboutViewController *about = [[CCAboutViewController alloc] init];
    [self.navigationController pushViewController:about animated:YES];
}

- (IBAction)clearCache:(id)sender
{
    [MBHUDView hudWithBody:nil type:MBAlertViewHUDTypeActivityIndicator hidesAfter:0.1f show:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ApplicationDelegate.telEngine emptyCache];
        [ApplicationDelegate.newsEngine emptyCache];
        [ApplicationDelegate.recuitmentEngine emptyCache];
        [ApplicationDelegate.academiaEngine emptyCache];
        [ApplicationDelegate.weiboEngine emptyCache];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBHUDView hudWithBody:@"缓存清理完毕" type:MBAlertViewHUDTypeCheckmark hidesAfter:2.0f show:YES];
        });
    });
}

- (IBAction)weiboLogout:(id)sender
{
//    if ([ApplicationDelegate.weiboEngine isReachable]) {
        if (![ApplicationDelegate.sinaWeibo isAuthValid]) {
//            [[[UIAlertView alloc] initWithTitle:@"亲，您好像还没登录呢哦" message:@"在主菜单的微博列表里面，点击后面的关注即可登录并完成关注。" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            MBAlertView *alert = [MBAlertView alertWithBody:@"亲，您好像还没登录呢哦（回主菜单进入微博列表，点击后面的“+”即可登录并完成关注。）" cancelTitle:nil cancelBlock:nil];
            [alert addButtonWithText:@"好的" type:MBAlertViewItemTypePositive block:nil];
            [alert addToDisplayQueue];
        } else {
            [ApplicationDelegate.sinaWeibo logOut];
            [MBHUDView hudWithBody:nil type:MBAlertViewHUDTypeActivityIndicator hidesAfter:0.5f show:YES];
            [MBHUDView hudWithBody:@"成功退出登录" type:MBAlertViewHUDTypeCheckmark hidesAfter:2.0f show:YES];
        }
//    } else {
//        MBAlertView *alert = [MBAlertView alertWithBody:@"亲，您的网络好像有问题哦" cancelTitle:@"好的" cancelBlock:^{
//            
//        }];
//        [alert addToDisplayQueue];
//        
//    }
}

- (IBAction)changeTheme:(id)sender
{
    CCThemeListViewController *theme = [[CCThemeListViewController alloc] init];
    [self.navigationController pushViewController:theme animated:YES];
}


@end
