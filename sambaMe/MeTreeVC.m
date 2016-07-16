//
//  MeTreeVC
//  sambaMe
//
//  Created by Shao.Admin on 16/7/12.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "MeTreeVC.h"
#import "Database.h"
#import "HostItem.h"
#import "CommonTool.h"
#import "FileTableViewCell.h"
#import "Common.h"
#import "FileViewController.h"
#import <QuickLook/QuickLook.h>
#import "CachedFileItem.h"
#import "KxSMBProvider.h"
#import "CellMenuItem.h"
#import "NSString+Hashing.h"
#import "FavoriteItem.h"

@interface MeTreeVC () <UIActionSheetDelegate,FileViewControllerDelegate,KxSMBProviderDelegate,UITableViewDelegate,UITableViewDataSource,QLPreviewControllerDelegate, QLPreviewControllerDataSource> {
}

@end

@implementation MeTreeVC {
    
    
    UITableView     *_tableView;
    KxSMBProvider   *_provider;
    NSString        *_previewfileLocalPath;
    NSMutableArray  *_items;
    
}

-(id) init {
    self = [super init];
    if (self) {
        _provider = [KxSMBProvider sharedSmbProvider];
        _provider.delegate = self;
    }
    return self;
}

- (KxSMBAuth *) smbRequestAuthServer:(NSString *)server
                               share:(NSString *)share
                           workgroup:(NSString *)workgroup
                            username:(NSString *)username
{
    if ([share isEqualToString:@"IPC$"] ||
        [share hasSuffix:@"$"])
    {
        // return nil;
    }
    
    NSLog(@"ask auth for %@/%@ (%@)", server, share, workgroup);
    
    return nil;
}

-(void)accessWithPath:(NSString*)path
             withAuth:(KxSMBAuth*)auth
{
    
    self.auth = auth;
    self.path = path;
    
    [_provider fetchAtPath:self.path
                      auth:self.auth
                     block:^(id result)
     {
         if ([result isKindOfClass:[NSError class]]) {
             NSLog(@"fail:%@", ((NSError *)result).localizedDescription);
         } else {
             if ([result isKindOfClass:[NSArray class]]) {
                 _items = [result copy];
             } else if ([result isKindOfClass:[KxSMBItem class]]) {
                 [_items addObject:result];
             }
             NSLog(@"OK");
             [_tableView reloadData];
         }
     }];
}

-(void)loginWithPath:(NSString*)path
            withAuth:(KxSMBAuth*)auth
{
    self.auth = auth;
    self.path = path;
    
    [_provider fetchAtPath:self.path
                      auth:self.auth
                     block:^(id result)
     {
         if ([result isKindOfClass:[NSError class]]) {
             NSLog(@"fail:%@", ((NSError *)result).localizedDescription);
             [self.navigationController popViewControllerAnimated:YES];
         } else {
             
             HostItem *item = [[HostItem alloc] init];
             item.host = self.path;
             item.user = self.auth.username;
             item.password = self.auth.password;
             item.state = YES;
             item.desc = @"正常";
             
             NSDate *nowDate  = [NSDate date];
             NSDateFormatter *dateFormat = [NSDateFormatter new];
             [dateFormat setDateFormat:@"yyyy年MM月dd日-HH:mm"];
             item.time = [dateFormat stringFromDate:nowDate];
             [[Database sharedDatabase] addHost:item];
             
             
             if ([result isKindOfClass:[NSArray class]]) {
                 _items = [result copy];
             } else if ([result isKindOfClass:[KxSMBItem class]]) {
                 [_items addObject:result];
             }
             NSLog(@"OK");
             [_tableView reloadData];
         }
     }];
}


-(void)loginWithPath:(NSString*)path
            withAuth:(KxSMBAuth*)auth
    withLoadSequence:(NSInteger)sequence
{
    self.auth = auth;
    self.path = path;
    
    [_provider fetchAtPath:self.path
                      auth:self.auth
                     block:^(id result)
     {
         if ([result isKindOfClass:[NSError class]]) {
             NSString *desc = ((NSError *)result).localizedDescription;
             NSLog(@"fail:%@", ((NSError *)result).localizedDescription);
             // 更新状态
             [[Database sharedDatabase] updateHostStateWithSequence:sequence withState:NO withDesc:desc];
             [self.navigationController popViewControllerAnimated:YES];
             
         } else {
             if ([result isKindOfClass:[NSArray class]]) {
                 _items = [result copy];
             } else if ([result isKindOfClass:[KxSMBItem class]]) {
                 [_items addObject:result];
             }
             NSLog(@"OK");
             [_tableView reloadData];
             // 更新访问时间和描述(状态修改为OK)
             NSDate *nowDate  = [NSDate date];
             NSDateFormatter *dateFormat = [NSDateFormatter new];
             [dateFormat setDateFormat:@"yyyy年MM月dd日-HH:mm"];
             NSString *time = [dateFormat stringFromDate:nowDate];
             [[Database sharedDatabase] updateAccessTimeWithSequence:sequence withTime:time withDesc:@"正常"];
             
         }
     }];
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
    
    if(_path.length > 0)
    {
        NSArray *segments = [self.path componentsSeparatedByString:@"/"];
        if(0 == [segments count])
        {
            self.title = self.path;
        }
        else
        {
            self.title = [segments lastObject];
        }
    }
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
    return NO;
}
#pragma mark - delegate UITableViewDataSource  可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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
    static NSString *cellIdentifier = @"FileTableViewCell";
    FileTableViewCell *cell = nil;
    // 显示cell的内容
    if([_items count] > 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[FileTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier height:TABLEVIEW_CELL_HEIGHT];
        }
        
        KxSMBItem *item = _items[indexPath.row]; // KxSMBItemFile/ KxSMBItemTree
        
        if ([item isKindOfClass:[KxSMBItemFile class]]) {
            
            KxSMBItemFile* file = (KxSMBItemFile*)item;
            // 名称
            cell.mainTextLabel.text = file.path.lastPathComponent; // [[file path] stringByReplacingOccurrencesOfString:_path withString:@""];
            
            // 描述: 字节数
            NSString *desc = nil;
            if (file.stat.size > 0)
            {
                desc = [NSString stringWithFormat:@"%@", @(file.stat.size)];
            } else {
                desc = @"N/A";
            }
            [cell setDescLabelWithText:desc
                   withBackGroubdColor:[CommonTool skyBlueColor]];
            
            
            NSString *key = [file.path MD5Hash];
            CachedFileItem *casedFileItem = [[Database sharedDatabase] getCachedFileWithKey:key];
            
            if(nil != casedFileItem)
            {
                NSString *second = [NSString stringWithFormat:@"已下载:%@/%@", @(casedFileItem.size), @(file.stat.size)];
                [cell setSecondLabelWithText:second];
                
                if(casedFileItem.size == file.stat.size)
                {
                    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                                     NSUserDomainMask,
                                                                                     YES) lastObject];
                    
                    cell.localPath = [NSString stringWithFormat:@"%@/%@", documentsFolder, casedFileItem.localPath];
                    
                    [cell setBlueMark];
                }
            } else {
                // 必须清除以下信息, 因为从缓存中获取的cell可能已经含有
                [cell setSecondLabelWithText:nil];
                cell.localPath = nil;
                [cell clearMark];
            }
            
            // 文件/目录
            [cell setIsFile:YES withDesc:@"文件"];
            // 图片
            UIImage *image = [UIImage imageNamed:@"file_item"];
            [cell setPhotoWithImage:image];
            
        } else if ( [item isKindOfClass:[KxSMBItemTree class]] ) {
            KxSMBItemTree* folder = (KxSMBItemTree*)item;
            
            // 名称
            cell.mainTextLabel.text = folder.path.lastPathComponent; // [[folder path] stringByReplacingOccurrencesOfString:_path withString:@""];
            
            // 描述: 字节数
            NSString *desc = nil;
            if(folder.stat.size > 0)
            {
                desc = [NSString stringWithFormat:@"%@", @(folder.stat.size)];
            } else {
                desc = @"N/A";
            }
            [cell setDescLabelWithText: [NSString stringWithFormat:@"%@", desc]
                   withBackGroubdColor:[CommonTool skyBlueColor]];
            
            // 目录没有以下信息
            [cell setSecondLabelWithText:nil];
            cell.localPath = nil;
            [cell clearMark];
            
            // 文件/目录
            [cell setIsFile:NO withDesc:@"目录"];
            // 图片
            UIImage *image = [UIImage imageNamed:@"folder_item"];
            [cell setPhotoWithImage:image];
        }
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPressGR.minimumPressDuration = 0.2;
        [cell addGestureRecognizer:longPressGR];
    }
    
    return cell;
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"handleLongPress:%@", @(gestureRecognizer.state));
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint location = [gestureRecognizer locationInView:_tableView];
        NSIndexPath * indexPath = [_tableView indexPathForRowAtPoint:location];
        
        FileTableViewCell *cell = (FileTableViewCell *)gestureRecognizer.view;
        [cell becomeFirstResponder];
        
        CellMenuItem *itCopyPath = [[CellMenuItem alloc] initWithTitle:@"复制路径" action:@selector(handleCopyPath:)];
        itCopyPath.indexPath = indexPath;
        
        CellMenuItem *itFavorite = [[CellMenuItem alloc] initWithTitle:@"查看" action:@selector(handleDetails:)];
        itFavorite.indexPath = indexPath;
        
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:itCopyPath, itFavorite, nil]];
        [menu setTargetRect:cell.frame inView:_tableView];
        [menu setMenuVisible:YES animated:YES];        
    }
}


- (void)handleCopyPath:(id)sender {
    UIMenuController *targetSender = (UIMenuController *)sender ;
    CellMenuItem *menuItem = (CellMenuItem *)targetSender.menuItems[0];
    
    KxSMBItem *item = _items[menuItem.indexPath.row];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = item.path;
    
    NSLog(@"handle copy path: %@:%@", @(menuItem.indexPath.row), item.path);
}

- (void)handleDetails:(id)sender {
    NSLog(@"handle detail ");
    UIMenuController *targetSender = (UIMenuController *)sender ;
    CellMenuItem *menuItem = (CellMenuItem *)targetSender.menuItems[0];
    KxSMBItem *item = _items[menuItem.indexPath.row];
    NSLog(@"see detail path: %@:%@", @(menuItem.indexPath.row), item.path);
}

#pragma mark - delegate UITableViewDataSource 删除操作的返回字符
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - delegate UITableViewDelegate 点击accessory
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KxSMBItem *item = _items[indexPath.row];
    
    // 底部的action sheet
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"操作"
                                                                             message:@"请选择"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 1. 取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"选择取消");
    }];
    
    [alertController addAction:cancelAction];
    
    // 2. 下载, 只有文件可以下载
    if ([item isKindOfClass:[KxSMBItemFile class]])
    {
        UIAlertAction *downloadAction = [UIAlertAction actionWithTitle:@"下载"
                                                                 style:UIAlertActionStyleDestructive
                                                               handler:^(UIAlertAction *action) {
                                                                   NSLog(@"选择了下载:%@", item.path);
                                                               }];
        [alertController addAction:downloadAction];

    }

    // 3. 修改名称
    UIAlertAction *renameAction = [UIAlertAction actionWithTitle:@"修改名称"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
        NSLog(@"选择了修改名称:%@", item.path);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入信息" message:@"请输入新文件名" preferredStyle:UIAlertControllerStyleAlert];
        
        // action
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *newPath = alertController.textFields[0].text;
            NSLog(@"rename [%@] to [%@]", item.path, newPath);
            
            [_provider renameAtPath:item.path
                            newPath:newPath
                               auth:self.auth
                              block:^(id  _Nullable result) {
                                  if ([result isKindOfClass:[NSError class]]) {
                                      NSLog(@"fail:%@", ((NSError *)result).localizedDescription);
                                  } else {
                                      NSLog(@"rename ok");
                                      [self accessWithPath:self.path withAuth:self.auth];
                                  }
                              }];
        }];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = @"新文件名";
            textField.text = item.path;
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    [alertController addAction:renameAction];
    
    // 4. 收藏
    UIAlertAction *favoriteAction = [UIAlertAction actionWithTitle:@"收藏"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               
                                                               NSLog(@"选择了收藏:%@", item.path);
                                                               
                                                               // save favorite
                                                               FavoriteItem *favoriteItem = [[FavoriteItem alloc] init];
                                                               favoriteItem.remotePath = item.path;
                                                               favoriteItem.size = item.stat.size;
                                                               
                                                               if ([item isKindOfClass:[KxSMBItemTree class]]) {
                                                                   favoriteItem.isFile = NO;
                                                               } else if ([item isKindOfClass:[KxSMBItemFile class]]) {
                                                                   favoriteItem.isFile = YES;
                                                               }
                                                               
                                                               favoriteItem.user = self.auth.username;
                                                               favoriteItem.password = self.auth.password;
                                                               [[Database sharedDatabase] addFavoriteWithItem:favoriteItem];
                                                               
                                                               
                                                           }];
    [alertController addAction:favoriteAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - delegate UITableViewDataSource 点击cell跳转/选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KxSMBItem *item = _items[indexPath.row];
    if ([item isKindOfClass:[KxSMBItemTree class]]) {
        
        MeTreeVC *vc = [[MeTreeVC alloc] init];
        [vc accessWithPath:item.path withAuth:self.auth];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    } else if ([item isKindOfClass:[KxSMBItemFile class]]) {
        
        FileTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.localPath.length > 0) { // 如果已经缓存了, 直接预览
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:cell.localPath]) {
                // 文件不存在,则更新一下该行
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                return;
            }
            
            _previewfileLocalPath = cell.localPath;
            if ([QLPreviewController canPreviewItem:[NSURL fileURLWithPath:_previewfileLocalPath]]) {
                QLPreviewController *vc = [QLPreviewController new];
                vc.delegate = self;
                vc.dataSource = self;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
        } else { // 载入,下载页面
            KxSMBItemFile *smbFile = (KxSMBItemFile *)item;
            FileViewController *vc = [[FileViewController alloc] initWithRow:indexPath.row];
            vc.smbFile = smbFile;
            vc.delegate = self;
            
            [self.navigationController pushViewController:vc animated:YES];
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
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:_previewfileLocalPath];
}

#pragma mark - delegate FileViewController

-(void)updateWithRow:(NSInteger)row {
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}



@end
