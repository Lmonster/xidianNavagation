//
//  CCWeiboEngine.m
//  XidianNavigation
//
//  Created by ooops on 13-4-2.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCWeiboEngine.h"


@implementation CCWeiboEngine


- (void)getUserInfoFrom:(NSString *)url
       competionHandler:(weiboUserInfoBlock)userInfoBlock
           errorHandler:(MKNKErrorBlock)errorBlock
{
    MKNetworkOperation *operation = [self operationWithPath:url params:nil httpMethod:@"GET" ssl:YES];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            userInfoBlock(jsonObject);
        }];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        errorBlock(error);
        
    }];
    
    [self enqueueOperation:operation];
}


- (NSString *)cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"WeiboAvatars"];
    return cacheDirectoryName;
    
}


@end

