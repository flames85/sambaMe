//
//  CachedFileItem.h
//  sambaMe
//
//  Created by Shao.Admin on 16/7/14.
//  Copyright © 2016年 sq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CachedFileItem : NSObject

-(id)init;

@property(nonatomic,copy)NSString                          *key;
@property(nonatomic,copy)NSString                          *localPath;
@property(nonatomic,copy)NSString                          *remotePath;

@property(nonatomic,assign)NSInteger                        size;
@property(nonatomic,assign)BOOL                             readMark;


@end
