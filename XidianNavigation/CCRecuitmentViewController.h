//
//  CCRecuitmentViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-3-19.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMainTableViewController.h"

enum {
    kRecuitmentSouthIndex = 0,
    kRecuitmentTotalIndex,
    kRecuitmentNorthIndex,
};

enum {
    kTitleTag = 101,
    kDateTag,
    kTimeTag,
    kPlaceTag,

};


@interface CCRecuitmentViewController : CCMainTableViewController

@property (strong, nonatomic)  UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSArray *datalist;
@property (strong, nonatomic) NSArray *callbackPaths;
@property (strong, nonatomic) NSArray *segmentItems;
@property (assign, nonatomic) NSInteger selectedSegmentIndex;

@end
