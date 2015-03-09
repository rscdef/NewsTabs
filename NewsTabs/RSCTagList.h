//
//  RSCNewsSubscription.h
//  NewsTabs
//
//  Created by rscdef on 14/11/14.
//  Copyright (c) 2014年 rscdef. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSCTag : NSObject <NSCopying, NSCoding>

@property (nonatomic, strong) NSString *tagId;
@property (nonatomic, strong) NSString *name;

@end


@interface RSCTagList : NSObject

@property (nonatomic, strong) NSArray *tags;

@end