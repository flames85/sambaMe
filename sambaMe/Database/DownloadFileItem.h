//
//  DownloadFileItem
//  sambaMe
//
//  Created by Shao.Admin on 16/7/14.
//  Copyright © 2016年 sq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadFileItem : NSObject

-(id)init;

@property(nonatomic,copy)NSString                          *key;
@property(nonatomic,copy)NSString                          *localPath;
@property(nonatomic,copy)NSString                          *remotePath;

@property(nonatomic,assign)int64_t                         currentSize;
@property(nonatomic,assign)int64_t                         totalSize;

@property(nonatomic,copy)NSString                          *user;
@property(nonatomic,copy)NSString                          *password;

@property(nonatomic,assign)BOOL                            readMark;


@end
