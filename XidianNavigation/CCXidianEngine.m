//
//  CCNewsEngine.m
//  XidianNavigation
//
//  Created by ooops on 13-3-17.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCXidianEngine.h"

@implementation CCXidianEngine

@synthesize operation;

- (void)getJSONFrom:(NSString *)relativeFilePathOnServer
  completionHandler:(InfoJSONResponseBlock)DataBlock
       errorHandler:(MKNKErrorBlock)errorBlock
{
    self.operation = [self operationWithPath:relativeFilePathOnServer];
    
    [self.operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            DataBlock(jsonObject);
        }];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [self enqueueOperation:self.operation];
}

//- (void)getInfoFrom:(int)serverIndex
//  completionHandler:(InfoJSONResponseBlock)DataBlock
//       errorHandler:(MKNKErrorBlock)errorBlock
//{
//    switch (serverIndex) {
//        case XDNewsIndex:
//            self.operation = [self operationWithPath:@"newstitles.php"];
//            break;
//            
//        case XDAcademiaIndex:
//            self.operation = [self operationWithPath:@"wap/academiacontents.php"];
//            break;
//                        
//            
//        default:
//            break;
//    }
//    
//    [self.operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        
//        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
//            DataBlock(jsonObject);
//        }];
//        
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        
//        errorBlock(error);
//        
//    }];
//    
//    [self enqueueOperation:self.operation];
//}





@end
