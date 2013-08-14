//
//  CCTeacherWeekCell.m
//  XidianNavigation
//
//  Created by ooops on 13-4-24.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCTeacherWeekCourseCell.h"

@implementation CCTeacherWeekCourseCell

@synthesize classInWeeks, className, classNumber, classRoom, classTeacher, classTime;

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
//    NSArray *weeks = [NSArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"日", nil];
    self.className.text = cellContent[@"课程名称"];
    self.classRoom.text = cellContent[@"教室"];
    self.classTime.text = [NSString stringWithFormat:@"星期%@ 第%@节", cellContent[@"星期"], cellContent[@"节次"]];
    self.classTeacher.text = cellContent[@"教师"];
    self.classNumber.text = cellContent[@"班级"];
    self.classInWeeks.text = [self trimString:cellContent[@"周次"]];    
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
