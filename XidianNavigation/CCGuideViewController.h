//
//  CCGuideViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-4-30.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCGuideViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)enterButtonPress:(id)sender;

@end
