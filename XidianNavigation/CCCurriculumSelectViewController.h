//
//  CCCurriculumSelectViewController.h
//  XidianNavigation
//
//  Created by ooops on 13-4-23.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCCurriculumSelectViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *studentButton;
@property (strong, nonatomic) IBOutlet UIButton *teacherButton;
@property (strong, nonatomic) IBOutlet UISwitch *rememberSwitch;
@property (strong, nonatomic) IBOutlet UILabel *currentRemember;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;

@property (strong, nonatomic) IBOutlet UIButton *studentSubmitButton;
@property (strong, nonatomic) IBOutlet UIButton *teacherSubmitButton;

@property (strong, nonatomic) IBOutlet UITextField *studentTextField;
@property (strong, nonatomic) IBOutlet UITextField *teacherTextField;
@property (strong, nonatomic) UITextField *currentTextField;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)studentOrTeacherButtonPressed:(id)sender;
- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)moreButtonPressed:(id)sender;
- (IBAction)didOffTheSwitch:(id)sender;

@end
