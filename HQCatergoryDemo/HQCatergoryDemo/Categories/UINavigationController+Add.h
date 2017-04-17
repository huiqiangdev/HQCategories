//
//  UINavigationController+Add.h
//  MarketApp
//
//  Created by 余汪送 on 16/8/17.
//  Copyright © 2016年 余汪送. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Add)

@end


@protocol NavigationBarGoBackDelegate <NSObject>

@optional

//当点击navBar上的返回按钮时调用
-(BOOL)navigationShouldPopOnBackItemClick;

@end