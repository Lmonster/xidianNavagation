//
//  CCTelDetailViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-3-21.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMainTableViewController.h"

@interface CCTelDetailViewController : CCMainTableViewController <UIActionSheetDelegate>

@property NSInteger Dpid;
@property (strong, nonatomic) NSString *Dname;
@property (strong, nonatomic) NSArray *datalist;
@property (strong, nonatomic) NSDictionary *commonlist;

@end
