/*****************************************************************************
 * VLCNetworkServerBrowserViewController.m
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2013-2015 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Felix Paul Kühne <fkuehne # videolan.org>
 *          Pierre SAGASPE <pierre.sagaspe # me.com>
 *          Tobias Conradi <videolan # tobias-conradi.de>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#import "VLCNetworkServerBrowserViewController.h"

#import "VLCNetworkServerBrowser-Protocol.h"

#import "VLCConstants.h"

@interface VLCNetworkServerBrowserViewController () <VLCNetworkServerBrowserDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
//    UIRefreshControl *_refreshControl;
}
@property (nonatomic) id<VLCNetworkServerBrowser> serverBrowser;
@property (nonatomic) NSArray<id<VLCNetworkServerBrowserItem>> *searchArray;
@end

@implementation VLCNetworkServerBrowserViewController

- (instancetype)initWithServerBrowser:(id<VLCNetworkServerBrowser>)browser
{
    self = [super init];
    if (self) {
        _serverBrowser = browser;
        browser.delegate = self;
        
        NSArray<id<VLCNetworkServerBrowserItem>> *items = _serverBrowser.items;
        NSLog(@"count:%@, %@", @(items.count), items[0].name);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;


    self.title = self.serverBrowser.title;
    [self update];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}


- (void)networkServerBrowser:(id<VLCNetworkServerBrowser>)networkBrowser requestDidFailWithError:(NSError *)error {
//    [self vlc_showAlertWithTitle:NSLocalizedString(@"LOCAL_SERVER_CONNECTION_FAILED_TITLE", nil)
//                         message:NSLocalizedString(@"LOCAL_SERVER_CONNECTION_FAILED_MESSAGE", nil)
//                     buttonTitle:NSLocalizedString(@"BUTTON_CANCEL", nil)];
}

- (void)updateUI
{
    [self.tableView reloadData];
    self.title = self.serverBrowser.title;
}

- (void)update
{
    [self.serverBrowser update];
}


#pragma mark - server browser item specifics

- (void)didSelectItem:(id<VLCNetworkServerBrowserItem>)item index:(NSUInteger)index singlePlayback:(BOOL)singlePlayback
{
    if (item.isContainer) {
        VLCNetworkServerBrowserViewController *targetViewController = [[VLCNetworkServerBrowserViewController alloc] initWithServerBrowser:item.containerBrowser];
        [self.navigationController pushViewController:targetViewController animated:YES];
    } else {
        if (singlePlayback) {
        } else {
            VLCMediaList *mediaList = self.serverBrowser.mediaList;
        }
    }
}

- (void)playAllAction:(id)sender
{
    NSArray *items = self.serverBrowser.items;
    NSInteger count = items.count;
    NSMutableArray *fileList = [[NSMutableArray alloc] init];
    for (NSInteger x = count - 1; x > -1; x--) {
        id<VLCNetworkServerBrowserItem> iter = items[x];
        if (![iter isContainer]) {
            VLCMedia *iterMedia = [iter media];
            if (iterMedia != nil) {
                [fileList addObject:iterMedia];
            }
        }
    }

    if (fileList.count > 0) {
        VLCMediaList *fileMediaList = [[VLCMediaList alloc] initWithArray:fileList];
    }
}

#pragma mark - table view data source, for more see super

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return _searchArray.count;

    return self.serverBrowser.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }

    cell.textLabel.text = self.serverBrowser.items[indexPath.row].name;



    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<VLCNetworkServerBrowserItem> item;
    NSInteger row = indexPath.row;
    BOOL singlePlayback = ![[NSUserDefaults standardUserDefaults] boolForKey:kVLCAutomaticallyPlayNextItem];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        item = _searchArray[row];
        singlePlayback = YES;
    } else {
        item = self.serverBrowser.items[row];
    }

    [self didSelectItem:item index:row singlePlayback:singlePlayback];

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - search

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@",searchString];
    self.searchArray = [self.serverBrowser.items filteredArrayUsingPredicate:predicate];
    return YES;
}

@end
