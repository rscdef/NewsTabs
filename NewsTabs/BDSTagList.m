//
//  BDSNewsSubscription.m
//  BDStockClient
//
//  Created by chengfei05 on 14/11/14.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "BDSTagList.h"

@implementation BDSTag

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[BDSTag class]]) {
        return NO;
    }
    if (self == object) {
        return YES;
    }
    BDSTag *obj = object;
    if ([_tagId isEqualToString:obj.tagId] || [_name isEqualToString:obj.name]) {
        return YES;
    }

    return NO;
}



@end


@implementation BDSTagList

@end