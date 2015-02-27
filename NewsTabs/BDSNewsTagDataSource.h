//
//  BDSNewsTagDataSource.h
//  BDStockClient
//
//  Created by chengfei05 on 15/2/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDSTagList.h"

@interface BDSNewsTagDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

+ (instancetype)dataSourceWithTag:(BDSTag *)tag;

@end
