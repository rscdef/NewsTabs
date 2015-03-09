//
//  RSCNewsTagDataSource.h
//  NewsTabs
//
//  Created by rscdef on 15/2/15.
//  Copyright (c) 2015年 rscdef. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSCTagList.h"

@interface RSCNewsTagDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

+ (instancetype)dataSourceWithTag:(RSCTag *)tag;

@end
