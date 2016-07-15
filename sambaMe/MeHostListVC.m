//
//  MeHostListVC.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/14.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "MeHostListVC.h"
#import "HostItem.h"
#import "MeTreeVC.h"
#import "Database.h"
#import "CommonTool.h"
#import "HostTableViewCell.h"
#import "Common.h"
#import "KxSMBProvider.h"

@interface MeHostListVC() <UITableViewDelegate,UITableViewDataSource>

@end


@implementation MeHostListVC {
    
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
    
    
    // 操作按钮
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addClicked)];
    [self.navigationItem setRightBarButtonItem:addBtn animated:YES];

}

-(void)viewWillAppear:(BOOL)animated {
    
    _items = [[Database sharedDatabase] getAllHost];
    [_tableView reloadData];
}

// 监控textfield变化
- (void)alertTextFieldDidChange:(NSNotification *) notification {
    
    UIAlertController *alertController = (UIAlertController *) self.presentedViewController;
    if(alertController) {
        UITextField *field = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = field.text.length > 2;
    }
}

-(void)addClicked {
    NSLog(@"add clicked");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"连接至SMB服务" message:@"请填写连接信息" preferredStyle:UIAlertControllerStyleAlert];
    
    // action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSString *defaultHost = alertController.textFields[0].text;
        NSString *defaultUser = alertController.textFields[1].text;
        NSString *defaultPassword = alertController.textFields[2].text;
        
        [[NSUserDefaults standardUserDefaults] setObject:defaultHost forKey:@"defaultHost"];
        [[NSUserDefaults standardUserDefaults] setObject:defaultUser forKey:@"defaultUser"];
        [[NSUserDefaults standardUserDefaults] setObject:defaultPassword forKey:@"defaultPassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 移除监控
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
        // 连接
        MeTreeVC *vc = [[MeTreeVC alloc] init];
        KxSMBAuth *auth = [KxSMBAuth smbAuthWorkgroup:@""
                                            username:defaultUser
                                            password:defaultPassword];;
        NSString *path = [NSString stringWithFormat:@"smb://%@", defaultHost];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [vc loginWithPath:path withAuth:auth];
        self.hidesBottomBarWhenPushed = NO;
    }];
    
    
    // textfiled
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"服务器";
        textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultHost"];
        okAction.enabled = textField.text.length > 2;
        
        // 监控textfield变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"用户名";
        textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultUser"];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"密码";
        textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultPassword"];
        textField.secureTextEntry = YES;
    }];
  
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
    static NSString *cellIdentifier = @"HostTableViewCell";
    HostTableViewCell *cell = nil;
    // 显示cell的内容
    if([_items count] > 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[HostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier height:TABLEVIEW_CELL_HEIGHT];
        }
        
        HostItem* item = _items[indexPath.row];
        
        
        // host
        cell.mainTextLabel.text = item.host;
        
        // 状态
        [cell setState:item.state withDesc:item.desc];
        // 用户
        [cell setDescLabelWithText:item.user withBackGroubdColor:[CommonTool skyBlueColor]];
        
        NSString *second = [NSString stringWithFormat:@"上次访问:%@", item.time];
        // 时间
        [cell setSecondLabelWithText:second];
        
        // 图片
        UIImage *image = [UIImage imageNamed:@"smb_item"];
        [cell setPhotoWithImage:image];
        
    }
    
    return cell;
}


#pragma mark - delegate UITableViewDataSource 删除操作的返回字符
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - delegate UITableViewDataSource 点击cell跳转/选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HostItem* item = _items[indexPath.row];
   
    MeTreeVC *vc = [[MeTreeVC alloc] init];
    KxSMBAuth *auth = [KxSMBAuth smbAuthWorkgroup:@""
                                        username:item.user
                                        password:item.password];;
    [vc loginWithPath:item.host withAuth:auth withLoadSequence:item.sequence];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    // update access time
    NSDate *nowDate  = [NSDate date];
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"yyyy年MM月dd日-HH:mm"];
    item.time = [dateFormat stringFromDate:nowDate];
    [[Database sharedDatabase] updateAccessTimeWithSequence:item.sequence withTime:item.time];
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
        HostItem* item = _items[indexPath.row];
        [[Database sharedDatabase] delHostWithSequence:item.sequence];
        
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
