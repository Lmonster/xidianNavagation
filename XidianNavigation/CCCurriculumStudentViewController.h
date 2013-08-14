//
//  CCCurriculumRootViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-4-13.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderPageControl.h"

#define kNumberOfPages                              5
#define SearchURL(__query__, __sign__)              [NSString stringWithFormat:@"m/ios/search.php?searchstring=%@&sign=%d", __query__, __sign__]
#define kWeekSign                                   0
#define kTermSign                                   1

@interface CCCurriculumStudentViewController : UIViewController <UIScrollViewDelegate, SliderPageControlDelegate, UITableViewDataSource, UITableViewDelegate>

// Share controls
@property (strong, nonatomic) SliderPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *titleview;
@property (strong, nonatomic) IBOutlet UIImageView *titleBgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleClassNumber;
@property (strong, nonatomic) IBOutlet UIView *maskView;
@property (strong, nonatomic) IBOutlet UITableView *popTable;
@property (strong, nonatomic) IBOutlet UIImageView *popTableFooter;

// time View related
@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *weekDayLabel;
@property (strong, nonatomic) IBOutlet UILabel *termWeekLabel;

// week related
@property (strong, nonatomic) NSMutableArray *tableViews;

// term related
@property (strong, nonatomic) UITableView *termTable;


// page control related
@property (nonatomic) BOOL pageControlUsed;
@property (nonatomic) NSInteger currentPage;

// data related
@property (strong, nonatomic) NSIndexPath *lastIndexPath;
@property (strong, nonatomic) id courseInfo;
@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) NSString *rememberValue;



- (IBAction)titleButtonPressed:(id)sender;

@end
