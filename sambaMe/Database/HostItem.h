//
//  HostItem.h
//  sambaMe
//
//  Created by Shao.Admin on 16/7/14.
//  Copyright © 2016年 sq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostItem : NSObject

-(id)init;

@property(nonatomic,assign)NSInteger                            sequence;
@property(nonatomic,copy)NSString                               *host;
@property(nonatomic,copy)NSString                               *user;
@property(nonatomic,copy)NSString                               *password;
@property(nonatomic,copy)NSString                               *desc;
@property(nonatomic,copy)NSString                               *time;
@property(nonatomic,assign)BOOL                                 state;
@property(nonatomic,assign)int                                  type;


@end
