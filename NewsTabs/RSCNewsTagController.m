//
//  RSCNewsTagController.m
//  NewsTabs
//
//  Created by rscdef on 15/2/9.
//  Copyright (c) 2015年 rscdef. All rights reserved.
//

#import "RSCNewsTagController.h"

#pragma mark - BDSNewsTagItem
@implementation RSCNewsTagItem

@end


#pragma mark - BDSNewsTagController
@interface RSCNewsTagController ()

@end

@implementation RSCNewsTagController

- (id)initWithTag:(RSCTag *)aTag {
    self = [super init];
    if (self) {
        _tag = aTag;
        self.provider = [RSCNewsTagProvider providerWithTag:aTag];
        self.dataSource = [RSCNewsTagDataSource dataSourceWithTag:aTag];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    [self.provider loadCacheWithCompletionBlock:^(int code, id resultObj) {
        
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    label.text = _tag.name;
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    // pull to refresh automatically
    
    
    [self.provider refreshWithCompletionBlock:^(int code, id resultObj) {
        
    }];
}


@end
