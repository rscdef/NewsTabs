//
//  BDSNewsTagDataSource.m
//  BDStockClient
//
//  Created by chengfei05 on 15/2/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDSNewsTagDataSource.h"
#import "BDSNewsTagKeyDataSource.h"
#import "BDSNewsTagStockDataSource.h"
#import "BDSNewsTagUserDataSource.h"
#import "BDSNewsTagTableViewCell.h"

@implementation BDSNewsTagDataSource

+ (instancetype)dataSourceWithTag:(BDSTag *)tag {
    BDSNewsTagDataSource *dataSource = nil;
    if ([tag.name isEqualToString:@"News"]) {
        dataSource = [[BDSNewsTagKeyDataSource alloc] init];
    } else if ([tag.name isEqualToString:@"Stocks"]) {
        dataSource = [[BDSNewsTagStockDataSource alloc] init];
    } else {
        dataSource = [[BDSNewsTagUserDataSource alloc] init];
    }
    return dataSource;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sReuseCell = @"BDSNewsTagTableViewCell";
    BDSNewsTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sReuseCell];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:@"BDSNewsTagTableViewCell" bundle:nil];
        cell = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        [tableView registerNib:nib forCellReuseIdentifier:sReuseCell];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"标题%d", indexPath.row];
    cell.timeLabel.text = @"2014.12.1";
    cell.fromLabel.text = @"来源:";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
