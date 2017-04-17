//
//  UIViewController+popBack.m
//  RHC_Seller
//
//  Created by 惠强 on 2017/4/10.
//  Copyright © 2017年 惠强. All rights reserved.
//

#import "UIViewController+popBack.h"
#import <objc/runtime.h>

static char popBlockKey;


@implementation UIViewController (popBack)
-(void)setPopBlock:(PopBlock)popBlock{
    objc_setAssociatedObject(self, &popBlockKey, popBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(PopBlock)popBlock{
    
    PopBlock popBlock = objc_getAssociatedObject(self, &popBlockKey);
    
    return popBlock;
}
@end
