//
//  BDSNewsTabBar.m
//  BDStockClient
//
//  Created by chengfei05 on 15/2/9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDSNewsTagBar.h"
#import "BDSNewsManager.h"

@implementation BDSNewsTagInfo

@end

@interface BDSNewsTagBar() {
    NSInteger _lastIndex;
}

@property (nonatomic, strong) IBOutlet UIScrollView       *scrollView;
@property (nonatomic, strong) NSMutableArray              *tagButtons;
@property (nonatomic, strong) NSArray                     *tagInfos;

@end

@implementation BDSNewsTagBar

+ (BDSNewsTagBar *)createTabBar {
    return [[NSBundle mainBundle] loadNibNamed:@"BDSNewsTagBar" owner:nil options:nil][0];
}

- (void)awakeFromNib {
    self.tagButtons = [NSMutableArray arrayWithCapacity:10];
}

- (void)setupWithTagInfos:(NSArray *)tagInfos {
    self.tagInfos = tagInfos;
    [[self.scrollView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        [view removeFromSuperview];
    }];
    [self.tagButtons removeAllObjects];
    NSInteger index = 0;
    CGFloat contentWidth = 0.;
    for (BDSNewsTagInfo *tag in tagInfos) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(contentWidth, 0, tag.width, 44);
        [btn setTitle:tag.title forState:UIControlStateNormal];
        btn.tag = index;
        [btn addTarget:self action:@selector(onSelectTagButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [self.tagButtons addObject:btn];
        index++;
        contentWidth += btn.frame.size.width;
    }
    [self.scrollView setContentSize:CGSizeMake(contentWidth, self.scrollView.bounds.size.height)];
}

- (IBAction)onAddButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickAddButton)]) {
        [self.delegate onClickAddButton];
    }
}

- (void)onSelectTagButtonClicked:(id)sender {
    UIButton *tagBtn = sender;
    NSInteger index = tagBtn.tag;
    if (index == _lastIndex) {
        return;
    }
    [self updateTagColorAtIndex:index withOldIndex:_lastIndex];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectTagAtIndex:)]) {
        [self.delegate onSelectTagAtIndex:tagBtn.tag];
    }
}

- (void)updateTagColorAtIndex:(NSInteger)index withOldIndex:(NSInteger)oldIndex andColorRatio:(float)ratio {
    NSLog(@"updateTagColorAtIndex : %d - %d : %f", index, oldIndex, ratio);
    if (ratio < 0 || ratio > 1) {
        return;
    }
    NSInteger count =  _tagButtons.count;
    UIButton *newBtn = nil;
    if (index < count && index >= 0) {
        newBtn = _tagButtons[index];
    }
    UIButton *oldBtn = nil;
    if (oldIndex < count && oldIndex >= 0) {
        oldBtn = _tagButtons[oldIndex];
    }
    
    float reverseRatio = (1. - ratio);
    UIColor *newColor = [UIColor colorWithRed:1. green:reverseRatio blue:reverseRatio alpha:1.];
    UIColor *oldColor = [UIColor colorWithRed:1. green:ratio blue:ratio alpha:1.];
    [newBtn setTitleColor:newColor forState:UIControlStateNormal];
    [oldBtn setTitleColor:oldColor forState:UIControlStateNormal];
    
    if (ratio == 1.0) {
        [self updateTagColorAtIndex:index withOldIndex:oldIndex];
    }
}

- (void)updateTagColorAtIndex:(NSInteger)index withOldIndex:(NSInteger)oldIndex {
    if (index == oldIndex) {
        oldIndex = NSNotFound;
    }
    NSInteger count =  _tagButtons.count;
    UIButton *newBtn = nil;
    if (index < count && index >= 0) {
        newBtn = _tagButtons[index];
    }
    UIButton *oldBtn = nil;
    if (oldIndex < count && oldIndex >= 0) {
        oldBtn = _tagButtons[oldIndex];
    }
    UIColor *newColor = [UIColor redColor];
    UIColor *oldColor = [UIColor whiteColor];
    
    [newBtn setTitleColor:newColor forState:UIControlStateNormal];
    [oldBtn setTitleColor:oldColor forState:UIControlStateNormal];
    
    _lastIndex = index;
    
    [self scrollToCurrentIndex];
}

- (void)scrollToCurrentIndex {
    BDSNewsTagInfo *tagInfo = _tagInfos[_lastIndex];
    CGFloat scrollWidth = self.scrollView.bounds.size.width;
    CGFloat halfScrollWidth = scrollWidth / 2.;
    CGFloat offset = tagInfo.originX + (tagInfo.width / 2.) - halfScrollWidth;
    if (offset < 0) {
        offset = 0;
    }
    BDSNewsTagInfo *lastTagInfo = [_tagInfos lastObject];
    CGFloat length = lastTagInfo.originX + lastTagInfo.width;
    CGFloat len = offset + scrollWidth;
    if (len > length) {
        offset = length - scrollWidth;
    }
    
    [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

@end
