//
//  BDSNewsTagTableViewCell.h
//  BDStockClient
//
//  Created by chengfei05 on 15/2/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDSNewsTagTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel    *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel    *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel    *fromLabel;

@end
