//
//  RSCNewsContainerScrollView.m
//  NewsTabs
//
//  Created by rscdef on 15/2/28.
//  Copyright (c) 2015年 rscdef. All rights reserved.
//

#import "RSCNewsContainerScrollView.h"

@interface RSCNewsContainerScrollView() {
    BOOL _touchUp;
}

@end

@implementation RSCNewsContainerScrollView

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    UITouch *touch = [touches anyObject];
    NSLog(@"toucn phase: %d", touch.phase);
    return YES;
}

- (BOOL)isTouchUp {
    return _touchUp;
}

@end
