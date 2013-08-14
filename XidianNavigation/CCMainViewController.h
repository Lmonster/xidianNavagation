//
//  CCMainViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-3-6.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CCMainViewController : UIViewController 

@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSArray *icons;
@property (strong, nonatomic) CCReachability *reachability;


- (IBAction)aboutButtonPressed:(id)sender;
- (IBAction)pushCorrespondingController:(id)sender;
- (void)showNetworkErrorNotifier;


@end
