//
//  BDSNewsTagProvider.h
//  BDStockClient
//
//  Created by chengfei05 on 15/2/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDSModelProvider.h"
#import "BDSTagList.h"

@interface BDSNewsTagProvider : BDSModelProvider

@property (nonatomic, strong) BDSTag    *tag;

+ (instancetype)providerWithTag:(BDSTag *)tag;

#pragma mark - Overwrites
- (void)loadCacheWithCompletionBlock:(BDSModelProviderResult)completionBlock;
- (void)refreshWithCompletionBlock:(BDSModelProviderResult)completionBlock;
- (void)loadMoreWithCompletionBlock:(BDSModelProviderResult)completionBlock;

@end
