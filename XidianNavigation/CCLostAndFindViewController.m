//
//  CCLostAndFindViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-4-24.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCLostAndFindViewController.h"

@interface CCLostAndFindViewController ()

@end

@implementation CCLostAndFindViewController

@synthesize lost, find, segmentedControl;

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
    [self initLostView];
    [self.view addSubview:self.lost.view];
    self.title = @"失物信息";
    
    UIImage *barButtonImageNormal = [UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_common", kPNGFileType)];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setBackgroundImage:barButtonImageNormal
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsDefault];
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    publishButton.frame = CGRectMake(0, 0, 44, 44);
    [publishButton addTarget:self action:@selector(publishNewInfo) forControlEvents:UIControlEventTouchUpInside];
    [publishButton setBackgroundImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"icon_compose", kPNGFileType)] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:publishButton];

    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor colorWithWhite:.5 alpha:1], UITextAttributeTextColor,
                                [UIColor colorWithWhite:1.0 alpha:0.8], UITextAttributeTextShadowColor,
                                [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                nil];
    
    NSDictionary *attributesHighlighted = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIColor colorWithWhite:0 alpha:1], UITextAttributeTextColor,
                                           [UIColor colorWithWhite:1.0 alpha:0.8], UITextAttributeTextShadowColor,
                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                           nil];

    
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.segmentedControl setTitleTextAttributes:attributesHighlighted forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom Methods

- (void)publishNewInfo
{
    SVModalWebViewController *pub = [[SVModalWebViewController alloc] initWithAddress:@"http://find.xidian.cc/mobile/index.php?type=1"];
    [self presentModalViewController:pub animated:YES];
}

- (IBAction)segmentIndexChanged:(id)sender
{
    UISegmentedControl *segmentControl = (UISegmentedControl *)sender;
    if (segmentControl.selectedSegmentIndex) {
        self.title = @"招领信息";
        if (self.find == nil) {
            [self initFindView];
            [self.view addSubview:self.find.view];
        } else {
            [self.view bringSubviewToFront:self.find.view];
        }
    } else {
        self.title = @"失物信息";
        if (self.lost == nil) {
            [self initLostView];
            [self.view addSubview:self.lost.view];
        } else {
            [self.view bringSubviewToFront:self.lost.view];
        }
    }
}

- (void)initFindView
{
    self.find = [[SVWebViewController alloc] initWithAddress:@"http://find.xidian.cc/mobile/list.php?type=2"];
    self.find.view.frame = CGRectMake(0, 30, VIEWFRAMESIZE.width, VIEWFRAMESIZE.height - 30);
    self.find.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:lost.view];
}

- (void)initLostView
{
    self.lost = [[SVWebViewController alloc] initWithAddress:@"http://find.xidian.cc/mobile/list.php?type=1"];
    self.lost.view.frame = CGRectMake(0, 30, VIEWFRAMESIZE.width, VIEWFRAMESIZE.height - 30);
    self.lost.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:lost.view];
}

@end
