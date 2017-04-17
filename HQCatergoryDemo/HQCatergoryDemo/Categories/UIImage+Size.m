//
//  UIImage+Size.m
//  Club
//
//  Created by ISU1 on 16/3/8.
//  Copyright © 2016年 HQ. All rights reserved.
//

#import "UIImage+Size.h"

@implementation UIImage (Size)
- (UIImage *)imageWithScale:(CGFloat)width {
    CGFloat height = width * self.size.height/ self.size.width;
    CGSize currentSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(currentSize);
    [self drawInRect:CGRectMake(0, 0, currentSize.width, currentSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
