//
//  RSCNewsTabBar.h
//  NewsTabs
//
//  Created by rscdef on 15/2/9.
//  Copyright (c) 2015年 rscdef. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSCTagList.h"

@protocol RSCNewsTagBarDelegate <NSObject>

- (void)onSelectTagAtIndex:(NSInteger)index;
- (void)onClickAddButton;

@end


@interface RSCNewsTagInfo : NSObject

@property (nonatomic, strong) NSString  *title;
@property (nonatomic, assign) CGFloat   originX;
@property (nonatomic, assign) CGFloat   width;

@end



@interface RSCNewsTagBar : UIView

@property (nonatomic, weak) id<RSCNewsTagBarDelegate> delegate;

+ (RSCNewsTagBar *)createTabBar;

- (void)setupWithTagInfos:(NSArray *)tagInfos;

- (IBAction)onAddButtonClicked:(id)sender;

- (void)updateTagColorAtIndex:(NSInteger)index withOldIndex:(NSInteger)oldIndex andColorRatio:(float)ratio;

@end
