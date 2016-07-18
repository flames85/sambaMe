//
//  MeDownloadFileVC.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/14.
//  Copyright © 2016年 sq. All rights reserved.
//
#import <QuickLook/QuickLook.h>
#import "MeDownloadFileVC.h"
#import "Database.h"
#import "CommonTool.h"
#import "DownloadTableViewCell.h"
#import "Common.h"
#import "DownloadFileItem.h"
#import "KxSMBProvider.h"
#import "DownloadingItem.h"

@interface MeDownloadFileVC () <KxSMBProviderDelegate,UITableViewDelegate,UITableViewDataSource,QLPreviewControllerDelegate,QLPreviewControllerDataSource>
@end

@implementation MeDownloadFileVC {
    NSMutableArray          *_items;
    UITableView             *_tableView;
    KxSMBProvider           *_provider;
    NSMutableDictionary     *_downloadingDic;
}

-(id) init {
    self = [super init];
    if (self) {
        _provider = [KxSMBProvider sharedSmbProvider];
        _provider.delegate = self;
        
        _downloadingDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)viewDidLoad {
    // tableview
    _tableView = [[UITableView alloc] init];
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    // add
    [self.view addSubview:_tableView];
    
    // 上
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    // 下
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    // 左
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    // 右
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    // delegate
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 数据
    _items = [[NSMutableArray alloc] init];
}

-(void)updateRowLocalPathWithKey:(NSString*)key withLocalPath:(NSString*)localPath {
    NSInteger index = 0;
    for (DownloadFileItem *item in _items) {
        if ([item.key isEqualToString:key]) {
            // 更新数据
            item.localPath = localPath;
            // 更新cell
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        ++index;
    }
}

-(void)updateRowCurrentSizeWithKey:(NSString*)key withCurrentSize:(int64_t)currentSize {
    
    NSInteger index = 0;
    for (DownloadFileItem *item in _items) {
        if ([item.key isEqualToString:key]) {
            // 更新数据
            item.currentSize = currentSize;
            // 更新cell
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        ++index;
    }
}

//- (void)stopDownloadWithItem:(DownloadingItem*)item
//{
//    if (item.fileHandle) {
//        
//        [item.fileHandle closeFile];
//        item.fileHandle = nil;
//    }
//    if (item.smbFile) {
//        [item.smbFile close];
//        item.smbFile = nil;
//    }
//}

-(BOOL)stopDownloadWithKey:(NSString*)key {
    DownloadingItem *downloadingItem = [_downloadingDic objectForKey:key];
    if (downloadingItem) {
        if (downloadingItem.fileHandle) {
            
            [downloadingItem.fileHandle closeFile];
            downloadingItem.fileHandle = nil;
        }
        if (downloadingItem.smbFile) {
            [downloadingItem.smbFile close];
            downloadingItem.smbFile = nil;
        }
        
        [_downloadingDic removeObjectForKey:key];
        
        return YES;
    }
    return NO;
}

-(void) updateDownloadStatus: (id) result withItem:(DownloadingItem*)downloadingItem
{
    if ([result isKindOfClass:[NSError class]]) {
        
        NSError *error = result;
        NSLog(@"download with error[%@]", error.localizedDescription);
        [self stopDownloadWithKey:downloadingItem.key];
        
    } else if ([result isKindOfClass:[NSData class]]) {
        
        NSData *data = result;
        
        if (data.length == 0) {
            NSLog(@"download with unknow error");
            [self stopDownloadWithKey:downloadingItem.key];
            
        } else {
            downloadingItem.currentSize += data.length;

            // 更新数组和cell
            [self updateRowCurrentSizeWithKey:downloadingItem.key withCurrentSize:downloadingItem.currentSize];
            
            if (downloadingItem.fileHandle) { // 代表正在下载
                
                [downloadingItem.fileHandle writeData:data];
                
                if(downloadingItem.currentSize == downloadingItem.totalSize) {
                    
                    [self stopDownloadWithKey:downloadingItem.key];
                
                    // save md5 key
                    DownloadFileItem *item = [[DownloadFileItem alloc] init];
                    item.key = downloadingItem.key;
                    // 拼上相对本地路径
                    item.localPath = [NSString stringWithFormat:@"%@/%@", item.key, downloadingItem.localPath.lastPathComponent];
                    item.remotePath = downloadingItem.remotePath;
                    item.currentSize = downloadingItem.currentSize;
                    item.totalSize = downloadingItem.totalSize;
                    item.readMark = YES;
                    
                    [[Database sharedDatabase] updateDownloadFileWithKey:item.key withItem:item];
                    
                } else {
                    [self downloadWithItem:downloadingItem];
                }
            } else {
                NSLog(@"从指针为空判断出, 下载已经停止");
            }
            
        }
    } else {
        
        NSAssert(false, @"bugcheck");
    }
}

- (void)openFileHandleWithItem:(DownloadingItem*)downloading
{
    // Documents
    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                     NSUserDomainMask,
                                                                     YES) lastObject];
    
    // _smbFile.path.lastPathComponent
    NSString *folder = [NSString stringWithFormat:@"%@/%@", documentsFolder, downloading.key];
    
    NSError *error = nil;
    
    if(![[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:nil])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
    downloading.localPath = [NSString stringWithFormat:@"%@/%@", folder, downloading.remotePath.lastPathComponent];;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloading.localPath])
        [[NSFileManager defaultManager] removeItemAtPath:downloading.localPath error:nil];
    [[NSFileManager defaultManager]  createFileAtPath:downloading.localPath contents:nil attributes:nil];
    
    
    downloading.fileHandle = [NSFileHandle fileHandleForWritingToURL:[NSURL fileURLWithPath:downloading.localPath]
                                                        error:&error];
    
    
    // 更新本地相对路径
    NSString *relativeLocalPath = [NSString stringWithFormat:@"%@/%@", downloading.key, downloading.localPath.lastPathComponent];
    [self updateRowLocalPathWithKey:downloading.key withLocalPath:relativeLocalPath];
}


-(void)downloadWithItem:(DownloadingItem*)item {
    __weak __typeof(self) weakSelf = self;
    [item.smbFile readDataOfLength:1024*1024
                                        block:^(id result)
     {
         if (weakSelf) {
             [weakSelf updateDownloadStatus:result withItem:item];
         }
     }];
}

-(BOOL)isDownloadWithKey:(NSString*)key {
    DownloadingItem *downloadingItem = [_downloadingDic objectForKey:key];
    if (downloadingItem) {
        return YES;
    }
    return NO;
}

-(BOOL)startDownloadwithKey:(NSString*)key
                       withPath:(NSString*)path
                    withUser:(NSString*)user
               withPassword:(NSString*)password
              withTotalSize:(int64_t)totalSize {
    
    DownloadingItem *downloadingItem = [_downloadingDic objectForKey:key];
    if (nil == downloadingItem) {
        downloadingItem = [[DownloadingItem alloc] init];
        downloadingItem.key = key;
        downloadingItem.remotePath = path;
        downloadingItem.user = user;
        downloadingItem.password = password;
        downloadingItem.totalSize = totalSize;
        [_downloadingDic setObject:downloadingItem forKey:downloadingItem.key];
    } else {
        NSLog(@"path[%@] is downloading!", path);
        return NO;
    }
 
    KxSMBAuth *auth = [KxSMBAuth smbAuthWorkgroup:@""
                                         username:user
                                         password:password];
    
    [_provider fetchAtPath:path
                      auth:auth
                     block:^(id result)
     {
         if ([result isKindOfClass:[NSError class]]) {
             NSLog(@"fail:%@", ((NSError *)result).localizedDescription);
         } else {
             if ([result isKindOfClass:[KxSMBItemFile class]]) {
                 
                 
                 downloadingItem.smbFile = (KxSMBItemFile*)result;
                 // open file handle
                 [self openFileHandleWithItem:downloadingItem];
                 // downlaod
                 [self downloadWithItem:downloadingItem];
             }
         }
     }];
    return YES;
}


-(void)viewWillAppear:(BOOL)animated {
    
    _items = [[Database sharedDatabase] getAllDownloadFile];
    
//    for (DownloadFileItem *item in _items) {
//        if (item.currentSize < item.totalSize) {
//            [self startDownloadwithKey:item.key
//                              withPath:item.remotePath
//                               withUser:item.user
//                          withPassword:item.password
//                         withTotalSize:item.totalSize];
//        }
//    }
//    
    [_tableView reloadData];
    
}

#pragma mark - delegate UITableViewDataSource section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark - delegate UITableViewDataSource 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

#pragma mark - delegate UITableViewDataSource 可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
#pragma mark - delegate UITableViewDataSource  可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - delegate UITableViewDataSource 当移动了某一行时候会调用
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"move index from:%@ to:%@", @(sourceIndexPath.row), @(destinationIndexPath.row));
    
}
#pragma mark - delegate UITableViewDataSource 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLEVIEW_CELL_HEIGHT;
}

#pragma mark - delegate UITableViewDataSource cell创建
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DownloadTableViewCell";
    DownloadTableViewCell *cell = nil;
    // 显示cell的内容
    if([_items count] > 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[DownloadTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier height:TABLEVIEW_CELL_HEIGHT];
        }
        
        DownloadFileItem *item = _items[indexPath.row];
        
        // 名称
        cell.mainTextLabel.text = item.remotePath.lastPathComponent;
        [cell setSecondLabelWithText:item.remotePath];
        
        // 描述: 字节数        
        [cell setSizeWithCurrentSize:item.currentSize withTotalSize:item.totalSize];
        // 状态
        if (item.currentSize == item.totalSize) {
            // 显示已下载
            [cell setDownloadState:STATE_DOWNLOADED];
        } else {
            if([self isDownloadWithKey:item.key]) {
                // 显示开始下载
                [cell setDownloadState:STATE_DOWNLOADING];
            } else {
                // 显示停止下载
                [cell setDownloadState:STATE_STOPED];
            }
        }
        
        // 文件/目录
        [cell setIsFile:YES withDesc:@"文件"];
        // 图片
        UIImage *image = [UIImage imageNamed:@"file_item"];
        [cell setPhotoWithImage:image];
        
    }
    
    return cell;
}


#pragma mark - delegate UITableViewDataSource 删除操作的返回字符
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark - delegate UITableViewDelegate 点击accessory
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"accessory!");
}

#pragma mark - delegate UITableViewDataSource 点击cell跳转/选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DownloadTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    DownloadFileItem *item = _items[indexPath.row];
    
    if (item.currentSize == item.totalSize) {
        NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                         NSUserDomainMask,
                                                                         YES) lastObject];
        
        NSString *previewfileLocalPath = [NSString stringWithFormat:@"%@/%@", documentsFolder, item.localPath];
        if ([QLPreviewController canPreviewItem:[NSURL fileURLWithPath:previewfileLocalPath]]) {
            QLPreviewController *vc = [QLPreviewController new];
            vc.currentPreviewItemIndex = indexPath.row;
            vc.delegate = self;
            vc.dataSource = self;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    } else {
        if([self isDownloadWithKey:item.key]) {
            // 停止下载
            [self stopDownloadWithKey:item.key];
            // 显示停止下载
            [cell setDownloadState:STATE_STOPED];
        } else {
            // 开始下载
            [self startDownloadwithKey:item.key
                              withPath:item.remotePath
                              withUser:item.user
                          withPassword:item.password
                         withTotalSize:item.totalSize];
            // 显示开始下载
            [cell setDownloadState:STATE_DOWNLOADING];
        }
    }
}

#pragma mark - delegate UITableViewDataSource 取消选中
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - delegate UITableViewDataSource 删除cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"删除index[%@]", @(indexPath.row));
        // 先删除DB
        DownloadFileItem *item = _items[indexPath.row];
        [[Database sharedDatabase] delDownloadFileWithKey:item.key];
        
        // 再删文件
        NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                         NSUserDomainMask,
                                                                         YES) lastObject];
        
        NSString *localPath = [NSString stringWithFormat:@"%@/%@", documentsFolder, item.localPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:localPath])
            [[NSFileManager defaultManager] removeItemAtPath:localPath error:nil];
        
        // 再删除数据源
        [_items removeObjectAtIndex:indexPath.row];
        
        // 再删除tableview
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the dataArrayay, and add a new row to the table view
    }
}


#pragma mark - delegate UITableViewDelegate 编辑类型
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}


#pragma mark - QLPreviewController

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return _items.count;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSLog(@"get index[%@]", @(index));
    
    DownloadFileItem *item = _items[index];
    
    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                     NSUserDomainMask,
                                                                     YES) lastObject];
    
    NSString *previewfileLocalPath = [NSString stringWithFormat:@"%@/%@", documentsFolder, item.localPath];
    
    return [NSURL fileURLWithPath:previewfileLocalPath];
}



#pragma mark - delegate for KxSMBProviderDelegate
- (KxSMBAuth *) smbRequestAuthServer:(NSString *)server
                               share:(NSString *)share
                           workgroup:(NSString *)workgroup
                            username:(NSString *)username
{
    if ([share isEqualToString:@"IPC$"] ||
        [share hasSuffix:@"$"])
    {
        //         return nil;
    }
    
    NSLog(@"ask auth for %@/%@ (%@)", server, share, workgroup);
    
    return nil;
}


@end
