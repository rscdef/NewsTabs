//
//  BDSNewsContainerScrollView.m
//  NewsTabs
//
//  Created by chengfei05 on 15/2/28.
//  Copyright (c) 2015年 rscdef. All rights reserved.
//

#import "BDSNewsContainerScrollView.h"

@interface BDSNewsContainerScrollView() {
    BOOL _touchUp;
}

@end

@implementation BDSNewsContainerScrollView

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    UITouch *touch = [touches anyObject];
    NSLog(@"toucn phase: %d", touch.phase);
    return YES;
}

- (BOOL)isTouchUp {
    return _touchUp;
}

@end
