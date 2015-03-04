//
//  BDSNewsTagBarManager.h
//  BDStockClient
//
//  Created by chengfei05 on 15/2/10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDSNewsTagBar.h"

@protocol BDSNewsTagBarManagerDelegate <NSObject>

- (void)onSelectTagAtIndex:(NSInteger)index;

@end

@interface BDSNewsTagBarManager : NSObject

@property (nonatomic, strong) BDSNewsTagBar *tagBar;

@property (nonatomic, weak) id<BDSNewsTagBarManagerDelegate> delegate;

- (void)resetTagBarWithTags:(NSArray *)tags;

- (void)onScrollContentPages:(CGFloat)offset;

- (void)scrollToIndex:(NSInteger)index;

@end
