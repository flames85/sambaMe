//
//  FavoriteItem.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/16.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "FavoriteItem.h"

@implementation FavoriteItem

-(id)init {
    self = [super init];
    if (self) {
        self.sequence = -1;
        self.isFile = YES;
        self.size = 0;
    }
    return self;
}

@end
