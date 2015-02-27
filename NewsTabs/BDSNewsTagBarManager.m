//
//  BDSNewsTagBarManager.m
//  BDStockClient
//
//  Created by chengfei05 on 15/2/10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDSNewsTagBarManager.h"
#import "BDSNewsManager.h"

@interface BDSNewsTagBarManager()<BDSNewsTagBarDelegate>

@end

@implementation BDSNewsTagBarManager

- (id)init {
    self = [super init];
    if (self) {
        self.tagBar = [BDSNewsTagBar createTabBar];
        self.tagBar.delegate = self;
        BDSNewsManager *newsMgr = [BDSNewsManager sharedInstance];
        NSArray *tags = [newsMgr getAllTags];
        [self resetTagBarWithTags:tags];
    }
    return self;
}

- (void)resetTagBarWithTags:(NSArray *)tags {
    NSMutableArray *tagInfos = [NSMutableArray arrayWithCapacity:10];
    for (BDSTag *tag in tags) {
        BDSNewsTagInfo *tagInfo = [[BDSNewsTagInfo alloc] init];
        tagInfo.title = tag.name;
        tagInfo.width = 100;
        [tagInfos addObject:tagInfo];
    }
    [self.tagBar setupWithTagInfos:tagInfos];
    [self.tagBar updateTagColorAtIndex:0 withOldIndex:NSNotFound andColorRatio:1];
}

- (void)onScrollContentPages:(CGFloat)offset {
    static NSInteger sLastPageIndex = 0;
    NSInteger leftPageIndex = floorf(offset);
    NSInteger rightPageIndex = ceil(offset);
    NSLog(@"offset: %f sLastPageIndex: %d [%d,%d]", offset, sLastPageIndex, leftPageIndex, rightPageIndex);
    
    NSInteger max = 0;
    NSInteger min = 0;
    if (leftPageIndex > rightPageIndex) {
        max = leftPageIndex;
        min = rightPageIndex;
    } else {
        max = rightPageIndex;
        min = leftPageIndex;
    }
    
    if (sLastPageIndex >= max) { // scroll to left page
        CGFloat ratio = sLastPageIndex - offset;
        [_tagBar updateTagColorAtIndex:leftPageIndex withOldIndex:sLastPageIndex andColorRatio:ratio];
    } else if (sLastPageIndex <= min) { //scroll to right page
        CGFloat ratio = offset - sLastPageIndex;
        [_tagBar updateTagColorAtIndex:rightPageIndex withOldIndex:sLastPageIndex andColorRatio:ratio];
    }
    
    NSInteger newIndex = sLastPageIndex;
    if (sLastPageIndex > max) {
        newIndex = max;
    } else if (sLastPageIndex < min) {
        newIndex = min;
    }
    if (sLastPageIndex != newIndex) {
        [_tagBar updateTagColorAtIndex:newIndex withOldIndex:sLastPageIndex andColorRatio:1.];
        sLastPageIndex = newIndex;
    }
}

#pragma mark - BDSNewsTagBarDelegate
- (void)onSelectTagAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectTagAtIndex:)]) {
        [self.delegate onSelectTagAtIndex:index];
    }
}

- (void)onClickAddButton {
    
}

@end
