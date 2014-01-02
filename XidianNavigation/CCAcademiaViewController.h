//
//  CCAcademiaViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-3-18.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMainTableViewController.h"


@interface CCAcademiaViewController : CCMainTableViewController

@property (strong, nonatomic) NSMutableArray *academiaTitles;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSMutableDictionary *readFlags;


@end
