//
//  BDSNewsTagsManager.h
//  BDStockClient
//
//  Created by chengfei05 on 14/12/13.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDSTagList.h"

@protocol BDSNewsManagerDelegate <NSObject>

@optional
- (void)onUpdateTags:(NSArray *)tags;

@end

@interface BDSNewsManager : NSObject

@property (nonatomic, weak) id<BDSNewsManagerDelegate> delegate;

+ (instancetype)sharedInstance;


#pragma mark - Tags
- (NSArray *)getAllTags;

@end
