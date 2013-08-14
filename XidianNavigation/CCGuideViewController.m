//
//  CCGuideViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-4-30.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCGuideViewController.h"
#import "CCMainViewController.h"

@interface CCGuideViewController ()

@end

@implementation CCGuideViewController

@synthesize scrollView, contentView;

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
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.scrollView addSubview:self.contentView];
    self.scrollView.contentSize = self.contentView.bounds.size;
    self.scrollView.bounces = NO;
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"guide_bg"]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"CCAppFirstLaunch"];
    [defaults synchronize];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterButtonPress:(id)sender
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"CCAppFirstLaunch"]) {
        CCMainViewController *main = [[CCMainViewController alloc] initWithNibName:@"CCMainViewController" bundle:nil];
        ApplicationDelegate.globalNavController = [[UINavigationController alloc] initWithRootViewController:main];
        ApplicationDelegate.revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:ApplicationDelegate.globalNavController];
        [ApplicationDelegate.revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionNavigationBar];
        ApplicationDelegate.revealSideViewController.view.frame = CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 20);
        
        [UIView transitionFromView:self.view
                            toView:ApplicationDelegate.revealSideViewController.view
                          duration:.8f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        completion:^(BOOL finished) {
                            self.view = nil;
                        }];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self dismissViewControllerAnimated:YES completion:^{
            self.view = nil;
        }];
    }
}

@end
