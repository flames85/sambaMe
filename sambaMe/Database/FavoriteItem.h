//
//  FavoriteItem.h
//  sambaMe
//
//  Created by Shao.Admin on 16/7/16.
//  Copyright © 2016年 sq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteItem : NSObject

-(id)init;

@property(nonatomic,assign)int64_t                         sequence;
@property(nonatomic,copy)NSString                          *remotePath;
@property(nonatomic,assign)BOOL                            isFile;
@property(nonatomic,assign)int64_t                         size;

@property(nonatomic,copy)NSString                          *user;
@property(nonatomic,copy)NSString                          *password;
@end
