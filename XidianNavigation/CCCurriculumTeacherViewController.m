//
//  CCCurriculumTeacherViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-4-23.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CCCurriculumTeacherViewController.h"
#import "CCCurriculumSelectViewController.h"
#import "CCTeacherWeekCourseCell.h"
#import "CCStudentTermCourseCell.h"

@interface CCCurriculumTeacherViewController ()

@end

@implementation CCCurriculumTeacherViewController

@synthesize scrollView, pageControlUsed, pageControl, currentPage, lastIndexPath;
@synthesize titleview, titleLabel, maskView, titleBgView, titleClassNumber, popTable, popTableFooter;
@synthesize timeView, dateLabel, weekDayLabel, termWeekLabel;
@synthesize termTable, courseInfo, query, rememberValue;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = self.titleview;
    
    if (!GTE_IOS7) {
        
    UIImage *barButtonImageNormal = [UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_common", kPNGFileType)];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setBackgroundImage:barButtonImageNormal
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsDefault];
    
    
    UIImage *backButtonImageNormal = [[UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_back", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 5)];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setBackButtonBackgroundImage:backButtonImageNormal
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsDefault];
    
    
    UIImage *backButtonImageActive = [[UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_back_active", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 5)];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setBackButtonBackgroundImage:backButtonImageActive
     forState:UIControlStateHighlighted
     barMetrics:UIBarMetricsDefault];
        
    }
    
    UIBarButtonItem *switchButton = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStyleBordered target:self action:@selector(switchView:)];
    self.navigationItem.rightBarButtonItem = switchButton;
    
    // Scroll View
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    
    
    // Page Controll
//    self.pageControl = [[SliderPageControl alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 30)];
//    [self.pageControl addTarget:self action:@selector(onPageChanged:) forControlEvents:UIControlEventValueChanged];
//    self.pageControl.delegate = self;
//    self.pageControl.showsHint = YES;
//    self.pageControl.backgroundColor = [UIColor clearColor];
//    [self.pageControl setNumberOfPages:kNumberOfPages];
//    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [self.view addSubview:self.pageControl];


    if (self.query == nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"curriculumClassNumberOrTeacherName"] != nil) {
        self.query = [[NSUserDefaults standardUserDefaults] objectForKey:@"curriculumClassNumberOrTeacherName"];
    }
    if (self.query != nil) {
        [self getWeekData];
    }

    // Popover View
    self.popTable.center = CGPointMake(160, 50);
    self.popTable.tableFooterView = self.popTableFooter;

}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.rememberValue = [defaults valueForKey:@"curriculumClassNumberOrTeacherName"];
    self.titleClassNumber.text = self.rememberValue;

    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Scroll View Delegate Methods

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    self.pageControlUsed = NO;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (self.pageControlUsed) {
//        return;
//    }
//    
//    CGFloat pageWidth = self.scrollView.frame.size.width;
//    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//	
//	[self.pageControl setCurrentPage:page animated:YES];
//    if (self.currentPage != page) {
//        self.currentPage = page;
//        [[self.tableViews objectAtIndex:self.currentPage] reloadData];
//    }
//}
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    self.pageControlUsed = NO;
//    [[self.tableViews objectAtIndex:self.currentPage] reloadData];
//}

#pragma mark - Slider Page Control Delegate

//- (NSString *)sliderPageController:(id)controller hintTitleForPage:(NSInteger)page
//{
//    NSArray *array = [NSArray arrayWithObjects:@"周一", @"周二", @"周三", @"周四", @"周五", nil];
//    return [array objectAtIndex:page];
//}



#pragma mark - Custom Methods

- (void)getWeekData
{
//    self.courseInfo = [[NSMutableArray alloc] initWithCapacity:5];
    NSArray *weeks = [NSArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"日",  nil];
    [ApplicationDelegate.curriculumEngine getJSONFrom:SearchURL([self.query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], kWeekSign)
                                    completionHandler:^(id InfoTitles) {
                                        self.courseInfo = InfoTitles[@"classes"];
                                        [self initWeekTable];
                                        
                                        self.termWeekLabel.text = [InfoTitles[@"zhouci"] stringValue];
                                        self.weekDayLabel.text = [weeks objectAtIndex:[InfoTitles[@"day_of_week"] intValue] - 1];
                                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                        [dateFormatter setDateFormat:@"M月d日"];
                                        [dateFormatter setLocale:[NSLocale autoupdatingCurrentLocale]];
                                        self.dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
//                                        [self changeToPage:([InfoTitles[@"day_of_week"] intValue] - 1) animated:YES];
                                        [self showDateInformation];
                                    } errorHandler:^(NSError *error) {
                                        
                                    }];
    
}

- (void)getTermData
{
    self.courseInfo = nil;
    [ApplicationDelegate.curriculumEngine getJSONFrom:SearchURL([self.query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], kTermSign)
                                    completionHandler:^(id InfoTitles) {
                                        self.courseInfo = InfoTitles;
                                        [self initTermTable];
                                    } errorHandler:^(NSError *error) {
                                        
                                    }];
}

- (void)initTermTable
{
    
    self.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, self.scrollView.frame.size.height);
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.pageControl.hidden = YES;
    
    self.termTable = [[UITableView alloc] initWithFrame:CGRectMake(8, 8, [[UIScreen mainScreen] bounds].size.width - 16, self.scrollView.frame.size.height - 16)];
    self.termTable.delegate = self;
    self.termTable.dataSource = self;
    self.termTable.bounces = YES;
    self.termTable.alwaysBounceVertical = YES;
    self.termTable.alwaysBounceHorizontal = NO;
    self.termTable.separatorColor = [UIColor colorWithRed:.65 green:.88 blue:.22 alpha:1];
    self.termTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.termTable.backgroundColor = [UIColor clearColor];
    self.termTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.scrollView addSubview:self.termTable];
    //    [self.termTable reloadData];
}

- (void)initWeekTable
{
    self.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, self.scrollView.frame.size.height);
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.pageControl.hidden = NO;
    
    
//    self.tableViews = [[NSMutableArray alloc] initWithCapacity:5];
//    for (int i=0; i<kNumberOfPages; i++) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(8, 8, [[UIScreen mainScreen] bounds].size.width - 16, self.scrollView.frame.size.height - 16)];
        table.delegate = self;
        table.dataSource = self;
        table.bounces = YES;
        table.alwaysBounceVertical = YES;
        table.alwaysBounceHorizontal = NO;
        table.separatorColor = [UIColor colorWithRed:.65 green:.88 blue:.22 alpha:1];
        table.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        table.backgroundColor = [UIColor clearColor];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //        table.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"curriculum_table_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(46, 70, 46, 70)]];
        //        table.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
        //        table.contentOffset = CGPointMake(8, 8);
//        if (i == 0) {
//            UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showLeft)];
//            swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
//            [table addGestureRecognizer:swipeRight];
//            
//        }
    
//        [self.tableViews addObject:table];
        [self.scrollView addSubview:table];
    
}

- (void)showDateInformation
{
    self.timeView.center = CGPointMake(160, -18);
    [UIView animateWithDuration:0.7f
                          delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.timeView.center = CGPointMake(160, 18);
                         [self.view addSubview:self.timeView];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.7f
                                               delay:3.0f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              self.timeView.center = CGPointMake(160, -25);
                                          } completion:^(BOOL finished) {
                                              [self.timeView removeFromSuperview];
                                          }];
                     }];
    
}

- (void)showLeft
{
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
}

//- (void)onPageChanged:(id)sender
//{
//    self.currentPage = [sender currentPage];
//    [[self.tableViews objectAtIndex:[sender currentPage]] reloadData];
//    self.pageControlUsed = YES;
//    [self slideToCurrentPage:YES];
//}
//
//- (void)slideToCurrentPage:(BOOL)animated
//{
//    int page = self.pageControl.currentPage;
//    CGRect frame = self.scrollView.frame;
//    frame.origin.x = frame.size.width * page;
//    frame.origin.y = 0;
//    [self.scrollView scrollRectToVisible:frame animated:animated];
//}
//
//- (void)changeToPage:(int)page animated:(BOOL)animated
//{
//	[self.pageControl setCurrentPage:page animated:YES];
//	[self slideToCurrentPage:animated];
//}

- (IBAction)titleButtonPressed:(id)sender
{
    NSArray *array = [NSArray arrayWithObjects:@"本周课程", @"本学期课程", nil];
    [UIView animateWithDuration:0.7f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.maskView.hidden = NO;
                         self.maskView.alpha = self.maskView.alpha ? 0 : 1;
                     } completion:^(BOOL finished) {
                         if (!self.maskView.alpha) {
                             self.maskView.hidden = YES;
                         }
                     }];
    //                         self.maskView.hidden = !self.maskView.hidden;
    self.titleBgView.hidden = !self.titleBgView.hidden;
    self.titleLabel.text = [array objectAtIndex:self.lastIndexPath.row];
    
    if (self.popTable.superview == self.view) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.3f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        self.popTable.alpha = 0.0f;
        [self.popTable.layer addAnimation:animation forKey:@"pushOut"];
        [self.popTable performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3f];
        
    } else {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.3f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromBottom;
        self.popTable.alpha = 1.0f;
        [self.popTable.layer addAnimation:animation forKey:@"pushIn"];
        [self.view addSubview:self.popTable];
    }
}


- (void)switchView:(id)sender
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    if ([viewControllers count] > 2 && self == [viewControllers objectAtIndex:2]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        CCCurriculumSelectViewController *selectViewController = [[CCCurriculumSelectViewController alloc] init];
        
        [UIView transitionFromView:[[viewControllers objectAtIndex:1] view]
                            toView:selectViewController.view
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionFlipFromTop
                        completion:^(BOOL finished) {
                            [viewControllers replaceObjectAtIndex:1 withObject:selectViewController];
                            [self.navigationController setViewControllers:viewControllers];
                            self.view = nil;
                        }];
    }
}

#pragma mark - Table View Data source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.popTable) {
        return 2;
    } else if (tableView == self.termTable) {
        return [self.courseInfo count];
    }
    return [self.courseInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PopTableCellIdentifier = @"PopCellIdentifier";
    static NSString *WeekCourseTableCellIdentifier = @"WeekCourseCellIdentifier";
    static NSString *TermCourseTableCellIndetifier = @"TermCourseCellIdentifier";
    
    UITableViewCell *popCell = [tableView dequeueReusableCellWithIdentifier:PopTableCellIdentifier];
    CCTeacherWeekCourseCell *weekCell = [tableView dequeueReusableCellWithIdentifier:WeekCourseTableCellIdentifier];
    CCStudentTermCourseCell *termCell = [tableView dequeueReusableCellWithIdentifier:TermCourseTableCellIndetifier];
    
    if (!popCell) {
        popCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PopTableCellIdentifier];
    }
    if (!weekCell) {
        weekCell = [[NSBundle mainBundle] loadNibNamed:@"CCTeacherWeekCourseCell" owner:self options:nil][0];
    }
    if (!termCell) {
        termCell = [[NSBundle mainBundle] loadNibNamed:@"CCStudentTermCourseCell" owner:self options:nil][0];
    }
    
    if (tableView == self.popTable) {
        NSArray *array = [NSArray arrayWithObjects:@"本周课程", @"本学期课程", nil];
        popCell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.rememberValue, [array objectAtIndex:indexPath.row]];
        if (self.lastIndexPath == nil && indexPath.row == 0) {
            popCell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.lastIndexPath = indexPath;
        } else if (self.lastIndexPath != nil && indexPath.row == self.lastIndexPath.row) {
            popCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            popCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return popCell;
        
    } else if (tableView == self.termTable) {
//        if (self.courseInfo != nil) {
            NSDictionary *course = self.courseInfo[indexPath.row];
            [termCell setData:course];
//        }
        return termCell;
        
    } else {
        
        NSDictionary *cellContent = self.courseInfo[indexPath.row];
        [weekCell setData:cellContent];
        
//        int i = 0;
//        for (NSArray *cellContent in self.courseInfo[@"classes"]) {
//            if ([cellContent count] > 0) {
//                i++;
//                for (NSDictionary *course in cellContent) {
//                    if (course != nil) {
//                        [weekCell setData:course];
//                    }
//                }
//            }
//        }
//        
        weekCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return weekCell;
    }
}


#pragma mark - Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.popTable) {
        return 44;
    } else if (tableView == self.termTable) {
        return 135;
    }
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.popTable) {

        if (self.lastIndexPath.row != indexPath.row) {
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            self.lastIndexPath = indexPath;
            
            //Teacher view related
            if (indexPath.row == 1) {
                
                //                [self initTermTable];
                [self getTermData];
                
            } else if (indexPath.row == 0) {
                
                //                [self initWeekTable];
                [self getWeekData];
                
            }
            
        }
        [self performSelector:@selector(titleButtonPressed:) withObject:nil afterDelay:0.2f];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.popTable) {
        return indexPath;
    }
    return nil;
}




@end
