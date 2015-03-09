//
//  RSCNewsContainerController.m
//  NewsTabs
//
//  Created by rscdef on 15/2/9.
//  Copyright (c) 2015年 rscdef. All rights reserved.
//

#import "RSCNewsContainerController.h"
#import "RSCNewsTagBarManager.h"
#import "RSCNewsManager.h"
#import "RSCNewsTagController.h"


#pragma mark - BDSNewsContainerController
@interface RSCNewsContainerController ()<RSCNewsManagerDelegate, UIScrollViewDelegate, BDSNewsTagBarManagerDelegate> {
    RSCNewsManager *_tagMgr;
    NSInteger      _middleIndex;
    CGFloat        _middleOffsetX;
    CGFloat        _screenWidth;
    NSInteger      _indexDelta; // -1: to left; 0: disable; 1: to right.
}

@property (nonatomic, weak) IBOutlet UIScrollView       *scrollView;
@property (nonatomic, strong) RSCNewsTagBarManager      *tagBarMgr;

@property (nonatomic, strong) NSMutableArray            *tagItems;

@property (nonatomic, strong) RSCNewsTagController      *leftController;
@property (nonatomic, strong) RSCNewsTagController      *middleController;
@property (nonatomic, strong) RSCNewsTagController      *rightController;

@end

@implementation RSCNewsContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tagItems = [[NSMutableArray alloc] initWithCapacity:10];
    
    [RSCNewsManager sharedInstance].delegate = self;
    
    _screenWidth = ([[UIScreen mainScreen] bounds].size.width);
    CGFloat navHeight = 64;
    
    self.tagBarMgr = [[RSCNewsTagBarManager alloc] init];
    self.tagBarMgr.delegate = self;
    CGRect tabBarFrame = self.tagBarMgr.tagBar.frame;
    tabBarFrame.origin.y = navHeight;
    tabBarFrame.size.width = _screenWidth;
    self.tagBarMgr.tagBar.frame = tabBarFrame;
    [self.view addSubview:self.tagBarMgr.tagBar];
    

    _tagMgr = [RSCNewsManager sharedInstance];
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
    if (offsetX < 0) {
        offsetX = 0;
    } else  {
        CGFloat rightEdge = (_screenWidth * (_tagItems.count - 1));
        if (offsetX > rightEdge) {
            offsetX = rightEdge;
        }
    }
    CGFloat offset = offsetX / _screenWidth;
    //        NSLog(@"offset : %f", offset);
    [_tagBarMgr onScrollContentPages:offset];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self chechAndResetScrollViewContent:scrollView];
    }
//    NSLog(@"DidEndDragging: %@", decelerate ? @"decelerating" : @"not decelerating");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self chechAndResetScrollViewContent:scrollView];
//    NSLog(@"DidEndDecelerating~~~~");
}

- (void)chechAndResetScrollViewContent:(UIScrollView *)scrollView {
    if (_indexDelta != 0) {
        if (_indexDelta == 1) {
            _middleOffsetX = _middleIndex ? _screenWidth * 2 : _screenWidth;
        } else {
            _middleOffsetX = 0;
        }
        _middleIndex += _indexDelta;
        _indexDelta = 0;
        [self resetPages];
    }
}

#pragma mark - Content Pages
- (void)setupContentPagesWithTags:(NSArray *)tags {
    NSAssert(tags, @"[setupContentPagesWithTags] must has tags");
    // reset news tag items
    NSMutableArray *newTagItems = [NSMutableArray arrayWithCapacity:10];
    for (RSCTag *tag in tags) {
        RSCNewsTagItem *tagItem = nil;
        for (RSCNewsTagItem *item in _tagItems) {
            if ([item.tag isEqual:tag]) {
                tagItem = item;
                break;
            }
        }
        if (!tagItem) {
            tagItem = [[RSCNewsTagItem alloc] init];
            tagItem.tag = tag;
        }
        [newTagItems addObject:tagItem];
    }
    self.tagItems = newTagItems;
    
    if (_middleController) {
        RSCNewsTagItem *middleTag = _middleController.tagItem;
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


- (RSCNewsTagController *)getControllerByTagItem:(RSCNewsTagItem *)tagItem inControllers:(NSArray *)controllers {
    RSCNewsTagController *result = nil;
    for (RSCNewsTagController *controller in controllers) {
        if ([controller.tagItem.tag isEqual:tagItem.tag]) {
            result = controller;
            break;
        }
    }
    return result;
}

- (RSCNewsTagController *)createNewsTagControllerWithTagItem:(RSCNewsTagItem *)tagItem {
    RSCNewsTagController *controller = [[RSCNewsTagController alloc] initWithTag:tagItem.tag];
    controller.tagItem = tagItem;
    return controller;
}

- (void)addControllerToScrollView:(RSCNewsTagController *)controller withOffsetX:(CGFloat)offsetX {
    CGRect frame = controller.view.frame;
    frame.origin.x = offsetX;
    frame.size.width = _screenWidth;
    frame.size.height = _scrollView.bounds.size.height;
    controller.view.frame = frame;

    [_scrollView addSubview:controller.view];
    [self addChildViewController:controller];
}

- (void)removeController:(RSCNewsTagController *)controller {
    RSCNewsTagItem *tagItem = controller.tagItem;
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
    if (contentSize.width != contentWidth) {
        contentSize.width = contentWidth;
        _scrollView.contentSize = contentSize;
    }
}

- (void)setScrollViewContentOffset:(CGFloat)contentOffsetX {
    CGPoint contentOffset = _scrollView.contentOffset;
    if (contentOffset.x != contentOffsetX) {
        contentOffset.x = contentOffsetX;
        _scrollView.contentOffset = contentOffset;
    }
}

- (void)resetScrollViewContent:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    NSInteger tagCount = _tagItems.count;
    
    CGFloat maxOffsetX = (tagCount - 1) * _screenWidth;
    if (contentOffsetX < 0 || contentOffsetX > maxOffsetX) {
        return;
    }
    
    BOOL isDragging = NO;
    UIGestureRecognizerState state = scrollView.panGestureRecognizer.state;
    if (state == UIGestureRecognizerStateBegan ||
        state == UIGestureRecognizerStateChanged) {
        _indexDelta = 0;
//        NSLog(@"pan state: %d", state);
        isDragging = YES;
    }
    
    if (_indexDelta != 0) {
        return;
    }
    
    CGFloat halfScreenWidth = _screenWidth / 2.;
    
    if (contentOffsetX > _middleOffsetX + halfScreenWidth && _middleIndex + 1 < tagCount) { // scroll to right page
        if (scrollView.isDecelerating && !isDragging) {
            _indexDelta = 1;
//            NSLog(@"scroll to right");
            return;
        }
        
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
            RSCNewsTagItem *tagItem = _tagItems[_middleIndex + 1];
            RSCNewsTagController *controller = [self createNewsTagControllerWithTagItem:tagItem];
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
        
        if (scrollView.isDecelerating && !isDragging) {
            _indexDelta = -1;
//            NSLog(@"scroll to left");
            return;
        }
        
        _middleIndex--;
        
        CGFloat offsetX = 0.;
        CGFloat totalOffset = 0;
        RSCNewsTagController *tmpLeftController = nil;
        if (_middleIndex > 0) {
            RSCNewsTagItem *tagItem = _tagItems[_middleIndex - 1];
            RSCNewsTagController *controller = [self createNewsTagControllerWithTagItem:tagItem];
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
        RSCNewsTagItem *leftTagItem = _tagItems[_middleIndex - 1];
        RSCNewsTagController *controller = [self getControllerByTagItem:leftTagItem inControllers:currentControllers];
        if (!controller || controller != _leftController) {
            if (controller) {
                [currentControllers removeObject:controller];
                CGRect frame = controller.view.frame;
                if (frame.origin.x != contentOffsetX) {
                    frame.origin.x = contentOffsetX;
                    controller.view.frame = frame;
                }
            } else {
                controller = [self createNewsTagControllerWithTagItem:leftTagItem];
                [self addControllerToScrollView:controller withOffsetX:0];
            }
            
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
        RSCNewsTagItem *middleTagItem = _tagItems[_middleIndex];
        RSCNewsTagController *controller = [self getControllerByTagItem:middleTagItem inControllers:currentControllers];
        if (!controller || controller != _middleController) {
            if (controller) {
                [currentControllers removeObject:controller];
                CGRect frame = controller.view.frame;
                if (frame.origin.x != contentOffsetX) {
                    frame.origin.x = contentOffsetX;
                    controller.view.frame = frame;
                }
            } else {
                controller = [self createNewsTagControllerWithTagItem:middleTagItem];
                [self addControllerToScrollView:controller withOffsetX:contentOffsetX];
            }
            
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
        RSCNewsTagItem *rightTagItem = _tagItems[_middleIndex + 1];
        RSCNewsTagController *controller = [self getControllerByTagItem:rightTagItem inControllers:currentControllers];
        if (!controller || controller != _rightController) {
            if (controller) {
                [currentControllers removeObject:controller];
                CGRect frame = controller.view.frame;
                if (frame.origin.x != contentOffsetX) {
                    frame.origin.x = contentOffsetX;
                    controller.view.frame = frame;
                }
            } else {
                controller = [self createNewsTagControllerWithTagItem:rightTagItem];
                [self addControllerToScrollView:controller withOffsetX:contentOffsetX];
            }
            
            self.rightController = controller;
        } else {
            [currentControllers removeObject:controller];
        }
        contentOffsetX += _screenWidth;
    } else {
        self.rightController = nil;
    }
    
    for (RSCNewsTagController *controller in currentControllers) {
        [self removeController:controller];
    }
    
    [self setScrollViewContentSize:contentOffsetX];
    [self setScrollViewContentOffset:_middleOffsetX];
}

@end
