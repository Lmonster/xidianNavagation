//
//  CCAboutViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-3-27.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCAboutViewController.h"
#import "CCGuideViewController.h"

@interface CCAboutViewController ()
- (void)followButtonPressed:(id)sender;
@end

@implementation CCAboutViewController

@synthesize tableview, cellContent, cellDetail, imageView;

- (void)dismiss
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

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
    self.title = @"关于";
    self.cellContent = [NSArray arrayWithObjects:
                        @"版本号",
                        @"欢迎页",
                        @"官方网站",
                        @"官方微博",
                        nil];
    
    
    
    
    UIImage *barButtonImageNormal = [UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_common", kPNGFileType)];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setBackgroundImage:barButtonImageNormal
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsDefault];
    
    
    
    
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
    
    
    
    
    
    
    
    UIImage *navBarImageNormal = [[UIImage imageWithContentsOfFile:PathInMainBundle(@"nav_top", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    [self.navigationController.navigationBar setBackgroundImage:navBarImageNormal
                                                  forBarMetrics:UIBarMetricsDefault];
    
    
    
    
    
    
    
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
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:attributes
                                                                                            forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:attributesHighlighted
                                                                                            forState:UIControlStateHighlighted];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    
    
    
    
    
    
    // Add bar buttons when in presentviewcontroller
    if ([self.navigationController.viewControllers count] == 1) {
        UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
        
        self.navigationItem.rightBarButtonItem = dismissButton;
    }
    
    self.imageView.backgroundColor = [UIColor clearColor];
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

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cellContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.cellContent objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
    
    switch (indexPath.row) {
        case kVersionIndex:
        {
            cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            break;
        }
        case kWelcomIndex:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case kWebsitesIndex:
        {
            cell.detailTextLabel.text = @"http://www.xidian.cc/app/";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case kWeiboIndex:
        {
//            UIButton *weiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            weiboButton.frame = CGRectMake(0, 0, 50, 30);
//            [weiboButton setBackgroundImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"barButton", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)] forState:UIControlStateHighlighted];
//            [weiboButton setBackgroundImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"barButtonDisabled", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)] forState:UIControlStateNormal];
//            [weiboButton addTarget:self action:@selector(followButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//            [weiboButton setTitle:@"加关注" forState:UIControlStateNormal];
//            [weiboButton setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1] forState:UIControlStateNormal];
//            [weiboButton setTitleShadowColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
//            weiboButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
//            weiboButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
//            cell.accessoryView = weiboButton;
            cell.detailTextLabel.text = @"西电导航";
            break;
        }
        default:
            break;
    }
    return cell;
    
    
    
}


#pragma mark - Table View Delegate Methods

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        return indexPath;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case kWelcomIndex:
        {
            CCGuideViewController *guide = [[CCGuideViewController alloc] init];
            guide.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:guide animated:YES completion:nil];
            break;
        }
            case kWebsitesIndex:
        {
            SVWebViewController *web = [[SVWebViewController alloc] initWithAddress:@"http://www.xidian.cc/app"];
            [self.navigationController pushViewController:web animated:YES];
            break;
        }
            case kWeiboIndex:
        {
            NSString *officialWeibo = [NSString stringWithFormat:@"http://weibo.c%@/%@",
                                      UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"om" : @"n",
                                       @"xidiancc"];
            SVWebViewController *web = [[SVWebViewController alloc] initWithAddress:officialWeibo];
            [self.navigationController pushViewController:web animated:YES];
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Custom Actions

- (void)followButtonPressed:(id)sender
{
    if ([ApplicationDelegate.weiboEngine isReachable]) {
        
        if (![ApplicationDelegate.sinaWeibo isAuthValid]) {
            
            [ApplicationDelegate.sinaWeibo logIn];
            
        } else {
            
            [[MTStatusBarOverlay sharedOverlay] postMessage:@"正在添加关注" animated:YES];
            
            [ApplicationDelegate.sinaWeibo requestWithURL:@"friendships/create.json"
                                                   params:[NSMutableDictionary dictionaryWithObject:kOfficialWeiboScreenName forKey:@"screen_name"]
                                               httpMethod:@"POST"
                                                 delegate:self];
        }
    } else {
        
        [BWStatusBarOverlay setAnimation:BWStatusBarOverlayAnimationTypeFromTop];
        [BWStatusBarOverlay showSuccessWithMessage:@"连接错误，请检查你的网络或稍后再试" duration:4.0 animated:YES];
    }
    
}


#pragma mark - Sina Weibo Delegate Methods

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



#pragma mark - Sina Weibo Request Delegate Methods

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([result objectForKey:@"screen_name"]) {
        
        [[MTStatusBarOverlay sharedOverlay] postFinishMessage:@"关注成功，感谢您的关注" duration:3.0f animated:YES];
        
    } else if ([[result objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithInt:20506]]){
        
        [[MTStatusBarOverlay sharedOverlay] postErrorMessage:@"矮油，之前好像关注过了" duration:2.0f animated:YES];
        
    } else {
        
        [[MTStatusBarOverlay sharedOverlay] postErrorMessage:[result objectForKey:@"error"] duration:2.0f animated:YES];
        
    }
}



@end

