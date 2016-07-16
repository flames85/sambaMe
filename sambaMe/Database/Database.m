//
//  Database.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/14.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "Database.h"

#import "FMDatabase.h"
#import "HostItem.h"
#import "CachedFileItem.h"
#import "FavoriteItem.h"

static Database *gl_database = nil;


@implementation Database {
    // 数据库
    FMDatabase   *_fmdb;
}

+(Database*)sharedDatabase
{
    if(gl_database == nil)
    {
        gl_database = [[Database alloc] init];
    }
    return gl_database;
}


-(id)init {
    
    if(self = [super init])
    {
        _fmdb = [FMDatabase databaseWithPath:[self getDbFilePath:@"sambaMe.db"]];
        if([_fmdb open])
        {
            [self createHostTable];
            [self createCachedFileTable];
            [self createFavoriteTable];
        }
    }
    return self;
}

-(NSString*)getDbFilePath:(NSString *)fileName
{
    // 获得当前程序的沙盒目录
    NSString *path = NSHomeDirectory();
    // documents，tmp，library
    // 拼接路径：Library/Caches
    path = [path stringByAppendingPathComponent:@"Library/Caches/"];
    NSFileManager *fm = [NSFileManager defaultManager];
    // 检查要保存的文件名是否存在
    if([fm fileExistsAtPath:path])
    {
        // 检查要保存的文件名是否合法
        if(fileName&&[fileName length]!=0)
        {
            // 拼接路径
            path = [path stringByAppendingPathComponent:fileName];
        }
    }
    else
    {
        NSLog(@"(db)缓存目录不存在");
    }
    return path;
}

// 创建表
-(void)createHostTable
{
    NSString *sql = @"create table if not exists tb_host("
    @"sequence INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
    @"host TEXT(1024) NOT NULL,"
    @"user TEXT(1024),"
    @"password TEXT(1024),"
    @"time TEXT(1024),"
    @"desc TEXT(1024),"
    @"state INT DEFAULT 0,"
    @"type INT DEFAULT -1)";
    
    // 执行sql语句，创建表，增，删，改都用这个方法
    if([_fmdb executeUpdate:sql])
    {
        NSLog(@"(db)create tb_host if not exists 成功");
        
    }
    else
    {
        NSLog(@"(db)create tb_host if not exists 失败：%@",[_fmdb lastErrorMessage]);
    }
}
-(void)createCachedFileTable
{
    NSString *sql = @"create table if not exists tb_cachedfile("
    @"key TEXT(1024) PRIMARY KEY NOT NULL,"
    @"localpath TEXT(1024),"
    @"remotepath TEXT(1024),"
    @"size LONG LONG INT DEFAULT 0,"
    @"readmark INT DEFAULT 0"
    @")";
    
    // 执行sql语句，创建表，增，删，改都用这个方法
    if([_fmdb executeUpdate:sql])
    {
        NSLog(@"(db)create tb_cachedfile if not exists 成功");
        
    }
    else
    {
        NSLog(@"(db)create tb_cachedfile if not exists 失败：%@",[_fmdb lastErrorMessage]);
    }
}
-(void)createFavoriteTable {
    NSString *sql = @"create table if not exists tb_favorite("
    @"sequence INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
    @"remotepath TEXT(1024),"
    @"isfile INT DEFAULT 1,"
    @"size LONG LONG INT DEFAULT 0,"
    @"user TEXT(1024),"
    @"password TEXT(1024)"
    @")";
    
    // 执行sql语句，创建表，增，删，改都用这个方法
    if([_fmdb executeUpdate:sql])
    {
        NSLog(@"(db)create tb_favorite if not exists 成功");
        
    }
    else
    {
        NSLog(@"(db)create tb_favorite if not exists 失败：%@",[_fmdb lastErrorMessage]);
    }
}

-(BOOL)addHost:(HostItem*)item {

    NSString *sql = [NSString stringWithFormat:@"INSERT INTO tb_host(host,user,password,state,desc,time,type)"
                     @"values(?,?,?,?,?,?,?)"];
    
    if(![_fmdb executeUpdate:sql, item.host, item.user, item.password, @(item.state), item.desc, item.time, @(item.type)])
    {
        NSLog(@"(db)插入失败：%@", [_fmdb lastErrorMessage]);
        return NO;
    }
    NSLog(@"(db)插入成功");
    return YES;
}

-(NSMutableArray*)getAllHost
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_host ORDER BY sequence DESC"]; // 逆序取出,这样最新的在最上面
    
    NSMutableArray *itemArray = [[NSMutableArray alloc ] init];
    // 执行查询
    FMResultSet *ret = [_fmdb executeQuery:sql];
    
    while([ret next])
    {
        HostItem *item = [[HostItem alloc] init];
        item.sequence = [[ret stringForColumn:@"sequence"] intValue];
        item.host = [ret stringForColumn:@"host"];
        item.user = [ret stringForColumn:@"user"];
        item.password = [ret stringForColumn:@"password"];
        item.state = [[ret stringForColumn:@"state"] boolValue];
        item.desc = [ret stringForColumn:@"desc"];
        item.time = [ret stringForColumn:@"time"];
        item.type = [[ret stringForColumn:@"type"] intValue];
        
        [itemArray addObject:item];
    }
    return itemArray;
}

-(BOOL)delHostWithSequence:(NSInteger)sequence {
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM tb_host WHERE sequence=(?)"];
    
    // 执行查询
    if(![_fmdb executeUpdate:sql, @(sequence)])
    {
        NSLog(@"(db)删除[%@]失败：%@", @(sequence), [_fmdb lastErrorMessage]);
        return NO;
    }
    NSLog(@"(db)删除[%@]成功", @(sequence));
    return YES;
}

-(BOOL)updateHostStateWithSequence:(NSInteger)sequence withState:(BOOL)state withDesc:(NSString*)desc {
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE tb_host SET state=(?),desc=(?) where sequence=(?)"];
    
    if(![_fmdb executeUpdate:sql, @(state), desc, @(sequence)])
    {
        NSLog(@"(db)更新失败：%@", [_fmdb lastErrorMessage]);
        return NO;
    }
    
    NSLog(@"(db)更新成功");
    return YES;

}

-(BOOL)updateAccessTimeWithSequence:(NSInteger)sequence withTime:(NSString*)time withDesc:desc {
    NSString *sql = [NSString stringWithFormat:@"UPDATE tb_host SET time=(?), state=(?), desc=(?) where sequence=(?)"];
    
    if(![_fmdb executeUpdate:sql, time, @(YES), desc, @(sequence)])
    {
        NSLog(@"(db)更新失败：%@", [_fmdb lastErrorMessage]);
        return NO;
    }
    
    NSLog(@"(db)更新成功");
    return YES;
}


/////////////////////////////////////////////////

-(NSMutableArray*)getAllCachedFile {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_cachedfile"];
    
    NSMutableArray *itemArray = [[NSMutableArray alloc ] init];
    // 执行查询
    FMResultSet *ret = [_fmdb executeQuery:sql];
    
    while([ret next])
    {
        CachedFileItem *item = [[CachedFileItem alloc] init];
        item.key = [ret stringForColumn:@"key"];
        item.localPath = [ret stringForColumn:@"localpath"];
        item.remotePath = [ret stringForColumn:@"remotepath"];
        item.size = [[ret stringForColumn:@"size"] integerValue];
        item.readMark = [[ret stringForColumn:@"readmark"] boolValue];
        [itemArray addObject:item];
    }
    return itemArray;
}

-(BOOL)addCachedFileWithItem:(CachedFileItem*)item {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO tb_cachedfile(key,localpath,remotepath,size,readmark)"
                     @"values(?,?,?,?,?)"];
    
    if(![_fmdb executeUpdate:sql, item.key, item.localPath, item.remotePath, @(item.size), @(item.readMark)])
    {
        NSLog(@"(db)插入失败：%@", [_fmdb lastErrorMessage]);
        return NO;
    }
    NSLog(@"(db)插入成功");
    return YES;
}
-(CachedFileItem*)getCachedFileWithKey:(NSString*)key {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_cachedfile where key=(?)"];
    
    // 执行查询
    FMResultSet *ret = [_fmdb executeQuery:sql, key];
    CachedFileItem *item = nil;
    if([ret next])
    {
        item = [[CachedFileItem alloc] init];
        item.key = [ret stringForColumn:@"key"];
        item.localPath = [ret stringForColumn:@"localpath"];
        item.remotePath = [ret stringForColumn:@"remotepath"];
        
        item.size = [[ret stringForColumn:@"size"] integerValue];
        
        item.readMark = [[ret stringForColumn:@"readmark"] boolValue];
    }
    return item;
    
}
-(BOOL)delCachedFileWithKey:(NSString*)key {
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM tb_cachedfile WHERE key=(?)"];
    
    // 执行查询
    if(![_fmdb executeUpdate:sql, key])
    {
        NSLog(@"(db)删除[%@]失败：%@", key, [_fmdb lastErrorMessage]);
        return NO;
    }
    NSLog(@"(db)删除[%@]成功", key);
    return YES;
}


-(NSMutableArray*)getAllFavorite {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_favorite ORDER BY sequence DESC"];
    
    NSMutableArray *itemArray = [[NSMutableArray alloc ] init];
    // 执行查询
    FMResultSet *ret = [_fmdb executeQuery:sql];
    
    while([ret next])
    {
        FavoriteItem *item = [[FavoriteItem alloc] init];
        item.sequence = [[ret stringForColumn:@"sequence"] longLongValue];
        item.remotePath = [ret stringForColumn:@"remotepath"];
        item.size = [[ret stringForColumn:@"size"] longLongValue];
        item.isFile = [[ret stringForColumn:@"isfile"] boolValue];
        item.user = [ret stringForColumn:@"user"];
        item.password = [ret stringForColumn:@"password"];
        [itemArray addObject:item];
    }
    return itemArray;

}
-(BOOL)addFavoriteWithItem:(FavoriteItem*)item {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO tb_favorite(remotepath,size,isfile,user,password)"
                     @"values(?,?,?,?,?)"];
    
    if(![_fmdb executeUpdate:sql, item.remotePath, @(item.size), @(item.isFile), item.user, item.password])
    {
        NSLog(@"(db)插入失败：%@", [_fmdb lastErrorMessage]);
        return NO;
    }
    NSLog(@"(db)插入成功");
    return YES;

}
-(BOOL)delFavoriteWithKey:(NSInteger)sequence {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM tb_favorite WHERE sequence=(?)"];
    
    // 执行查询
    if(![_fmdb executeUpdate:sql, @(sequence)])
    {
        NSLog(@"(db)删除[%@]失败：%@", @(sequence), [_fmdb lastErrorMessage]);
        return NO;
    }
    NSLog(@"(db)删除[%@]成功", @(sequence));
    return YES;
}

@end
