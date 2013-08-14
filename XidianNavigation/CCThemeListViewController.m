//
//  CCThemeListViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-5-2.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCThemeListViewController.h"
#import "ThemeManager.h"

@interface CCThemeListViewController ()

@end

@implementation CCThemeListViewController

@synthesize selectedImage;

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
    
    self.title = @"界面风格";
    
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

- (void)viewWillAppear:(BOOL)animated
{
    NSString *currentTheme = [[NSUserDefaults standardUserDefaults] valueForKey:@"CCCurrentThemeName"];
    NSInteger i = currentTheme == nil ? 0 : [[self themes] indexOfObject:currentTheme];
    
    self.selectedImage.center = CGPointMake(i * 105 + 87, 34);
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom Methods

- (NSArray *)themes
{
    return @[kThemeDefault, kThemeMetro, kThemeGlass];
}

- (IBAction)selectThemeAtIndex:(UIButton *)sender
{
    int i = sender.tag - 420;
    
    [[ThemeManager sharedInstance]
     setTheme:[[self themes] objectAtIndex:i]];
    
    self.selectedImage.center = CGPointMake(i * 105 + 87, 34);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[self themes] objectAtIndex:i] forKey:@"CCCurrentThemeName"];
    [defaults synchronize];
}

@end
