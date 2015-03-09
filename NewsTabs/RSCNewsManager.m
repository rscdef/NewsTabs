//
//  RSCNewsTagsManager.m
//  NewsTabs
//
//  Created by rscdef on 14/12/13.
//  Copyright (c) 2014年 rscdef. All rights reserved.
//

#import "RSCNewsManager.h"


@interface RSCNewsManager ()

@property (nonatomic, strong) NSMutableArray *tags;

@end

@implementation RSCNewsManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred          = 0;
    static RSCNewsManager  *sharedObject = nil;
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
            RSCTag *tag = [[RSCTag alloc] init];
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
