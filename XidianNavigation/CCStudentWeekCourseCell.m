//
//  CCStudentCourseCell.m
//  XidianNavigation
//
//  Created by ooops on 13-4-15.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCStudentWeekCourseCell.h"

@implementation CCStudentWeekCourseCell

@synthesize classLabel1, classLabel2;
@synthesize classRoom, className, classProperty, classTeacher, classTime;

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

@end
