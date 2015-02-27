//
//  BDSNewsSubscription.h
//  BDStockClient
//
//  Created by chengfei05 on 14/11/14.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDSTag : NSObject <NSCopying, NSCoding>

@property (nonatomic, strong) NSString *tagId;
@property (nonatomic, strong) NSString *name;

@end


@interface BDSTagList : NSObject

@property (nonatomic, strong) NSArray *tags;

@end