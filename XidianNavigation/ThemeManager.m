//
//  ThemeManager.m
//  SkinnedUI
//
//  Created by QFish on 12/3/12.
//  Copyright (c) 2012 QFish.Net. All rights reserved.
//

#import "ThemeManager.h"

NSString * const kThemeDidChangeNotification = @"ThemeDidChangeNotification";

@implementation ThemeManager

@synthesize theme = _theme;

+ (ThemeManager *)sharedInstance
{
    static dispatch_once_t once;
    static ThemeManager *instance = nil;
    dispatch_once( &once, ^{
        instance = [[ThemeManager alloc] init];
    });
    return instance;
}

- (void)setTheme:(NSString *)theme
{
    if (_theme) {
        _theme = nil;
    }
    _theme = [theme copy];

    // post notification to notify the observers that the theme has changed
    ThemeStatus status = kThemeDidChangeNotification;

    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification
                                                        object:[NSNumber numberWithInt:status]];
}

- (UIImage *)imageWithImageName:(NSString *)imageName
{
    NSString *directory = [NSString stringWithFormat:@"%@/%@", @"theme", [self theme]];

    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName
                                                          ofType:@"png"
                                                     inDirectory:directory];

    return [UIImage imageWithContentsOfFile:imagePath];
}

- (NSString *)theme
{    
    if ( _theme == nil )
    {
        return kThemeDefault;
    }
    return _theme;
}

@end
