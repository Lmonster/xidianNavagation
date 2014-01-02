//
//  CCTestViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-2-18.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CCFeedbackViewController.h"
#import "UIDevice+Hardware.h"


@interface CCFeedbackViewController ()

- (void)sendFeedbackMessage:(id)sender;
- (void)keyboardDidAppear:(NSNotification *)aNotification;
- (void)keyboardWillDisappear:(NSNotification *)aNotification;

@end

@implementation CCFeedbackViewController

@synthesize scrollView, contentView;

@synthesize feedbackTextView, themeField, bottomView;
@synthesize deviceField, systemField, versionField, userName, userContact, currentTextField;
@synthesize defaultTextViewContent;

#pragma mark - Application Lifecycle Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dismissViewController
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.

    // Configure NavBar
    self.title = @"意见反馈";
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageWithContentsOfFile:PathInMainBundle(@"nav_top", kPNGFileType)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)]
                                                  forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_common", kPNGFileType)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_common_active", kPNGFileType)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImageNormal = [[UIImage imageNamed:@"btn_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 5)];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonBackgroundImage:backButtonImageNormal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImageActive = [[UIImage imageNamed:@"btn_back_active.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 5)];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonBackgroundImage:backButtonImageActive forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor blackColor], UITextAttributeTextColor,
                                [UIColor colorWithWhite:1.0 alpha:0.8], UITextAttributeTextShadowColor,
                                [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                nil];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:attributes forState:UIControlStateDisabled];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    // Some Initial
    self.defaultTextViewContent = @"内容";
    self.feedbackTextView.text = self.defaultTextViewContent;
    
    // Set left and right BarButton, ##left when in presentviewcontroller method
    if ([self.navigationController.viewControllers count] == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController)];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:nil];
    
    // Custom bottom View Style
    self.bottomView.layer.cornerRadius = 5.0;
    self.bottomView.layer.borderWidth = 1.0;
    self.bottomView.layer.borderColor = [[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1] CGColor];

    
    // Custom feedbackTextView Style
//    self.feedbackTextView.layer.cornerRadius = 5.0;
//    self.feedbackTextView.layer.borderWidth = 1.0;
//    self.feedbackTextView.layer.borderColor = [[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1] CGColor];
    self.feedbackTextView.font = [UIFont systemFontOfSize:14.0f];
    self.feedbackTextView.clipsToBounds = YES;
    self.feedbackTextView.textColor = [UIColor colorWithWhite:.7 alpha:1];
    
    // Custom themeTextField Style
    [self.userName becomeFirstResponder];
//    self.themeField.layer.cornerRadius = 5.0;
//    self.themeField.layer.borderWidth = 1.0;
//    self.themeField.layer.borderColor = [[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1] CGColor];
//    self.themeField.clipsToBounds = YES;
//    self.themeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 8, 20)];
//    self.themeField.leftViewMode = UITextFieldViewModeAlways;
    
    NSArray *textfields = [NSArray arrayWithObjects:self.deviceField,
                           self.systemField, self.versionField, self.userName, self.userContact, nil];
    NSArray *textfiledLabels = [NSArray arrayWithObjects:@"设备型号:  ",
                                @"系统版本:  ", @"软件版本:  ", @"尊姓大名:  ", @"联系方式:  ", nil];
    
    for (int i=0; i<[textfields count]; i++) {
        UITextField *textfield = (UITextField *)[textfields objectAtIndex:i];
        NSString *textlabel = [textfiledLabels objectAtIndex:i];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 100, 20)];
        label.text = textlabel;
        label.textAlignment = UITextAlignmentRight;
        [label setFont:[UIFont systemFontOfSize:13]];
        
        textfield.leftViewMode = UITextFieldViewModeAlways;
        textfield.leftView = label;
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.layer.cornerRadius = 5.0;
        textfield.layer.borderColor = [[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1] CGColor];
        textfield.layer.borderWidth = 1.0;
    }
    
    // Get infomation about user
    self.deviceField.text = [NSString stringWithFormat:@"%@ %@",
                             [[UIDevice currentDevice] platformString],
                             [[UIDevice currentDevice] isJailBreak] ? @"(已越狱)" : @""];
    self.systemField.text = [NSString stringWithFormat:@"%@ %@",[[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
    self.versionField.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    
    // Custom Scroll View
    //    self.contentView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.contentView];
    self.scrollView.contentSize = self.contentView.frame.size;
    [self.scrollView alwaysBounceVertical];
    
    // Register Keyboard Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidAppear:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom Methods

- (void)sendFeedbackMessage:sender
{
    if (self.userName.text != nil && self.userContact != nil && self.themeField != nil && self.feedbackTextView.text != nil) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:[NSArray arrayWithObject:@"xidiancc@163.com"]];
        [mailViewController setSubject:self.themeField.text];
        [mailViewController setMessageBody:self.feedbackTextView.text isHTML:NO];
        [self presentViewController:mailViewController animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"您好像还有没填的项哦" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
    }
}

- (IBAction)disappearKeyboard
{
    [self.feedbackTextView resignFirstResponder];
    [self.currentTextField resignFirstResponder];
//    [self.themeField resignFirstResponder];
}



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


#pragma mark - Mail Compose Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"感谢您的反馈" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:.7f];
}


#pragma mark - TextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:self.defaultTextViewContent]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.text = self.defaultTextViewContent;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    textView.textColor = [UIColor colorWithWhite:0 alpha:1];
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 4 && ![textView.text isEqualToString:self.defaultTextViewContent]) {
        [self.navigationItem.rightBarButtonItem setBackgroundImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_lightblue", kPNGFileType)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor], UITextAttributeTextColor,
                                    [UIColor colorWithWhite:0 alpha:0.3], UITextAttributeTextShadowColor,
                                    [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                    nil];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [self.navigationItem.rightBarButtonItem setAction:@selector(sendFeedbackMessage:)];
    }
    else {
        [self.navigationItem.rightBarButtonItem setBackgroundImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"btn_common", kPNGFileType)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor blackColor], UITextAttributeTextColor,
                                    [UIColor colorWithWhite:1 alpha:0.8], UITextAttributeTextShadowColor,
                                    [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                    nil];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [self.navigationItem.rightBarButtonItem setAction:nil];
    }
}


#pragma mark - TextFiled Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentTextField = nil;
}


@end
