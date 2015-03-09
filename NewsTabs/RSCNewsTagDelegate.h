//
//  RSCNewsTagDelegate.h
//  NewsTabs
//
//  Created by rscdef on 15/2/15.
//  Copyright (c) 2015年 rscdef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSCNewsTagDelegate :NSObject <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
