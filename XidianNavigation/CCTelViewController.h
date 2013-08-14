//
//  CCTelViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-3-20.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMainTableViewController.h"

@interface CCTelViewController : CCMainTableViewController

@property (strong, nonatomic) NSDictionary *datalist;
@property (strong, nonatomic) NSDictionary *commonlist;
@property (strong, nonatomic) NSArray *cellContentKeys;
@property (strong, nonatomic) NSArray *cellContentValues;

@end
