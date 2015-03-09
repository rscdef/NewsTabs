//
//  RSCNewsTagProvider.h
//  NewsTabs
//
//  Created by rscdef on 15/2/15.
//  Copyright (c) 2015年 rscdef. All rights reserved.
//

#import "RSCModelProvider.h"
#import "RSCTagList.h"

@interface RSCNewsTagProvider : RSCModelProvider

@property (nonatomic, strong) RSCTag    *tag;

+ (instancetype)providerWithTag:(RSCTag *)tag;

#pragma mark - Overwrites
- (void)loadCacheWithCompletionBlock:(RSCModelProviderResult)completionBlock;
- (void)refreshWithCompletionBlock:(RSCModelProviderResult)completionBlock;
- (void)loadMoreWithCompletionBlock:(RSCModelProviderResult)completionBlock;

@end
