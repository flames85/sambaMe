//
//  MeTreeVC
//  sambaMe
//
//  Created by Shao.Admin on 16/7/12.
//  Copyright © 2016年 sq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KxSMBAuth;

@interface MeTreeVC : UIViewController

-(id) init;


-(void)loginWithPath:(NSString*)path
            withAuth:(KxSMBAuth*)auth
    withLoadSequence:(NSInteger)sequence;

-(void)loginWithPath:(NSString*)path
            withAuth:(KxSMBAuth*)auth;

-(void)accessWithPath:(NSString*)path
             withAuth:(KxSMBAuth*)auth;


@property (readwrite, nonatomic, strong) NSString   *path;
@property (readwrite, nonatomic, strong) KxSMBAuth  *auth;

@end
