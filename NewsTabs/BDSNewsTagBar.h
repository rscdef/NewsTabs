//
//  BDSNewsTabBar.h
//  BDStockClient
//
//  Created by chengfei05 on 15/2/9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDSTagList.h"

@protocol BDSNewsTagBarDelegate <NSObject>

- (void)onSelectTagAtIndex:(NSInteger)index;
- (void)onClickAddButton;

@end


@interface BDSNewsTagInfo : NSObject

@property (nonatomic, strong) NSString  *title;
@property (nonatomic, assign) CGFloat   originX;
@property (nonatomic, assign) CGFloat   width;

@end



@interface BDSNewsTagBar : UIView

@property (nonatomic, weak) id<BDSNewsTagBarDelegate> delegate;

+ (BDSNewsTagBar *)createTabBar;

- (void)setupWithTagInfos:(NSArray *)tagInfos;

- (IBAction)onAddButtonClicked:(id)sender;

- (void)updateTagColorAtIndex:(NSInteger)index withOldIndex:(NSInteger)oldIndex andColorRatio:(float)ratio;

@end
