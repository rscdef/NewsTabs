//
//  RSCNewsSubscription.m
//  NewsTabs
//
//  Created by rscdef on 14/11/14.
//  Copyright (c) 2014年 rscdef. All rights reserved.
//

#import "RSCTagList.h"

@implementation RSCTag

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[RSCTag class]]) {
        return NO;
    }
    if (self == object) {
        return YES;
    }
    RSCTag *obj = object;
    if ([_tagId isEqualToString:obj.tagId] || [_name isEqualToString:obj.name]) {
        return YES;
    }

    return NO;
}



@end


@implementation RSCTagList

@end