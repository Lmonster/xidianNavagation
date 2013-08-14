//
//  CCTeacherWeekCell.h
//  XidianNavigation
//
//  Created by ooops on 13-4-24.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCTeacherWeekCourseCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *className;
@property (strong, nonatomic) IBOutlet UILabel *classRoom;
@property (strong, nonatomic) IBOutlet UILabel *classTime;
@property (strong, nonatomic) IBOutlet UILabel *classTeacher;
@property (strong, nonatomic) IBOutlet UILabel *classNumber;
@property (strong, nonatomic) IBOutlet UILabel *classInWeeks;

- (void)setData:(NSDictionary *)cellContent;

@end
