//
//  BDSNewsTagProvider.m
//  BDStockClient
//
//  Created by chengfei05 on 15/2/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDSNewsTagProvider.h"
#import "BDSNewsTagKeyProvider.h"
#import "BDSNewsTagStockProvider.h"
#import "BDSNewsTagUserProvider.h"

@implementation BDSNewsTagProvider

+ (instancetype)providerWithTag:(BDSTag *)tag {
    BDSNewsTagProvider *provider = nil;
    if ([tag.name isEqualToString:@"News"]) {
        provider = [[BDSNewsTagKeyProvider alloc] init];
    } else if ([tag.name isEqualToString:@"Stocks"]) {
        provider = [[BDSNewsTagStockProvider alloc] init];
    } else {
        provider = [[BDSNewsTagUserProvider alloc] init];
    }
    provider.tag = tag;
    return provider;
}

- (void)loadCacheWithCompletionBlock:(BDSModelProviderResult)completionBlock {
    
}

- (void)refreshWithCompletionBlock:(BDSModelProviderResult)completionBlock {
    
}

- (void)loadMoreWithCompletionBlock:(BDSModelProviderResult)completionBlock {
    
}


@end
