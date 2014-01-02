//
//  CCStudentTermCourseCell.h
//  XidianNavigation
//
//  Created by ooops on 13-4-21.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCStudentTermCourseCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *className;
@property (strong, nonatomic) IBOutlet UILabel *classTeacher;
@property (strong, nonatomic) IBOutlet UILabel *classInWeeks;
@property (strong, nonatomic) IBOutlet UILabel *classScore;
@property (strong, nonatomic) IBOutlet UILabel *classProperty;
@property (strong, nonatomic) IBOutlet UILabel *classExamType;
@property (strong, nonatomic) IBOutlet UILabel *classRoom;
@property (strong, nonatomic) IBOutlet UILabel *classExamTime;


- (void)setData:(NSDictionary *)cellContent;

@end
