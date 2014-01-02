//
//  CCAppDelegate.h
//  XidianNavigation
//
//  Created by ooops on 13-2-18.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCXidianEngine.h"
#import "CCWeiboEngine.h"


#define kPNGFileType                            @"png"
#define kJPEGFileType                           @"jpg"
#define kGIFFileType                            @"gif"
#define kPLISTFileType                          @"plist"
#define kNOExtensionType                        nil


#define ApplicationDelegate                     ((CCAppDelegate *)[UIApplication sharedApplication].delegate)
#define PathInMainBundle(_name_, _type_)        [[NSBundle mainBundle] pathForResource:_name_ ofType:_type_]
#define URLInMainBundle(_name_, _type_)          [[NSBundle mainBundle] pathForResource:_name_ ofType:_type_]
#define VIEWFRAMESIZE                           self.view.frame.size
#define MARGIN                                  10.0f


#define kAppKey             @"744699773"
#define kAppSecret          @"b063d79f5ed02392b25c5bc1a3722eda"
#define kAppRedirectURI     @"http://ooopscc.com"


@class PPRevealSideViewController;
@class SinaWeibo;
@class CCSinaWeiboViewController;
@class CCSideViewController;

enum {
    XDIndexPage,                    //主页
    XDTimeIndex,                    //时间    http://time.xidian.cc
    XDTelephoneIndex,               //电话    http://tel.xidian.cc/m
    XDCurriculumScheduleIndex,      //课表    http://kb.xidian.cc/m
    XDNewsIndex,                    //新闻    http://news.xidian.cc
    XDTeacherPagesIndex,            //教师    http://web.xidian.edu.cn/wap
    XDRecuitmentIndex,              //招聘    http://job.xidian.edu.cn
    XDAcademiaIndex,                //学术    http://meeting.xidian.edu.cn
    XDWelcomeNewbieIndex,           //迎新    http://new.xidian.cc/m
    XDMapIndex,                     //地图    http://map.xidian.cc/m
    XDCEERIndex,                    //高考录取  (college entrance examination recruitment)  http://www.xidian.cc/app/all2013/2013query.html
    XDSinaWeiboIndex,               //微博
    XDLostAndFindIndex,             //失物招领  http://find.xidian.cc/mobile/index.php?type=1 && http://find.xidian.cc/mobile/index.php?type=2
    XDTotalCount,                   //总数
};



@interface CCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *globalNavController;
@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;
@property (strong, nonatomic) CCSinaWeiboViewController *sinaWeiboViewController;
@property (strong, nonatomic) CCSideViewController *sideViewController;

@property (strong, nonatomic) CCReachability *reachability;

@property (strong, nonatomic) CCXidianEngine *newsEngine;
@property (strong, nonatomic) CCXidianEngine *academiaEngine;
@property (strong, nonatomic) CCXidianEngine *recuitmentEngine;
@property (strong, nonatomic) CCXidianEngine *telEngine;
@property (strong, nonatomic) CCWeiboEngine *weiboEngine;
@property (strong, nonatomic) CCXidianEngine *curriculumEngine;

@property (strong, nonatomic) SinaWeibo *sinaWeibo;

@end
