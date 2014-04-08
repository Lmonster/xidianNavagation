//
//  UIColor+HexColor.m
//  XidianNavigation
//
//  Created by ooops on 13-4-3.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+ (UIColor *)colorWithHexColor:(NSString *)hexColor alpha:(CGFloat)alpha
{
    NSString *hex = [hexColor substringFromIndex:1];
    
    unsigned int red = -1;
    unsigned int green = -1;
    unsigned int blue = -1;
    
    [[NSScanner scannerWithString:[hex substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&red];
    [[NSScanner scannerWithString:[hex substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&green];
    [[NSScanner scannerWithString:[hex substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)red/255 green:(float)green/255 blue:(float)blue/255 alpha:alpha];
}


@end
