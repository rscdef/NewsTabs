//
//  RSCNewsTagDataSource.m
//  NewsTabs
//
//  Created by rscdef on 15/2/15.
//  Copyright (c) 2015年 rscdef. All rights reserved.
//

#import "RSCNewsTagDataSource.h"
#import "RSCNewsTagKeyDataSource.h"
#import "RSCNewsTagStockDataSource.h"
#import "RSCNewsTagUserDataSource.h"
#import "RSCNewsTagTableViewCell.h"

@implementation RSCNewsTagDataSource

+ (instancetype)dataSourceWithTag:(RSCTag *)tag {
    RSCNewsTagDataSource *dataSource = nil;
    if ([tag.name isEqualToString:@"News"]) {
        dataSource = [[RSCNewsTagKeyDataSource alloc] init];
    } else if ([tag.name isEqualToString:@"Stocks"]) {
        dataSource = [[RSCNewsTagStockDataSource alloc] init];
    } else {
        dataSource = [[RSCNewsTagUserDataSource alloc] init];
    }
    return dataSource;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sReuseCell = @"RSCNewsTagTableViewCell";
    RSCNewsTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sReuseCell];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:@"RSCNewsTagTableViewCell" bundle:nil];
        cell = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        [tableView registerNib:nib forCellReuseIdentifier:sReuseCell];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"Title %d", indexPath.row];
    cell.timeLabel.text = @"2014.12.1";
    cell.fromLabel.text = @"From:";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
