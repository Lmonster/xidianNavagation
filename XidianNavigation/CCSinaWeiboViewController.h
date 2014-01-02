//
//  CCViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-3-30.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMainTableViewController.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

#define kDidgetFollowCallback       @"gotCallback"

@interface CCSinaWeiboViewController : CCMainTableViewController <SinaWeiboDelegate, SinaWeiboRequestDelegate>

@property (strong, nonatomic) SinaWeibo *sinaWeibo;
@property (strong, nonatomic) NSMutableArray *friendsList;
@property (strong, nonatomic) NSArray *sortedFriendList;
@property (strong, nonatomic) NSArray *weiboKinds;
@property (strong, nonatomic) NSArray *weiboList;
@property (strong, nonatomic) NSMutableDictionary *userInfo;
@property (strong, nonatomic) NSMutableDictionary *followFlags;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSIndexPath *tappedIndexPath;

- (void)followButtonPressed:(id)sender;
@end
