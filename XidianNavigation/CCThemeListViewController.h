//
//  CCThemeListViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-5-2.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCThemeListViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *selectedImage;
- (IBAction)selectThemeAtIndex:(UIButton *)sender;

@end
