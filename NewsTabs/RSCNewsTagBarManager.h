//
//  RSCNewsTagBarManager.h
//  NewsTabs
//
//  Created by rscdef on 15/2/10.
//  Copyright (c) 2015年 rscdef. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSCNewsTagBar.h"

@protocol BDSNewsTagBarManagerDelegate <NSObject>

- (void)onSelectTagAtIndex:(NSInteger)index;

@end

@interface RSCNewsTagBarManager : NSObject

@property (nonatomic, strong) RSCNewsTagBar *tagBar;

@property (nonatomic, weak) id<BDSNewsTagBarManagerDelegate> delegate;

- (void)resetTagBarWithTags:(NSArray *)tags;

- (void)onScrollContentPages:(CGFloat)offset;

- (void)scrollToIndex:(NSInteger)index;

@end
