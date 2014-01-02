//
//  CCWeiboEngine.h
//  XidianNavigation
//
//  Created by ooops on 13-4-2.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "MKNetworkOperation.h"

@interface CCWeiboEngine : MKNetworkEngine

typedef void(^weiboUserInfoBlock)(id receivedJson);

- (void)getUserInfoFrom:(NSString *)url
       competionHandler:(weiboUserInfoBlock)userInfoBlock
           errorHandler:(MKNKErrorBlock)error;




@end
