//
//  BDSNewsTagController.h
//  BDStockClient
//
//  Created by chengfei05 on 15/2/9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDSNewsTagProvider.h"
#import "BDSNewsTagDataSource.h"
#import "BDSNewsTagDelegate.h"

#pragma mark - BDSNewsTagItem
@interface BDSNewsTagItem : NSObject

@property (nonatomic, strong) BDSTag            *tag;
@property (nonatomic, weak)   UIViewController  *controller;
@property (nonatomic, assign) CGFloat           contentOffsetY;
@property (nonatomic, assign) NSTimeInterval    lastUpdateTime;

@end

@interface BDSNewsTagController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView        *tableView;

@property (nonatomic, strong) BDSTag                    *tag;

@property (nonatomic, strong) BDSNewsTagProvider        *provider;
@property (nonatomic, strong) BDSNewsTagDataSource      *dataSource;

@property (nonatomic, strong) BDSNewsTagItem            *tagItem;

- (id)initWithTag:(BDSTag *)aTag;

- (void)refreshData;

@end
