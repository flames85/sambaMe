//
//  DownloadingItem.h
//  sambaMe
//
//  Created by Shao.Admin on 16/7/18.
//  Copyright © 2016年 sq. All rights reserved.
//

#import <Foundation/Foundation.h>


@class KxSMBItemFile;

@interface DownloadingItem : NSObject

@property(nonatomic,copy)NSString                          *key;
@property(nonatomic,copy)NSString                          *remotePath;
@property(nonatomic,copy)NSString                          *user;
@property(nonatomic,copy)NSString                          *password;


@property(nonatomic,copy)NSString                          *localPath;
@property(nonatomic,assign)int64_t                         currentSize;
@property(nonatomic,assign)int64_t                         totalSize;
@property (readwrite, nonatomic, strong) KxSMBItemFile     *smbFile;
@property (nonatomic, strong) NSFileHandle                 *fileHandle;

@end
