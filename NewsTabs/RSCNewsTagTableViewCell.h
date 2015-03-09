//
//  RSCNewsTagTableViewCell.h
//  NewsTabs
//
//  Created by rscdef on 15/2/20.
//  Copyright (c) 2015年 rscdef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSCNewsTagTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel    *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel    *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel    *fromLabel;

@end
