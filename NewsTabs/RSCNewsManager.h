//
//  RSCNewsTagsManager.h
//  NewsTabs
//
//  Created by rscdef on 14/12/13.
//  Copyright (c) 2014年 rscdef. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSCTagList.h"

@protocol RSCNewsManagerDelegate <NSObject>

@optional
- (void)onUpdateTags:(NSArray *)tags;

@end

@interface RSCNewsManager : NSObject

@property (nonatomic, weak) id<RSCNewsManagerDelegate> delegate;

+ (instancetype)sharedInstance;


#pragma mark - Tags
- (NSArray *)getAllTags;

@end
