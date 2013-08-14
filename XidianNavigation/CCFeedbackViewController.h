//
//  CCTestViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-2-18.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCFeedbackViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UITextField *themeField;
@property (strong, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UITextField *deviceField;
@property (strong, nonatomic) IBOutlet UITextField *systemField;
@property (strong, nonatomic) IBOutlet UITextField *versionField;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *userContact;
@property (strong, nonatomic) UITextField *currentTextField;

@property (strong, nonatomic) NSString *defaultTextViewContent;

- (IBAction)disappearKeyboard;

@end
