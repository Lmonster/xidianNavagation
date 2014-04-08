//
//  CCAppDelegate.m
//  XidianNavigation
//
//  Created by ooops on 13-2-18.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCAppDelegate.h"
#import "CCMainViewController.h"
#import "CCXidianEngine.h"
#import "SinaWeibo.h"
#import "CCSinaWeiboViewController.h"
#import "CCGuideViewController.h"


@implementation CCAppDelegate

@synthesize revealSideViewController, sinaWeiboViewController, sideViewController, globalNavController;
@synthesize newsEngine, academiaEngine, recuitmentEngine, telEngine, weiboEngine, curriculumEngine;
@synthesize reachability;
@synthesize sinaWeibo;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // set global tintcolor for ios7+
    if (GTE_IOS7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.window.tintColor = [UIColor blackColor];
        [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
        [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    }

    
    // View Window Related
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"CCAppFirstLaunch"] == NO;
    if (isFirstLaunch) {
        CCGuideViewController *guide = [[CCGuideViewController alloc] initWithNibName:@"CCGuideViewController" bundle:nil];
        self.window.rootViewController = guide;
        
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        CCMainViewController *main = [[CCMainViewController alloc] initWithNibName:@"CCMainViewController" bundle:nil];
        self.globalNavController = [[UINavigationController alloc] initWithRootViewController:main];
        self.revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:self.globalNavController];
        [self.revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionNavigationBar];
        self.window.rootViewController = self.revealSideViewController;
    }

    
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    
    
    // Set network engines
    self.newsEngine = [[CCXidianEngine alloc] initWithHostName:@"news.xidian.cc"];
    [self.newsEngine useCache];
    
    self.academiaEngine = [[CCXidianEngine alloc] initWithHostName:@"meeting.xidian.edu.cn"];
    [self.academiaEngine useCache];
    
    self.recuitmentEngine = [[CCXidianEngine alloc] initWithHostName:@"job.xidian.edu.cn"];
    [self.recuitmentEngine useCache];
    
    self.telEngine = [[CCXidianEngine alloc] initWithHostName:@"tel.xidian.cc"];
    [self.telEngine useCache];
    
    self.weiboEngine = [[CCWeiboEngine alloc] initWithHostName:@"api.weibo.com"];
    [self.weiboEngine useCache];
    [UIImageView setDefaultEngine:self.weiboEngine];
    
    self.curriculumEngine = [[CCXidianEngine alloc] initWithHostName:@"kb.xidian.cc"];
//    [self.curriculumEngine useCache];
    
    
    // Initialize SinaWeibo Engine
    self.sinaWeiboViewController = [[CCSinaWeiboViewController alloc] initWithNibName:@"CCSinaWeiboViewController" bundle:nil];
    
    self.sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self.sinaWeiboViewController];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        self.sinaWeibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        self.sinaWeibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        self.sinaWeibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    
    // Baidu Statistics
    BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES;
    statTracker.logSendWifiOnly = NO;
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;
    statTracker.enableDebugOn = NO;
    statTracker.sessionResumeInterval = 15;
    statTracker.shortAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [statTracker startWithAppId:kBaiduStatisticsAppId];
    

    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"reachable"];
    [defaults synchronize];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.sinaWeibo applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.sinaWeibo handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.sinaWeibo handleOpenURL:url];
}

@end
