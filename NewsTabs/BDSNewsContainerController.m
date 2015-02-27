//
//  BDSNewsContainerController.m
//  BDStockClient
//
//  Created by chengfei05 on 15/2/9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDSNewsContainerController.h"
#import "BDSNewsTagBarManager.h"
#import "BDSNewsManager.h"
#import "BDSNewsTagController.h"


#pragma mark - BDSNewsContainerController
@interface BDSNewsContainerController ()<BDSNewsManagerDelegate, UIScrollViewDelegate, BDSNewsTagBarManagerDelegate> {
    BDSNewsManager *_tagMgr;
    NSInteger      _middleIndex;
    CGFloat        _middleOffsetX;
    CGFloat        _screenWidth;
}

@property (nonatomic, weak) IBOutlet UIScrollView       *scrollView;
@property (nonatomic, strong) BDSNewsTagBarManager      *tagBarMgr;

@property (nonatomic, strong) NSMutableArray            *tagItems;

@property (nonatomic, strong) BDSNewsTagController      *leftController;
@property (nonatomic, strong) BDSNewsTagController      *middleController;
@property (nonatomic, strong) BDSNewsTagController      *rightController;

@end

@implementation BDSNewsContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tagItems = [[NSMutableArray alloc] initWithCapacity:10];
    
    [BDSNewsManager sharedInstance].delegate = self;
    
    _screenWidth = ([[UIScreen mainScreen] bounds].size.width);
    CGFloat navHeight = 64;
    
    self.tagBarMgr = [[BDSNewsTagBarManager alloc] init];
    self.tagBarMgr.delegate = self;
    CGRect tabBarFrame = self.tagBarMgr.tagBar.frame;
    tabBarFrame.origin.y = navHeight;
    tabBarFrame.size.width = _screenWidth;
    self.tagBarMgr.tagBar.frame = tabBarFrame;
    [self.view addSubview:self.tagBarMgr.tagBar];
    

    _tagMgr = [BDSNewsManager sharedInstance];
    NSArray *tags = [_tagMgr getAllTags];
    [self setupContentPagesWithTags:tags];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BDSNewsManagerDelegate
- (void)onUpdateTags:(NSArray *)tags {
    [self.tagBarMgr resetTagBarWithTags:tags];
    [self setupContentPagesWithTags:tags];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self resetScrollViewContent:scrollView];
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger delta = MAX(_middleIndex - 1, 0);
    offsetX += delta * _screenWidth;
//    NSLog(@"scrollViewDidScroll: %f", offsetX);
    if (offsetX >= 0 && offsetX <= (_screenWidth * (_tagItems.count - 1))) {
        CGFloat offset = offsetX / _screenWidth;
//        NSLog(@"offset : %f", offset);
        [_tagBarMgr onScrollContentPages:offset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

#pragma mark - Content Pages
- (void)setupContentPagesWithTags:(NSArray *)tags {
    NSAssert(tags, @"[setupContentPagesWithTags] must has tags");
    // reset news tag items
    NSMutableArray *newTagItems = [NSMutableArray arrayWithCapacity:10];
    for (BDSTag *tag in tags) {
        BDSNewsTagItem *tagItem = nil;
        for (BDSNewsTagItem *item in _tagItems) {
            if ([item.tag isEqual:tag]) {
                tagItem = item;
                break;
            }
        }
        if (!tagItem) {
            tagItem = [[BDSNewsTagItem alloc] init];
            tagItem.tag = tag;
        }
        [newTagItems addObject:tagItem];
    }
    self.tagItems = newTagItems;
    
    if (_middleController) {
        BDSNewsTagItem *middleTag = _middleController.tagItem;
        NSInteger index = [_tagItems indexOfObject:middleTag];
        if (index != NSNotFound) {
            _middleIndex = index;
        } else {
            _middleIndex = 0;
        }
    } else {
        _middleIndex = 0;
    }
    
    [self resetPages];
}


- (BDSNewsTagController *)getControllerByTagItem:(BDSNewsTagItem *)tagItem inControllers:(NSArray *)controllers {
    BDSNewsTagController *result = nil;
    for (BDSNewsTagController *controller in controllers) {
        if ([controller.tagItem.tag isEqual:tagItem.tag]) {
            result = controller;
            break;
        }
    }
    return result;
}

- (BDSNewsTagController *)createNewsTagControllerWithTagItem:(BDSNewsTagItem *)tagItem {
    BDSNewsTagController *controller = [[BDSNewsTagController alloc] initWithTag:tagItem.tag];
    controller.tagItem = tagItem;
    return controller;
}

- (void)addControllerToScrollView:(BDSNewsTagController *)controller withOffsetX:(CGFloat)offsetX {
    CGRect frame = controller.view.frame;
    frame.origin.x = offsetX;
    frame.size.width = _screenWidth;
    frame.size.height = _scrollView.bounds.size.height;
    controller.view.frame = frame;

    [_scrollView addSubview:controller.view];
    [self addChildViewController:controller];
}

- (void)removeController:(BDSNewsTagController *)controller {
    BDSNewsTagItem *tagItem = controller.tagItem;
    if (tagItem) {
        CGFloat offsetY = controller.tableView.contentOffset.y;
        if (offsetY > 0) {
            tagItem.contentOffsetY = offsetY;
        }
    }
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

- (void)setScrollViewContentSize:(CGFloat)contentWidth {
    CGSize contentSize = _scrollView.contentSize;
    contentSize.width = contentWidth;
    _scrollView.contentSize = contentSize;
}

- (void)setScrollViewContentOffset:(CGFloat)contentOffsetX {
    CGPoint contentOffset = _scrollView.contentOffset;
    contentOffset.x = contentOffsetX;
    _scrollView.contentOffset = contentOffset;
}

- (void)resetScrollViewContent:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    NSInteger tagCount = _tagItems.count;
    
    CGFloat maxOffsetX = (tagCount - 1) * _screenWidth;
    if (contentOffsetX < 0 || contentOffsetX > maxOffsetX) {
        return;
    }
    
    CGFloat halfScreenWidth = _screenWidth / 2.;
    
    if (contentOffsetX > _middleOffsetX + halfScreenWidth && _middleIndex + 1 < tagCount) { // scroll to right page
        _middleIndex++;
        CGFloat offsetX = 0.;
        CGFloat totalOffset = 0;
        if (_leftController) {
            [self removeController:_leftController];
            offsetX += _screenWidth;
        }
        if (_middleController) {
            CGRect frame = _middleController.view.frame;
            frame.origin.x -= offsetX;
            _middleController.view.frame = frame;
            self.leftController = _middleController;
            totalOffset += _screenWidth;
        }
        if (_rightController) {
            CGRect frame = _rightController.view.frame;
            frame.origin.x -= offsetX;
            _rightController.view.frame = frame;
            self.middleController = _rightController;
            _middleOffsetX = totalOffset;
            totalOffset += _screenWidth;
        }
        if (_middleIndex + 1 < tagCount) {
            BDSNewsTagItem *tagItem = _tagItems[_middleIndex + 1];
            BDSNewsTagController *controller = [self createNewsTagControllerWithTagItem:tagItem];
            [self addControllerToScrollView:controller withOffsetX:_screenWidth * 2];
            self.rightController = controller;
            totalOffset += _screenWidth;
        } else {
            self.rightController = nil;
        }
        
        CGPoint contentOffset = _scrollView.contentOffset;
        if (_middleIndex - 1 > 0) {
            contentOffset.x -= _screenWidth;
            _scrollView.contentOffset = contentOffset;
        }
        [self setScrollViewContentSize:totalOffset];
    } else if (contentOffsetX < _middleOffsetX - halfScreenWidth && _middleIndex - 1 > 0) { // scroll to left page
        _middleIndex--;
        CGFloat offsetX = 0.;
        CGFloat totalOffset = 0;
        BDSNewsTagController *tmpLeftController = nil;
        if (_middleIndex > 0) {
            BDSNewsTagItem *tagItem = _tagItems[_middleIndex - 1];
            BDSNewsTagController *controller = [self createNewsTagControllerWithTagItem:tagItem];
            [self addControllerToScrollView:controller withOffsetX:0];
            tmpLeftController = controller;
            offsetX += _screenWidth;
            totalOffset += _screenWidth;
        } else {
            tmpLeftController = nil;
        }
        if (_rightController) {
            [self removeController:_rightController];
        }
        if (_middleController) {
            CGRect frame = _middleController.view.frame;
            frame.origin.x += offsetX;
            _middleController.view.frame = frame;
            self.rightController = _middleController;
            totalOffset += _screenWidth;
        }
        if (_leftController) {
            CGRect frame = _leftController.view.frame;
            frame.origin.x += offsetX;
            _leftController.view.frame = frame;
            self.middleController = _leftController;
            _middleOffsetX = offsetX;
            totalOffset += _screenWidth;
        }
        self.leftController = tmpLeftController;
        
        
        CGPoint contentOffset = _scrollView.contentOffset;
        if (_middleIndex > 0) {
            contentOffset.x += _screenWidth;
            _scrollView.contentOffset = contentOffset;
        }
        [self setScrollViewContentSize:totalOffset];
    }
}

#pragma mark - BDSNewsTagBarDelegate
- (void)onSelectTagAtIndex:(NSInteger)index {
    NSInteger tagCount = _tagItems.count;
    if (index < 0 || index >= tagCount) {
        return;
    }
    
    _middleIndex = index;
    
    [self resetPages];
}

- (void)resetPages {
    NSMutableArray *currentControllers = [NSMutableArray arrayWithCapacity:3];
    if (_leftController) {
        [currentControllers addObject:_leftController];
    }
    if (_middleController) {
        [currentControllers addObject:_middleController];
    }
    if (_rightController) {
        [currentControllers addObject:_rightController];
    }
    
    NSInteger tagCount = _tagItems.count;
    
    CGFloat contentOffsetX = 0.;
    
    // setup left controller
    if (_middleIndex > 0) {
        BDSNewsTagItem *leftTagItem = _tagItems[_middleIndex - 1];
        BDSNewsTagController *controller = [self getControllerByTagItem:leftTagItem inControllers:currentControllers];
        if (!controller || controller != _leftController) {
            if (controller) {
                [self removeController:controller];
                [currentControllers removeObject:controller];
            } else {
                controller = [self createNewsTagControllerWithTagItem:leftTagItem];
            }
            
            [self addControllerToScrollView:controller withOffsetX:0];
            self.leftController = controller;
        } else {
            [currentControllers removeObject:controller];
        }
        contentOffsetX += _screenWidth;
    } else {
        self.leftController = nil;
    }
    
    // setup middle controller
    if (_middleIndex < tagCount) {
        BDSNewsTagItem *middleTagItem = _tagItems[_middleIndex];
        BDSNewsTagController *controller = [self getControllerByTagItem:middleTagItem inControllers:currentControllers];
        if (!controller || controller != _middleController) {
            if (controller) {
                [self removeController:controller];
                [currentControllers removeObject:controller];
            } else {
                controller = [self createNewsTagControllerWithTagItem:middleTagItem];
            }
            
            [self addControllerToScrollView:controller withOffsetX:contentOffsetX];
            self.middleController = controller;
        } else {
            [currentControllers removeObject:controller];
        }
        _middleOffsetX = contentOffsetX;
        contentOffsetX += _screenWidth;
    } else {
        self.middleController = nil;
    }
    
    // setup right controller
    if (_middleIndex + 1 < tagCount) {
        BDSNewsTagItem *rightTagItem = _tagItems[_middleIndex + 1];
        BDSNewsTagController *controller = [self getControllerByTagItem:rightTagItem inControllers:currentControllers];
        if (!controller || controller != _rightController) {
            if (controller) {
                [self removeController:controller];
                [currentControllers removeObject:controller];
            } else {
                controller = [self createNewsTagControllerWithTagItem:rightTagItem];
            }
            
            [self addControllerToScrollView:controller withOffsetX:contentOffsetX];
            self.rightController = controller;
        } else {
            [currentControllers removeObject:controller];
        }
        contentOffsetX += _screenWidth;
    } else {
        self.rightController = nil;
    }
    
    for (BDSNewsTagController *controller in currentControllers) {
        [self removeController:controller];
    }
    
    [self setScrollViewContentSize:contentOffsetX];
    [self setScrollViewContentOffset:_middleOffsetX];
}

@end
