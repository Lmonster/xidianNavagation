//
//  CCNewsEngine.h
//  XidianNavigation
//
//  Created by ooops on 13-3-17.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "MKNetworkOperation.h"

#define userInfoUrl(__at__,__sn__) [NSString stringWithFormat:@"2/users/show.json?access_token=%@&screen_name=%@", __at__, __sn__]

@interface CCXidianEngine : MKNetworkEngine

typedef void (^InfoJSONResponseBlock)(id InfoTitles);

@property (strong, nonatomic) MKNetworkOperation *operation;

- (void)getJSONFrom:(NSString *)relativeFilePathOnServer
  completionHandler:(InfoJSONResponseBlock)DataBlock
       errorHandler:(MKNKErrorBlock)errorBlock;



@end
