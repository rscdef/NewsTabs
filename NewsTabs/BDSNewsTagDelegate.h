//
//  BDSNewsTagDelegate.h
//  BDStockClient
//
//  Created by chengfei05 on 15/2/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDSNewsTagDelegate :NSObject <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
