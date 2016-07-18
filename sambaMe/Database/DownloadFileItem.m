//
//  DownloadFileItem.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/14.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "DownloadFileItem.h"

@implementation DownloadFileItem

-(id)init {
    self = [super init];
    if (self) {
        self.currentSize = 0;
        self.totalSize = 0;
        self.readMark = NO;
    }
    return self;
}

@end
