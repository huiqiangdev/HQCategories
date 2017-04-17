//
//  UIViewController+popBack.h
//  RHC_Seller
//
//  Created by 惠强 on 2017/4/10.
//  Copyright © 2017年 惠强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PopBlock)(UIBarButtonItem *backItem);


@interface UIViewController (popBack)

@property(nonatomic,copy)PopBlock popBlock;
@end
