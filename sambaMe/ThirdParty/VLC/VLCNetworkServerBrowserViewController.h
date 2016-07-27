/*****************************************************************************
 * VLCNetworkServerBrowserViewController.h
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2013-2015 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Felix Paul Kühne <fkuehne # videolan.org>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#import <UIKit/UIKit.h>

#import "VLCNetworkServerBrowser-Protocol.h"

@interface VLCNetworkServerBrowserViewController : UITableViewController    

- (instancetype)initWithServerBrowser:(id<VLCNetworkServerBrowser>)browser;

@end
