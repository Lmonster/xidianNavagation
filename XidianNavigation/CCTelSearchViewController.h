//
//  CCTelSearchViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-3-27.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCTelSearchViewController : UIViewController
<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSArray *searchResult;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *dimView;
- (IBAction)hideKeyboard;
@end
