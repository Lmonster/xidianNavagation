//
//  CCAboutViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-3-27.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

enum {
    kVersionIndex = 0,
    kWelcomIndex,
    kWebsitesIndex,
    kWeiboIndex,
};

#define kOfficialWeiboScreenName           @"西电导航"

@interface CCAboutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSArray *cellContent;
@property (strong, nonatomic) NSArray *cellDetail;

@end
