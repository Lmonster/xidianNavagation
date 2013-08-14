//
//  CCCurriculumSelectViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-4-23.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CCCurriculumSelectViewController.h"
#import "CCCurriculumStudentViewController.h"
#import "CCCurriculumTeacherViewController.h"

@interface CCCurriculumSelectViewController ()
- (IBAction)hideKeyboard;
@end

@implementation CCCurriculumSelectViewController

@synthesize studentSubmitButton, studentTextField, studentButton;
@synthesize teacherSubmitButton, teacherTextField, teacherButton;
@synthesize currentTextField, scrollView, moreButton, rememberSwitch, currentRemember;


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
    self.title = @"西电课表";
    
    self.studentTextField.layer.borderWidth = .5f;
    self.studentTextField.layer.cornerRadius = 10.0f;
    self.studentTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.studentTextField.backgroundColor = [UIColor whiteColor];
    
    self.teacherTextField.layer.borderWidth = .5f;
    self.teacherTextField.layer.cornerRadius = 10.0f;
    self.teacherTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.teacherTextField.backgroundColor = [UIColor whiteColor];
    

    NSArray *customButtons = [NSArray arrayWithObjects:self.studentSubmitButton, self.teacherSubmitButton, self.studentButton, self.teacherButton, self.moreButton, nil];
    for (UIButton *btn in customButtons) {
        [btn setBackgroundImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"curriculum_select_button", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30)] forState:UIControlStateNormal];
        btn.showsTouchWhenHighlighted = YES;
    }
    
    
    UIImage *backButtonImageNormal = [[UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_back", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 5)];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setBackButtonBackgroundImage:backButtonImageNormal
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsDefault];
    

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidAppear:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
 
    // Swipe to right will appear reveal view
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showLeft)];
    
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeRight];

}

- (void)viewWillAppear:(BOOL)animated
{
    self.currentRemember.hidden = NO;
    NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults];
    id value = [defautls valueForKey:@"curriculumClassNumberOrTeacherName"];
    BOOL isTeacher = [value intValue] ? YES : NO;
    BOOL isStudent = [value intValue] == 0 && [value length] ? YES : NO;
    if (isTeacher) {
        self.rememberSwitch.onTintColor = [UIColor colorWithRed:0.23f green:0.58f blue:0.24f alpha:1.00f];
        self.currentRemember.text = [NSString stringWithFormat:@"当前: %@", value];
    } else if (isStudent){
        self.rememberSwitch.onTintColor = [UIColor colorWithRed:0.77f green:0.42f blue:0.76f alpha:1.00f];
        self.currentRemember.text = [NSString stringWithFormat:@"当前: %@", value];
    } else {
        self.rememberSwitch.onTintColor = [UIColor colorWithRed:0.26f green:0.67f blue:1.00f alpha:1.00f];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:NO];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Custom Actions

- (void)showLeft
{
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
}

- (IBAction)hideKeyboard
{
    [self.studentTextField resignFirstResponder];
    [self.teacherTextField resignFirstResponder];
}

- (IBAction)studentOrTeacherButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    CGRect newFrame = button.frame;
    newFrame.size.width = 64;
    newFrame.origin.x = 236;
    
    [button setTitle:@"提交" forState:UIControlStateNormal];

    [UIView animateWithDuration:.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         button.frame = newFrame;
                     } completion:^(BOOL finished) {
                         button.hidden = YES;
                     }];
    
    for (UIButton *btn in [NSArray arrayWithObjects:self.studentButton, self.teacherButton, nil]) {
        if (btn.hidden) {
            
            double delayInSeconds = 200;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_MSEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSString *str = (btn == self.studentButton) ? @"我是学生" : @"我是老师";
                [btn setTitle:str forState:UIControlStateNormal];
            });
            
            CGRect newFrame = btn.frame;
            newFrame.origin.x = 20;
            newFrame.size.width = 280;
            [UIView animateWithDuration:.5f
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 btn.hidden = NO;
                                 btn.frame = newFrame;
                             } completion:^(BOOL finished) {
                                 
                             }];
        }
    }
}


- (void)submitButtonPressed:(id)sender
{
    [self hideKeyboard];
    NSString *validInputText = [self.currentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.studentButton.hidden) {
        
        if (validInputText.length == 0) {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"您好像什么都没填呢"
                                       delegate:nil
                              cancelButtonTitle:@"好的"
                              otherButtonTitles:nil, nil] show];
        } else if (validInputText.length > 0 && validInputText.length != 6) {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"您的输入长度不对哦"
                                       delegate:nil
                              cancelButtonTitle:@"好的"
                              otherButtonTitles:nil, nil] show];
        } else {
            CCCurriculumStudentViewController *student = [[CCCurriculumStudentViewController alloc] init];
            student.query = validInputText;
            [self.navigationController pushViewController:student animated:YES];
            if (self.rememberSwitch.isOn) {
                [[NSUserDefaults standardUserDefaults] setObject:validInputText forKey:@"curriculumClassNumberOrTeacherName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    } else {
        if (validInputText.length == 0) {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"您好像什么都没填呢"
                                       delegate:nil
                              cancelButtonTitle:@"好的"
                              otherButtonTitles:nil, nil] show];
        } else if (validInputText.length < 2 && validInputText.length > 5) {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"您的输入长度不对哦"
                                       delegate:nil
                              cancelButtonTitle:@"好的"
                              otherButtonTitles:nil, nil] show];
        } else {
            CCCurriculumTeacherViewController *teacher = [[CCCurriculumTeacherViewController alloc] init];
            teacher.query = validInputText;
            [self.navigationController pushViewController:teacher animated:YES];
            if (self.rememberSwitch.isOn) {
                
                [[NSUserDefaults standardUserDefaults] setObject:validInputText forKey:@"curriculumClassNumberOrTeacherName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }

        }
    }
}

- (IBAction)moreButtonPressed:(id)sender
{
    SVWebViewController *web = [[SVWebViewController alloc] initWithAddress:@"http://kb.xidian.cc/m"];
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)didOffTheSwitch:(id)sender
{
    UISwitch *theSwitch = (UISwitch *)sender;
    if (!theSwitch.isOn) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"curriculumClassNumberOrTeacherName"];
        [defaults synchronize];
    } else {
        self.rememberSwitch.onTintColor = [UIColor colorWithRed:0.26f green:0.67f blue:1.00f alpha:1.00f];
    }
    self.currentRemember.hidden = YES;
}

#pragma mark - Text Field Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
}


#pragma mark - Keyboard Delegate Methods

- (void)keyboardDidAppear:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect frame = self.scrollView.frame;
    frame.size.height -= keyboardSize.height;
    
    CGPoint currentTextFieldLeftBottomOrigin = CGPointMake(0,
                                                           self.currentTextField.frame.origin.y
                                                           + self.currentTextField.frame.size.height);
    
    if (!CGRectContainsPoint(frame, currentTextFieldLeftBottomOrigin)) {
        //    if (CGRectIntersectsRect(frame, self.currentTextField.frame) || !CGRectContainsRect(frame, self.currentTextField.frame)) {
        
        
        CGFloat pointY = self.currentTextField.frame.origin.y - frame.size.height + 70;
        CGPoint scrollToPoint = CGPointMake(0, pointY);
        
        [self.scrollView setContentOffset:scrollToPoint animated:YES];
        //        [self.scrollView scrollRectToVisible:self.currentTextField.frame animated:YES];
    }
}

- (void)keyboardWillDisappear:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}




@end
