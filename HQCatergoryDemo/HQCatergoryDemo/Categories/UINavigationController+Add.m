//
//  UINavigationController+Add.m
//  MarketApp
//
//  Created by 余汪送 on 16/8/17.
//  Copyright © 2016年 余汪送. All rights reserved.
//

#import "UINavigationController+Add.h"

@implementation UINavigationController (Add)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem*)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController *vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackItemClick)]) {
        shouldPop = (BOOL)[vc performSelector:@selector(navigationShouldPopOnBackItemClick)];
    }
    if (shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        for(UIView *subview in [navigationBar subviews]) {
            if(subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    });
    return NO;
}

@end
