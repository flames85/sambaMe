//
//  CachedFileItem.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/14.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "CachedFileItem.h"

@implementation CachedFileItem

-(id)init {
    self = [super init];
    if (self) {
        self.size = 0;
        self.readMark = NO;
    }
    return self;
}

@end
