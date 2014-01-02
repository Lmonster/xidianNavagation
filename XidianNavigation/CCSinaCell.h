//
//  CCCustomSinaCell.h
//  CustomCell
//
//  Created by ooops on 13-4-5.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCSinaCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
@property (strong, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UIButton *unfollowButton;

- (void)setWeiboData:(NSDictionary *)userInfo;

@end
