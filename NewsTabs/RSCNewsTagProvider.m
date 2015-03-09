//
//  RSCNewsTagProvider.m
//  NewsTabs
//
//  Created by rscdef on 15/2/15.
//  Copyright (c) 2015年 rscdef. All rights reserved.
//

#import "RSCNewsTagProvider.h"
#import "RSCNewsTagKeyProvider.h"
#import "RSCNewsTagStockProvider.h"
#import "RSCNewsTagUserProvider.h"

@implementation RSCNewsTagProvider

+ (instancetype)providerWithTag:(RSCTag *)tag {
    RSCNewsTagProvider *provider = nil;
    if ([tag.name isEqualToString:@"News"]) {
        provider = [[RSCNewsTagKeyProvider alloc] init];
    } else if ([tag.name isEqualToString:@"Stocks"]) {
        provider = [[RSCNewsTagStockProvider alloc] init];
    } else {
        provider = [[RSCNewsTagUserProvider alloc] init];
    }
    provider.tag = tag;
    return provider;
}

- (void)loadCacheWithCompletionBlock:(RSCModelProviderResult)completionBlock {
    
}

- (void)refreshWithCompletionBlock:(RSCModelProviderResult)completionBlock {
    
}

- (void)loadMoreWithCompletionBlock:(RSCModelProviderResult)completionBlock {
    
}


@end
