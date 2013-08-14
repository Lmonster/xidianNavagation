//
//  CCViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-3-30.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CCSinaWeiboViewController.h"
#import "UIColor+HexColor.h"
#import "CCSinaCell.h"

@interface CCSinaWeiboViewController ()
- (void)getUserInfoWithScreenName:(NSString *)screenName atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation CCSinaWeiboViewController

@synthesize sinaWeibo;          //新浪微博实例
@synthesize friendsList;        //关注列表
@synthesize sortedFriendList;   //已排序的关注列表
@synthesize weiboList;          //weiboList.plist文件 微博用户列表
@synthesize userInfo;           //用户信息 users/show.json 返回数据
@synthesize weiboKinds;         //weiboListplist文件 微博种类
@synthesize tappedIndexPath;    //当时敲击的IndexPath
@synthesize filePath;           //followFlags.plist 的路径
@synthesize followFlags;        //用来标示是否已关注



#pragma mark - Custom Methods

- (void)getData
{
    NSString *dataUrlString = @"2/friendships/friends.json?cursor=0&count=100&uid=2202364261&access_token=2.00NYtC6C8EcH5D4f466d9ffbYzD4gB";
    
    [ApplicationDelegate.weiboEngine getUserInfoFrom:dataUrlString
                                    competionHandler:^(id receivedJson) {
//                                        self.friendsList = receivedJson[@"users"];
                                        self.sortedFriendList = [self reorderFriendListArrayIntoFourGroups:receivedJson[@"users"]];
                                        [self.tableView reloadData];
                                        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1f];
                                        
                                    } errorHandler:^(NSError *error) {
                                        
                                        [self doneLoadingTableViewData];
                                        [BWStatusBarOverlay setAnimation:BWStatusBarOverlayAnimationTypeFromTop];
                                        [BWStatusBarOverlay showSuccessWithMessage:@"网络错误，请检查你的网络或稍后再试" duration:4.0 animated:YES];
                                        
                                    }];
}

- (void)getUserInfoWithScreenName:(NSString *)screenName atIndexPath:(NSIndexPath *)indexPath
{
    if ([ApplicationDelegate.sinaWeibo isAuthValid]) {
        //        NSString *encodedScreenName = [screenName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        //        [ApplicationDelegate.weiboEngine getUserInfoJsonFrom:@"2/users/show.json"
        //                                                  parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:
        //                                                              screenName, @"screen_name", nil]
        //                                                  httpMethod:@"GET"
        //                                           completionHandler:^(id jsonData) {
        //                                               self.userInfo = jsonData;
        //                                               [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        //                                           } errorHandler:^(NSError *error) {
        //                                           }];
        //        [ApplicationDelegate.weiboEngine getJSONFrom:userInfoUrl(ApplicationDelegate.sinaWeibo.accessToken, [screenName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding])
        //                                   completionHandler:^(id InfoTitles) {
        //                                       self.userInfo = InfoTitles;
        //                                       [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        //                                   } errorHandler:^(NSError *error) {
        //
        //                                   }];
    }
}

- (NSArray *)reorderFriendListArrayIntoFourGroups:(NSArray *)friendList
{
    NSArray *accordingArray = [NSArray arrayWithObjects:@"xidian",
                               @"xdzsb",
                               @"u/2098645875",
                               @"xdtv",
                               @"xdmeeting",
                               @"xidianxiaoyouhui",
                               @"xduph",
                               @"xidiancc",
                               @"bjxdxyh",
                               @"xdste",
                               @"xidianee",
                               @"xidianjisuanji",
                               @"u/2659747081",
                               @"xidianmbadx",
                               @"xidiansu",
                               @"xdyanhui",
                               @"xdwyh",
                               @"hwclub",
                               @"mstcinxdu",
                               @"xdtic",
                               @"u/2066097291", 
                               @"xdtyyh", 
                               @"u/2659849943", 
                               @"u/2472577612", 
                               @"u/2624759603", 
                               @"u/2518204192", 
                               @"u/2272409091", 
                               @"u/3053916304", 
                               @"u/2710967451", 
                               @"xd07science", 
                               @"u/3101490401", 
                               @"u/2736358321", 
                               @"u/2679025471", 
                               @"u/2986841940", 
                               @"xdshelian", 
                               @"u/2521730564", 
                               @"u/2615532084", 
                               @"dytuanwei", 
                               @"u/2525370270", 
                               @"xdjwytw", 
                               @"u/2230518442", 
                               @"u/1973198053", 
                               @"xdrsbt", 
                               @"xdnice", 
                               @"xidianbbs", 
                               @"xdnet2010", 
                               @"xdwbxh", 
                               @"focusxd", 
                               @"u/2921243314", 
                               @"idisu", 
                               @"xidianweibo", 
                               @"u/3052322645", nil];
    NSArray *sortedArray = [friendList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *value1 = obj1[@"profile_url"];
        NSString *value2 = obj2[@"profile_url"];
        if (value1 != nil && [accordingArray containsObject:value1] && value2 != nil && [accordingArray containsObject:value2]) {
            int loc1 = [accordingArray indexOfObject:value1];
            int loc2 = [accordingArray indexOfObject:value2];
            return loc1 == loc2 ? NSOrderedSame : loc1 > loc2 ? NSOrderedDescending : NSOrderedAscending;
        } else {
            return [accordingArray containsObject:value1] ? NSOrderedDescending : NSOrderedAscending;
        }
    }];
    NSArray *sortedArrayArray = [NSArray arrayWithObjects:
                                      [sortedArray subarrayWithRange:NSMakeRange(0, 9)],
                                      [sortedArray subarrayWithRange:NSMakeRange(9, 5)], 
                                      [sortedArray subarrayWithRange:NSMakeRange(14, 28)], 
                                      [sortedArray subarrayWithRange:NSMakeRange(42, 10)], nil];
    return sortedArrayArray;
}

#pragma mark - View Lifecycle Methods

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
    self.title = @"微博列表";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.sinaWeibo = ApplicationDelegate.sinaWeibo;
    
    //    NSURL *urlForWeiboPlist = [[NSBundle mainBundle] URLForResource:@"WeiboList" withExtension:@"plist"];
    //    self.weiboList = [NSArray arrayWithContentsOfURL:urlForWeiboPlist];
    //
    //    self.weiboKinds = [NSArray arrayWithObjects:@"学校微博", @"学院微博", @"西电互联", @"学生组织", nil];
    
    
    NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //### Multi-user and userSwitch Problem;
    NSString *fileName = @"weiboFollowFlags.plist"; 
    self.filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];// alloc] init];
    
    
    //    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //
    //    if (![fileManager fileExistsAtPath:self.filePath]) {
    //
    //        [fileManager createFileAtPath:self.filePath contents:nil attributes:nil];
    //
    //        NSMutableArray *b = [NSMutableArray array];
    //
    //        for (int i=0; i<40; i++) {
    //            b[i] = [NSNumber numberWithInteger:0];
    //
    //        }
    //
    //        NSMutableArray *a = [NSMutableArray arrayWithObjects:b, b, b, b, nil];
    //
    //        [a writeToFile:self.filePath atomically:YES];
    //    } else {
    //        self.followFlags = [NSMutableArray arrayWithContentsOfFile:self.filePath];
    //    }
    
    if (![fileManager fileExistsAtPath:self.filePath]) {
        [fileManager createFileAtPath:self.filePath contents:nil attributes:nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"one", @"1", nil];
        [dic writeToFile:self.filePath atomically:YES];
    }
    
    self.followFlags = [NSMutableDictionary dictionaryWithContentsOfFile:self.filePath];
    
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.followFlags writeToFile:self.filePath atomically:YES];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    return [self.weiboKinds count];
    return [self.sortedFriendList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    NSArray *weiboListOfKind = [self.weiboList objectAtIndex:section];
    //    return [weiboListOfKind count];
    return [[self.sortedFriendList objectAtIndex:section] count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [self.weiboKinds objectAtIndex:section];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellFollow";
    
    CCSinaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CCSinaCell" owner:self options:nil][0];
    }
    
//    NSDictionary *data = [self.friendsList objectAtIndex:indexPath.row];
    NSDictionary *data = [[self.sortedFriendList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    [cell setWeiboData:data];
    
    
    [cell.followButton addTarget:self action:@selector(followButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.unfollowButton addTarget:self action:@selector(unfollowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[self.followFlags valueForKey:data[@"screen_name"]] intValue]) {
        cell.followButton.hidden = YES;
        cell.unfollowButton.hidden = NO;
    } else {
        cell.followButton.hidden = NO;
        cell.unfollowButton.hidden = YES;
    }
    
    //    cell.avatarView.layer.cornerRadius = 8.0f;
    //    cell.avatarView.layer.masksToBounds = YES;
    //
    //    cell.userDescriptionLabel.textColor = [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:1];
    
    
    
    UIColor *whiteColor = [UIColor whiteColor];
    CGSize shadowOffset = CGSizeMake(0, 1);
    
    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], [CCSinaWeiboViewController class], nil] setShadowColor:whiteColor];
    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], [CCSinaWeiboViewController class], nil] setShadowOffset:shadowOffset];
    
    //    CGRect oldFrame = cell.frame;
    //    cell.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, VIEWFRAMESIZE.width, 61.0f);
    
    //    AYUIButton *followButton = nil;
    
    //    if (!cell) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //
    //        followButton = [AYUIButton buttonWithType:UIButtonTypeCustom];
    //        followButton.tag = 300;
    //
    //        followButton.frame = CGRectMake(0, 0, 60, 30);
    //        followButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    //        followButton.titleLabel.textColor = [UIColor whiteColor];
    //        [followButton setBackgroundColor:[UIColor colorWithRed:.05 green:.33 blue:.65 alpha:1] forState:UIControlStateNormal];
    //        [followButton setBackgroundColor:[UIColor colorWithRed:.77 green:.22 blue:.50 alpha:1] forState:UIControlStateHighlighted];
    //        followButton.layer.borderColor = [UIColor grayColor].CGColor;
    //        followButton.layer.borderWidth = .5f;
    //        followButton.layer.cornerRadius = 5.0f;
    //        [followButton addTarget:self action:@selector(followButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    } else {
    //        followButton = (AYUIButton *)[cell viewWithTag:300];
    //    }
    //
    //
    //    NSArray *weiboListOfKind = [self.weiboList objectAtIndex:indexPath.section];
    //
    //    cell.textLabel.text = [weiboListOfKind objectAtIndex:indexPath.row];
    //
    //
    //    //    self.followFlags = [NSMutableArray arrayWithContentsOfFile:self.filePath];
    //    //    if (self.followFlags[indexPath.section][indexPath.row]) {
    //    //        NSLog(@"%d %d", indexPath.section, indexPath.row);
    //    //    }
    //    NSLog(@"%d", [self.followFlags[indexPath.section][indexPath.row] intValue]);
    //    [followButton setTitle:[self.followFlags[indexPath.section][indexPath.row] intValue] ? @"已关注" : @"关注" forState:UIControlStateNormal];
    //
    //
    //    if (self.userInfo != nil) {
    ////        [followButton setTitle:[self.userInfo objectForKey:@"followed_button_title"] forState:UIControlStateNormal];
    //        [followButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    //
    //        self.userInfo = nil;
    //    }
    
    //    cell.accessoryView = followButton;
    
    
    return cell;
}


#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *userHomePage = [NSString stringWithFormat:@"http://weibo.c%@/%@",
                              UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"om" : @"n",
                              [self.sortedFriendList[indexPath.section][indexPath.row] objectForKey:@"profile_url"]];
    CCWebViewController *webview = [[CCWebViewController alloc] initWithAddress:userHomePage];
    
    [self.navigationController pushViewController:webview animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [NSArray arrayWithObjects:@"学校", @"学院", @"西电", @"学生", nil];
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *array = [NSArray arrayWithObjects:@"学校微博", @"学院微博", @"西电互联", @"学生组织", nil];
    return [array objectAtIndex:section];
}


#pragma mark - Custom Actions

- (void)followButtonPressed:(id)sender
{
    if ([ApplicationDelegate.weiboEngine isReachable]) {
        
        
        CCSinaCell *cellView = (CCSinaCell *)[[(UIButton *)sender superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cellView];
        //    NSArray *weiboListOfKind = [self.weiboList objectAtIndex:tappedIndexPath.section];
        
        self.tappedIndexPath = indexPath;
        
        [self followUserByScreenName:self.sortedFriendList[indexPath.section][indexPath.row][@"screen_name"]];
        
    } else {
        
        [BWStatusBarOverlay setAnimation:BWStatusBarOverlayAnimationTypeFromTop];
        [BWStatusBarOverlay showSuccessWithMessage:@"连接错误，请检查你的网络或稍后再试" duration:4.0 animated:YES];
        
    }
}

- (void)unfollowButtonPressed:(id)sender
{
    if ([ApplicationDelegate.weiboEngine isReachable]) {
        CCSinaCell *cellView = (CCSinaCell *)[[(UIButton *)sender superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cellView];
        
        self.tappedIndexPath = indexPath;
        [self unfollowUserByScreenName:self.sortedFriendList[indexPath.section][indexPath.row][@"screen_name"]];
    } else {
        [BWStatusBarOverlay setAnimation:BWStatusBarOverlayAnimationTypeFromTop];
        [BWStatusBarOverlay showSuccessWithMessage:@"连接错误，请检查你的网络或稍后再试" duration:4.0 animated:YES];
    }
}

- (void)followUserByScreenName:(NSString *)screenName
{
    if (![ApplicationDelegate.sinaWeibo isAuthValid]) {
        [ApplicationDelegate.sinaWeibo logIn];
    } else {
        [[MTStatusBarOverlay sharedOverlay] postMessage:@"正在添加关注" animated:YES];
        
        [ApplicationDelegate.sinaWeibo requestWithURL:@"friendships/create.json"
                                               params:[NSMutableDictionary dictionaryWithObject:screenName forKey:@"screen_name"]
                                           httpMethod:@"POST"
                                             delegate:self];
    }
}

- (void)unfollowUserByScreenName:(NSString *)screenName
{
    if (![ApplicationDelegate.sinaWeibo isAuthValid]) {
        [ApplicationDelegate.sinaWeibo logIn];
    } else {
        [[MTStatusBarOverlay sharedOverlay] postMessage:@"正在取消关注" animated:YES];
        
        [ApplicationDelegate.sinaWeibo requestWithURL:@"friendships/destroy.json"
                                               params:[NSMutableDictionary dictionaryWithObject:screenName forKey:@"screen_name"]
                                           httpMethod:@"POST"
                                             delegate:self];
    }
}

- (void)getUserInfoByscreenName:(NSString *)screenName
{
    if (![ApplicationDelegate.sinaWeibo isAuthValid]) {
        [ApplicationDelegate.sinaWeibo logIn];
    } else {
        [ApplicationDelegate.sinaWeibo requestWithURL:@"users/show.json"
                                               params:[NSMutableDictionary dictionaryWithObject:screenName forKey:@"screen_name"]
                                           httpMethod:@"GET"
                                             delegate:self];
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
    NSLog(@"%@", result);
    NSDictionary *data = self.sortedFriendList[self.tappedIndexPath.section][self.tappedIndexPath.row];

    if (![[self.followFlags valueForKey:data[@"screen_name"]] intValue]) {
        
        
        if ([result objectForKey:@"screen_name"]) {
            
            [[MTStatusBarOverlay sharedOverlay] postFinishMessage:@"关注成功" duration:1.5f animated:YES];
            
//        self.userInfo = [NSMutableDictionary dictionaryWithDictionary:result];
//        [self.userInfo setObject:@"已关注" forKey:@"followed_button_title"];
            
//        self.followFlags = [NSMutableArray arrayWithContentsOfFile:self.filePath];
//        self.followFlags[self.tappedIndexPath.section][self.tappedIndexPath.row] = [NSNumber numberWithInteger:1];
            [self.followFlags setObject:[NSNumber numberWithInt:1] forKey:[result objectForKey:@"screen_name"]];
            CCSinaCell *cell = (CCSinaCell *)[self.tableView cellForRowAtIndexPath:self.tappedIndexPath];
            cell.followButton.hidden = YES;
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.tappedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
        } else if ([[result objectForKey:@"error_code"] isEqualToNumber:[NSNumber numberWithInt:20506]]){
            
            NSLog(@"%@", result);
            
            [[MTStatusBarOverlay sharedOverlay] postErrorMessage:@"矮油，之前好像关注过了" duration:2.0f animated:YES];
            
            CCSinaCell *cell = (CCSinaCell *)[self.tableView cellForRowAtIndexPath:self.tappedIndexPath];
            cell.followButton.hidden = YES;
            [self.followFlags setValue:[NSNumber numberWithInt:1] forKey:cell.screenNameLabel.text];
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.tappedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
//        self.userInfo = [NSMutableDictionary dictionaryWithObject:@"已关注" forKey:@"followed_button_title"];
            
        } else {
            
            [[MTStatusBarOverlay sharedOverlay] postErrorMessage:[result objectForKey:@"error"] duration:2.0f animated:YES];
            NSLog(@"%@", result);  
            
        }
    } else {
        
        if ([result objectForKey:@"screen_name"]) {
            
            [[MTStatusBarOverlay sharedOverlay] postFinishMessage:@"取消关注成功" duration:1.5f animated:YES];
            
            [self.followFlags setObject:[NSNumber numberWithInt:0] forKey:[result objectForKey:@"screen_name"]];
            CCSinaCell *cell = (CCSinaCell *)[self.tableView cellForRowAtIndexPath:self.tappedIndexPath];
            cell.followButton.hidden = NO;
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.tappedIndexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}

@end
