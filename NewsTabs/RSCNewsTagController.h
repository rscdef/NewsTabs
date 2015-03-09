//
//  RSCNewsTagController.h
//  NewsTabs
//
//  Created by rscdef on 15/2/9.
//  Copyright (c) 2015年 rscdef. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSCNewsTagProvider.h"
#import "RSCNewsTagDataSource.h"
#import "RSCNewsTagDelegate.h"

#pragma mark - BDSNewsTagItem
@interface RSCNewsTagItem : NSObject

@property (nonatomic, strong) RSCTag            *tag;
@property (nonatomic, weak)   UIViewController  *controller;
@property (nonatomic, assign) CGFloat           contentOffsetY;
@property (nonatomic, assign) NSTimeInterval    lastUpdateTime;

@end

@interface RSCNewsTagController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView        *tableView;

@property (nonatomic, strong) RSCTag                    *tag;

@property (nonatomic, strong) RSCNewsTagProvider        *provider;
@property (nonatomic, strong) RSCNewsTagDataSource      *dataSource;

@property (nonatomic, strong) RSCNewsTagItem            *tagItem;

- (id)initWithTag:(RSCTag *)aTag;

- (void)refreshData;

@end
