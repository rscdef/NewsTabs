//
//  RSCNewsTagBarManager.m
//  NewsTabs
//
//  Created by rscdef on 15/2/10.
//  Copyright (c) 2015年 rscdef. All rights reserved.
//

#import "RSCNewsTagBarManager.h"
#import "RSCNewsManager.h"

@interface RSCNewsTagBarManager()<RSCNewsTagBarDelegate>

@end

@implementation RSCNewsTagBarManager

- (id)init {
    self = [super init];
    if (self) {
        self.tagBar = [RSCNewsTagBar createTabBar];
        self.tagBar.delegate = self;
        RSCNewsManager *newsMgr = [RSCNewsManager sharedInstance];
        NSArray *tags = [newsMgr getAllTags];
        [self resetTagBarWithTags:tags];
    }
    return self;
}

- (void)resetTagBarWithTags:(NSArray *)tags {
    NSMutableArray *tagInfos = [NSMutableArray arrayWithCapacity:10];
    CGFloat totalOffset = 0.;
    for (RSCTag *tag in tags) {
        RSCNewsTagInfo *tagInfo = [[RSCNewsTagInfo alloc] init];
        tagInfo.title = tag.name;
        tagInfo.originX = totalOffset;
        tagInfo.width = 100;
        totalOffset += tagInfo.width;
        [tagInfos addObject:tagInfo];
    }
    [self.tagBar setupWithTagInfos:tagInfos];
    [self.tagBar updateTagColorAtIndex:0 withOldIndex:NSNotFound andColorRatio:1];
}

- (void)onScrollContentPages:(CGFloat)offset {
    static NSInteger sLastPageIndex = 0;
    static CGFloat sLastOffset = 0.;
    
    NSInteger leftPageIndex = floorf(offset);
    NSInteger rightPageIndex = ceil(offset);
    //NSLog(@"offset: %f sLastPageIndex: %d [%d,%d]", offset, sLastPageIndex, leftPageIndex, rightPageIndex);
    
    NSInteger max = 0;
    NSInteger min = 0;
    if (leftPageIndex > rightPageIndex) {
        max = leftPageIndex;
        min = rightPageIndex;
    } else {
        max = rightPageIndex;
        min = leftPageIndex;
    }
    
    NSInteger newIndex = sLastPageIndex;
    NSInteger oldIndex = sLastPageIndex;
    
    if (sLastPageIndex == min && sLastPageIndex == max) {
        //NSLog(@"--");
//        if (offset < sLastOffset) { // scroll to left
//            //NSLog(@"(7)");
//            newIndex++;
//        } else if (offset > sLastOffset) { // scroll right
//            //NSLog(@"(8)");
//            newIndex--;
//        }
        if (sLastPageIndex == 0) {
            oldIndex = 1;
        }
    } else if (sLastPageIndex >= max) { // scroll to left page
        CGFloat ratio = sLastPageIndex - offset;
        //NSLog(@"<-");
        [_tagBar updateTagColorAtIndex:leftPageIndex withOldIndex:sLastPageIndex andColorRatio:ratio];
    } else if (sLastPageIndex <= min) { //scroll to right page
        CGFloat ratio = offset - sLastPageIndex;
        //NSLog(@"->");
        [_tagBar updateTagColorAtIndex:rightPageIndex withOldIndex:sLastPageIndex andColorRatio:ratio];
    }
    
    if (newIndex == oldIndex) {
        if (sLastPageIndex > max) {
            newIndex = max;
            //NSLog(@"(1)");
        } else if (sLastPageIndex < min) {
            newIndex = min;
            //NSLog(@"(2)");
        } else {
            NSInteger lastMax = ceil(sLastOffset);
            NSInteger lastMin = floorf(sLastOffset);
            NSInteger currMin = floorf(offset);
            if (lastMax != lastMin) {
                if (currMin > lastMin) { // currMin > lastMin : 1st -> 2nd; currMin < lastMin : 3rd -> 2nd
                    oldIndex = newIndex - 1;
                    //NSLog(@"(3)");
                } else if (currMin < lastMin) {
                    oldIndex = newIndex + 1;
                    //NSLog(@"(4)");
                }
            }
        }
    }
    
    if (newIndex != oldIndex) {
        //NSLog(@"offset: %f %f", offset, sLastOffset);
        [_tagBar updateTagColorAtIndex:newIndex withOldIndex:oldIndex andColorRatio:1.];
        sLastPageIndex = newIndex;
    }
    sLastOffset = offset;
}
/* bug needs fixing
 2015-02-27 17:20:19.840 BDStockClient[2151:234573] offset: 1.948437 sLastPageIndex: 2 [1,2]
 2015-02-27 17:20:19.853 BDStockClient[2151:234573] offset: 1.862500 sLastPageIndex: 2 [1,2]
 2015-02-27 17:20:19.870 BDStockClient[2151:234573] offset: 1.743750 sLastPageIndex: 2 [1,2]
 2015-02-27 17:20:19.886 BDStockClient[2151:234573] offset: 1.639063 sLastPageIndex: 2 [1,2]
 2015-02-27 17:20:19.902 BDStockClient[2151:234573] offset: 1.557812 sLastPageIndex: 2 [1,2]
 2015-02-27 17:20:19.948 BDStockClient[2151:234573] offset: 1.481250 sLastPageIndex: 2 [1,2]
 2015-02-27 17:20:19.950 BDStockClient[2151:234573] offset: 1.481250 sLastPageIndex: 2 [1,2]
 2015-02-27 17:20:19.955 BDStockClient[2151:234573] offset: 1.425000 sLastPageIndex: 2 [1,2]
 2015-02-27 17:20:19.957 BDStockClient[2151:234573] offset: 1.387500 sLastPageIndex: 2 [1,2]
 2015-02-27 17:20:20.094 BDStockClient[2151:234573] offset: 1.432812 sLastPageIndex: 2 [1,2]
 2015-02-27 17:20:20.113 BDStockClient[2151:234573] offset: 1.492188 sLastPageIndex: 2 [1,2]
 2015-02-27 17:20:20.161 BDStockClient[2151:234573] offset: 1.582813 sLastPageIndex: 2 [1,2]
 2015-02-27 17:20:20.163 BDStockClient[2151:234573] offset: 1.582813 sLastPageIndex: 2 [1,2]
 2015-02-27 17:20:20.168 BDStockClient[2151:234573] offset: 1.709375 sLastPageIndex: 2 [1,2]
 2015-02-27 17:20:20.171 BDStockClient[2151:234573] offset: 1.892187 sLastPageIndex: 2 [1,2]
 
 2015-02-27 17:20:20.174 BDStockClient[2151:234573] offset: 2.112500 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.321 BDStockClient[2151:234573] offset: 2.179688 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.343 BDStockClient[2151:234573] offset: 2.323437 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.361 BDStockClient[2151:234573] offset: 2.451562 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.380 BDStockClient[2151:234573] offset: 2.562500 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.382 BDStockClient[2151:234573] offset: 2.562500 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.419 BDStockClient[2151:234573] offset: 2.740625 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.431 BDStockClient[2151:234573] offset: 2.803125 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.442 BDStockClient[2151:234573] offset: 2.853125 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.453 BDStockClient[2151:234573] offset: 2.892188 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.470 BDStockClient[2151:234573] offset: 2.923438 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.486 BDStockClient[2151:234573] offset: 2.946875 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.503 BDStockClient[2151:234573] offset: 2.964062 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.520 BDStockClient[2151:234573] offset: 2.976562 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.536 BDStockClient[2151:234573] offset: 2.985938 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.553 BDStockClient[2151:234573] offset: 2.992188 sLastPageIndex: 2 [2,3]
 2015-02-27 17:20:20.570 BDStockClient[2151:234573] offset: 2.996875 sLastPageIndex: 2 [2,3]
 
 2015-02-27 17:20:20.586 BDStockClient[2151:234573] offset: 3.000000 sLastPageIndex: 2 [3,3]
*/



#pragma mark - BDSNewsTagBarDelegate
- (void)onSelectTagAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectTagAtIndex:)]) {
        [self.delegate onSelectTagAtIndex:index];
    }
}

- (void)onClickAddButton {
    
}

@end
