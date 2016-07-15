//
//  FileViewController.m
//  kxsmb project
//  https://github.com/kolyvan/kxsmb/
//
//  Created by Kolyvan on 29.03.13.
//

/*
 Copyright (c) 2013 Konstantin Bukreev All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 - Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


#import "FileViewController.h"
#import "KxSMBProvider.h"
#import <QuickLook/QuickLook.h>
#import "Database.h"
#import "CachedFileItem.h"

@interface FileViewController () <QLPreviewControllerDelegate, QLPreviewControllerDataSource>
@end

@implementation FileViewController {
    
    UIView          *_container;
    UILabel         *_nameLabel;
    UILabel         *_sizeLabel;
    UILabel         *_modifiedLabel;
    UILabel         *_createdLabel;
    UIButton        *_downloadButton;   // 下载按钮
    UIProgressView  *_downloadProgress; // 下载进度
    UILabel         *_downloadLabel;
    
    NSString        *_fileLocalPath;            // 本地文件路径
    NSString        *_fileRelativeLocalPath;    // 本地相对路径
    
    NSFileHandle    *_fileHandle;       // 本地文件描述符
    long            _downloadedBytes;   // 已下载字节数
    NSDate          *_timestamp;
    
    NSInteger       _row;
}

-(id)initWithRow:(NSInteger)row {
    self = [super init];
    
    if (self) {
        
        _row = row;
    }
    return self;
}


- (void) dealloc
{
    [self closeFiles];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    const CGSize size = self.view.bounds.size;
    const CGFloat W = size.width;
    
    _container = [[UIView alloc] initWithFrame:(CGRect){0,0,size}];
    _container.autoresizingMask = UIViewAutoresizingNone;
    _container.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_container];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, W - 20, 25)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    _nameLabel.textColor = [UIColor darkTextColor];
    _nameLabel.opaque = NO;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, W - 20, 25)];
    _sizeLabel.font = [UIFont systemFontOfSize:14];
    _sizeLabel.textColor = [UIColor darkTextColor];
    _sizeLabel.opaque = NO;
    _sizeLabel.backgroundColor = [UIColor clearColor];
    _sizeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _modifiedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, W - 20, 25)];
    _modifiedLabel.font = [UIFont systemFontOfSize:14];;
    _modifiedLabel.textColor = [UIColor darkTextColor];
    _modifiedLabel.opaque = NO;
    _modifiedLabel.backgroundColor = [UIColor clearColor];
    _modifiedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _createdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, W - 20, 25)];
    _createdLabel.font = [UIFont systemFontOfSize:14];;
    _createdLabel.textColor = [UIColor darkTextColor];
    _createdLabel.opaque = NO;
    _createdLabel.backgroundColor = [UIColor clearColor];
    _createdLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _downloadButton.frame = CGRectMake(10, 120, 200, 30);
    _downloadButton.backgroundColor = [UIColor blueColor];
    _downloadButton.layer.cornerRadius = 5;
    _downloadButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_downloadButton setTitle:@"Download" forState:UIControlStateNormal];
    [_downloadButton addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    
    _downloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, W - 20, 40)];
    _downloadLabel.font = [UIFont systemFontOfSize:14];;
    _downloadLabel.textColor = [UIColor darkTextColor];
    _downloadLabel.opaque = NO;
    _downloadLabel.backgroundColor = [UIColor clearColor];
    _downloadLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _downloadLabel.numberOfLines = 2;
    
    _downloadProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _downloadProgress.frame = CGRectMake(10, 190, W - 20, 30);
    _downloadProgress.hidden = YES;
    
    [_container addSubview:_nameLabel];
    [_container addSubview:_sizeLabel];
    [_container addSubview:_modifiedLabel];
    [_container addSubview:_createdLabel];
    [_container addSubview:_downloadButton];
    [_container addSubview:_downloadLabel];
    [_container addSubview:_downloadProgress];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    const CGSize size = self.view.bounds.size;
    const CGFloat top = [self.topLayoutGuide length];
    _container.frame = (CGRect){0, top, size.width, size.height - top};
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _nameLabel.text = _smbFile.path;
    _sizeLabel.text = [NSString stringWithFormat:@"size: %lld", _smbFile.stat.size];
    _modifiedLabel.text = [NSString stringWithFormat:@"modified: %@", _smbFile.stat.lastModified];
    _createdLabel.text = [NSString stringWithFormat:@"created: %@", _smbFile.stat.creationTime];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];    
    //[self closeFiles];
}

- (void) closeFiles
{
    if (_fileHandle) {
        
        [_fileHandle closeFile];
        _fileHandle = nil;
    }

    
    [_smbFile close];

    
}

- (void) downloadAction
{
    if (!_fileHandle) { // 代表没开始下载
        
        // Documents
        NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                NSUserDomainMask,
                                                                YES) lastObject];

        // _smbFile.path.lastPathComponent
        NSString *hashKey = [NSString stringWithFormat:@"%@", @([_smbFile.path hash])];
        NSString *folder = [NSString stringWithFormat:@"%@/%@", documentsFolder, hashKey];
        
        NSError *error = nil;
        
        if(![[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:nil])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:folder
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
        }
        _fileLocalPath = [NSString stringWithFormat:@"%@/%@", folder, _smbFile.path.lastPathComponent];;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:_fileLocalPath])
            [[NSFileManager defaultManager] removeItemAtPath:_fileLocalPath error:nil];
        [[NSFileManager defaultManager]  createFileAtPath:_fileLocalPath contents:nil attributes:nil];
        
        
        _fileHandle = [NSFileHandle fileHandleForWritingToURL:[NSURL fileURLWithPath:_fileLocalPath]
                                                        error:&error];
 
        if (_fileHandle) {
        
            [_downloadButton setTitle:@"Cancel" forState:UIControlStateNormal];
            _downloadLabel.text = @"starting ..";
            
            _downloadedBytes = 0;
            _downloadProgress.progress = 0;
            _downloadProgress.hidden = NO;
            _timestamp = [NSDate date];
            
            [self download];
            
        } else {
            
            _downloadLabel.text = [NSString stringWithFormat:@"failed: %@", error.localizedDescription];
        }
        
    } else { // 代表已经开始下载
        
        [_downloadButton setTitle:@"Download" forState:UIControlStateNormal];
        _downloadLabel.text = @"cancelled";
        [self closeFiles];
        
        // 删除残留
        if ([[NSFileManager defaultManager] fileExistsAtPath:_fileLocalPath])
            [[NSFileManager defaultManager] removeItemAtPath:_fileLocalPath error:nil];
    }
}

-(void) updateDownloadStatus: (id) result
{
    if ([result isKindOfClass:[NSError class]]) {
         
        NSError *error = result;
        
        [_downloadButton setTitle:@"Download" forState:UIControlStateNormal];
        _downloadLabel.text = [NSString stringWithFormat:@"failed: %@", error.localizedDescription];
        _downloadProgress.hidden = YES;        
       [self closeFiles];
        
    } else if ([result isKindOfClass:[NSData class]]) {
        
        NSData *data = result;
                
        if (data.length == 0) {
        
            [_downloadButton setTitle:@"Download" forState:UIControlStateNormal];          
            [self closeFiles];
            
        } else {
            
            NSTimeInterval time = -[_timestamp timeIntervalSinceNow];
            
            _downloadedBytes += data.length;
            _downloadProgress.progress = (float)_downloadedBytes / (float)_smbFile.stat.size;
            
            CGFloat value;
            NSString *unit;
            
            if (_downloadedBytes < 1024) {
                
                value = _downloadedBytes;
                unit = @"B";
                
            } else if (_downloadedBytes < 1048576) {
                
                value = _downloadedBytes / 1024.f;
                unit = @"KB";
                
            } else {
                
                value = _downloadedBytes / 1048576.f;
                unit = @"MB";
            }
            
            _downloadLabel.text = [NSString stringWithFormat:@"downloaded %.1f%@ (%.1f%%) %.2f%@s",
                                   value, unit,
                                   _downloadProgress.progress * 100.f,
                                   value / time, unit];
            
            if (_fileHandle) {
                
                [_fileHandle writeData:data];
                
                if(_downloadedBytes == _smbFile.stat.size) {
                    
                    [self closeFiles];
                    
                    [_downloadButton setTitle:@"Done" forState:UIControlStateNormal];
                    _downloadButton.enabled = NO;
                    
                    // save hash key
                    CachedFileItem *item = [[CachedFileItem alloc] init];
                    item.hashKey = [NSString stringWithFormat:@"%@", @([_smbFile.path hash])];
                    // 拼上相对本地路径
                    item.localPath = [NSString stringWithFormat:@"%@/%@", [NSString stringWithFormat:@"%@", @([_smbFile.path hash])], _smbFile.path.lastPathComponent];
                    item.remotePath = _smbFile.path;
                    item.size = _downloadedBytes;
                    item.readMark = YES;
                    
                    [[Database sharedDatabase] addCachedFileWithItem:item];
                    
                    // 更新这一行
                    [self.delegate updateWithRow:_row];
                    
                    if ([QLPreviewController canPreviewItem:[NSURL fileURLWithPath:_fileLocalPath]]) {
                        
                        QLPreviewController *vc = [QLPreviewController new];
                        vc.delegate = self;
                        vc.dataSource = self;
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        self.hidesBottomBarWhenPushed = YES;
                    }
                    
                } else {
                    
                    [self download];
                }
            }
        }
    } else {
        
        NSAssert(false, @"bugcheck");        
    }
}

- (void) download
{    
    __weak __typeof(self) weakSelf = self;
    [_smbFile readDataOfLength:1024*1024
                         block:^(id result)
    {
        FileViewController *p = weakSelf;
        //if (p && p.isViewLoaded && p.view.window) {
        if (p) {
            [p updateDownloadStatus:result];
        }
    }];
}

#pragma mark - QLPreviewController

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:_fileLocalPath];
}

@end
