//
//  MeFavoriteVC.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/16.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "MeFavoriteVC.h"
#import "FileTableViewCell.h"
#import "Common.h"
#import "CommonTool.h"
#import "Database.h"
#import "FavoriteItem.h"
#import "MeTreeVC.h"
#import "KxSMBProvider.h"
@interface MeFavoriteVC() <UITableViewDelegate,UITableViewDataSource>

@end


@implementation MeFavoriteVC {
    
    NSMutableArray              *_items;
    UITableView                 *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
}

-(void)viewWillAppear:(BOOL)animated {
    _items = [[Database sharedDatabase] getAllFavorite];
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
    return NO;
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
        FavoriteItem *item = _items[indexPath.row];
        // 名称
        cell.mainTextLabel.text = item.remotePath.lastPathComponent;
        [cell setSecondLabelWithText:item.remotePath];
        
        // 描述: 字节数
        NSString *desc = nil;
        if (item.size > 0)
        {
            desc = [NSString stringWithFormat:@"%@", @(item.size)];
        } else {
            desc = @"N/A";
        }
        [cell setDescLabelWithText:desc
               withBackGroubdColor:[CommonTool skyBlueColor]];
        
        if (item.isFile) {
            // 文件/目录
            [cell setIsFile:YES withDesc:@"文件"];
            // 图片
            UIImage *image = [UIImage imageNamed:@"file_item"];
            [cell setPhotoWithImage:image];
        } else {
            // 文件/目录
            [cell setIsFile:NO withDesc:@"目录"];
            // 图片
            UIImage *image = [UIImage imageNamed:@"folder_item"];
            [cell setPhotoWithImage:image];
        }
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
    
}
#pragma mark - delegate UITableViewDataSource 点击cell跳转/选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FavoriteItem *item = _items[indexPath.row];
    
    
    
    KxSMBAuth *auth = [KxSMBAuth smbAuthWorkgroup:@""
                                         username:item.user
                                         password:item.password];;
    
    MeTreeVC *vc = [[MeTreeVC alloc] init];
    [vc accessWithPath:item.remotePath withAuth:auth];
    [self.navigationController pushViewController:vc animated:YES];
    
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
        FavoriteItem *item = _items[indexPath.row];
        [[Database sharedDatabase] delFavoriteWithKey:item.sequence];
        
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



@end