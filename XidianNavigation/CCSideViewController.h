//
//  CCSideViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-2-20.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define XDTimeIndex                 0
//#define XDTelephoneIndex            1
//#define XDCurriculumScheduleIndex   2
//#define XDNewsIndex                 3
//#define XDTeacherPagesIndex         4
//#define XDRecuitmentIndex           5
//#define XDLibrarySearchIndex        6
//#define XDWeiboIndex                7
//#define XDAcademiaIndex             8
//#define XDClassRoomIndex            9

//enum {
//    XDTimeIndex,                          
//    XDTelephoneIndex,
//    XDCurriculumScheduleIndex,
//    XDNewsIndex,
//    XDTeacherPagesIndex,
//    XDRecuitmentIndex,
//    XDAcademiaIndex,
//    XDTotalCount,
//};


@interface CCSideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *feedbackBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingBarButton;

@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSIndexPath *selectedIndexpath;

@end
