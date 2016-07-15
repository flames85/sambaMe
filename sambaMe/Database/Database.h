//
//  Database.h
//  sambaMe
//
//  Created by Shao.Admin on 16/7/14.
//  Copyright © 2016年 sq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HostItem;
@class CachedFileItem;


@interface Database : NSObject


+(Database*)sharedDatabase;

// host
-(NSMutableArray*)getAllHost;
-(BOOL)addHost:(HostItem*)item;
-(BOOL)delHostWithSequence:(NSInteger)sequence;
-(BOOL)updateHostStateWithSequence:(NSInteger)sequence withState:(BOOL)state withDesc:(NSString*)desc;
-(BOOL)updateAccessTimeWithSequence:(NSInteger)sequence withTime:(NSString*)time;

// cached
-(NSMutableArray*)getAllCachedFile;
-(BOOL)addCachedFileWithItem:(CachedFileItem*)item;
-(CachedFileItem*)getCachedFileWithHashKey:(NSString*)hashKey;

-(BOOL)delCachedFileWithHashKey:(NSString*)hashKey;


@end
