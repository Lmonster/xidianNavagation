//
//  CCLostAndFindViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-4-24.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLostIndex          0;
#define kFindIndex          1;

@class SVWebViewController;

@interface CCLostAndFindViewController : UIViewController

@property (strong, nonatomic) SVWebViewController *lost;
@property (strong, nonatomic) SVWebViewController *find;
//@property (strong, nonatomic) IBOutlet UIButton *publishButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentIndexChanged:(id)sender;

@end
