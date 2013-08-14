//
//  CCCustomSinaCell.m
//  CustomCell
//
//  Created by ooops on 13-4-5.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCSinaCell.h"
//#import <QuartzCore/QuartzCore.h>

@implementation CCSinaCell

@synthesize avatarView, screenNameLabel, userDescriptionLabel, followButton, unfollowButton;

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

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.avatarView.layer.cornerRadius = 8.0f;
    self.avatarView.layer.masksToBounds = YES;
    //    self.avatarView.backgroundColor = [UIColor clearColor];
    //    self.screenNameLabel.backgroundColor = [UIColor clearColor];
    //    self.userDescriptionLabel.backgroundColor = [UIColor clearColor];
    self.userDescriptionLabel.textColor = [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:1];
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.bounds;
//    UIColor *topColor = [UIColor colorWithRed:.87 green:.87 blue:.87 alpha:1];
//    UIColor *bottomColor = [UIColor colorWithRed:.8 green:0.8 blue:0.8 alpha:1];
//    gradient.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
//    
//    UIView *bgView = [[UIView alloc] init];
//    [bgView.layer insertSublayer:gradient atIndex:0];
//    self.backgroundView = bgView;
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"table_cell_bg", kPNGFileType)]];
    
}

- (void)setWeiboData:(NSDictionary *)userInfo
{
    UIImage *placeholderImage = [UIImage imageWithContentsOfFile:PathInMainBundle(@"weibo_avatar_placeholder", kPNGFileType)];
    
    [self.avatarView setImageFromURL:[NSURL URLWithString:[userInfo objectForKey:@"avatar_large"]] placeHolderImage:placeholderImage];
    self.screenNameLabel.text = [userInfo objectForKey:@"screen_name"];
    self.userDescriptionLabel.text = [userInfo objectForKey:@"description"];
}

@end
