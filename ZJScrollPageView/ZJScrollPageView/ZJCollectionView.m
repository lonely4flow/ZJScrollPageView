//
//  ZJScrollView.m
//  ZJScrollPageView
//
//  Created by ZeroJ on 16/10/24.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJCollectionView.h"


@interface ZJCollectionView ()
@property (copy, nonatomic) ZJScrollViewShouldBeginPanGestureHandler gestureBeginHandler;
@end
@implementation ZJCollectionView


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (_gestureBeginHandler && gestureRecognizer == self.panGestureRecognizer) {
        return _gestureBeginHandler(self, (UIPanGestureRecognizer *)gestureRecognizer);
    }
    else {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
}

- (void)setupScrollViewShouldBeginPanGestureHandler:(ZJScrollViewShouldBeginPanGestureHandler)gestureBeginHandler {
    _gestureBeginHandler = [gestureBeginHandler copy];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        // 适配FDFullscreenPopGesture框架
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }else{
            // 适配系统自带返回框架
            UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
            UINavigationController *nav = nil;
            if([rootVC isKindOfClass:[UITabBarController class]]){
                UITabBarController *tabVC = (UITabBarController *)rootVC;
                UIViewController *selectVC = tabVC.selectedViewController;
                if([selectVC isKindOfClass:[UINavigationController class]]){
                    nav = (UINavigationController *)selectVC;
                }
            }else if ([rootVC isKindOfClass:[UINavigationController class]]){
                nav = (UINavigationController *)rootVC;
            }
            NSArray *gestureArr = nav.view.gestureRecognizers;
            for (UIGestureRecognizer *gestureRecognizer in gestureArr) {
                if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                    [self.panGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
                }
                
            }
        }
    }
    return NO;
}

@end
