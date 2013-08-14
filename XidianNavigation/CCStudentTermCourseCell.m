//
//  CCStudentTermCourseCell.m
//  XidianNavigation
//
//  Created by ooops on 13-4-21.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCStudentTermCourseCell.h"

@implementation CCStudentTermCourseCell

@synthesize classExamTime, classExamType, classInWeeks, className, classProperty, classRoom, classScore, classTeacher;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)cellContent
{
    self.className.text = cellContent[@"课程名称"];
    self.classTeacher.text = cellContent[@"教师"];
    self.classInWeeks.text = [self trimString:cellContent[@"周次"]];
    self.classScore.text = cellContent[@"学分"];
    self.classProperty.text = cellContent[@"必限任"];
    self.classExamType.text = cellContent[@"考查方式"];
    self.classRoom.text = cellContent[@"教室"];
    self.classExamTime.text = cellContent[@"考试日期"];
}

- (NSString *)trimString:(NSString *)stringToBeTrimed
{
    NSMutableArray *stringArray = [NSMutableArray arrayWithArray:[stringToBeTrimed componentsSeparatedByString:@"@"]];
    [stringArray removeLastObject];
    [stringArray removeObjectAtIndex:0];
    NSString *trimedString = [[[stringArray reverseObjectEnumerator] allObjects] componentsJoinedByString:@","];
    return trimedString;
}

@end
