//
//  BDSNewsTagsManager.m
//  BDStockClient
//
//  Created by chengfei05 on 14/12/13.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "BDSNewsManager.h"


@interface BDSNewsManager ()

@property (nonatomic, strong) NSMutableArray *tags;

@end

@implementation BDSNewsManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred          = 0;
    static BDSNewsManager  *sharedObject = nil;
    dispatch_once(&pred, ^{
        sharedObject = [[self alloc] init];
    });

    return sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        self.tags = [NSMutableArray arrayWithCapacity:10];
        for (NSInteger i = 0; i < 10; i++) {
            BDSTag *tag = [[BDSTag alloc] init];
            tag.tagId = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:i]];
            tag.name = [NSString stringWithFormat:@"Tag %@", tag.tagId];
            [self.tags addObject:tag];
        }
    }
    return self;
}

- (NSArray *)getAllTags {
    return self.tags;
}


@end
