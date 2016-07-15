//
//  HostItem.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/14.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "HostItem.h"

@implementation HostItem


-(id)init {
    self = [super init];
    if(self) {
        self.sequence = -1;
        self.state = 0;
        self.type = 0;
    }
    return self;
}


@end
