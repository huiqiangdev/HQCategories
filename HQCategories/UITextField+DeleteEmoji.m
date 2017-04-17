//
//  UITextField+DeleteEmoji.m
//  Test
//
//  Created by HQ on 2016/10/28.
//  Copyright © 2016年 HQ. All rights reserved.
//

#import "UITextField+DeleteEmoji.h"
#import <objc/runtime.h>


@implementation UITextField (DeleteEmoji)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(init);
        SEL swizzledSelector = @selector(hq_init);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        // replace the method when the UITextField was create from Nib
        SEL originalSelectorNib = @selector(initWithCoder:);
        SEL swizzledSelectorNib = @selector(hq_initWithCoder:);
        
        Method originalMethodNib = class_getInstanceMethod(class, originalSelectorNib);
        Method swizzledMethodNib = class_getInstanceMethod(class, swizzledSelectorNib);
        
        BOOL successNib = class_addMethod(class, originalSelectorNib, method_getImplementation(swizzledMethodNib), method_getTypeEncoding(swizzledMethodNib));
        if (successNib) {
            class_replaceMethod(class, swizzledSelectorNib, method_getImplementation(originalMethodNib), method_getTypeEncoding(originalMethodNib));
        } else {
            method_exchangeImplementations(originalMethodNib, swizzledMethodNib);
        }
    });

}
- (instancetype)hq_init {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(txtChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    return [self hq_init];
}
- (instancetype)hq_initWithCoder:(NSCoder *)aDecoder {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(txtChange:) name:UITextFieldTextDidChangeNotification object:nil];
   
    return [self hq_initWithCoder:aDecoder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)txtChange:(NSNotification *)noti {
    if (self.text.length>0) {
        [self.text enumerateSubstringsInRange:NSMakeRange(0, [self.text length])
                                      options:NSStringEnumerationByComposedCharacterSequences
                                   usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                       
                                       [self textField:self shouldChangeCharactersInRange:substringRange replacementString:substring];
                                   }];
    }
    
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string length] > 0) {
        if([string rangeOfCharacterFromSet:[self emojiSet]].location != NSNotFound) {
            self.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            
            return NO;
            
        }
    }
    return YES;
}
- (NSCharacterSet *)emojiSet {
    NSMutableCharacterSet  *EmojiCharacterSet = [[NSMutableCharacterSet alloc] init];
    
    // U+FE00-FE0F (Variation Selectors)
    [EmojiCharacterSet addCharactersInRange:NSMakeRange(0xFE00, 0xFE0F - 0xFE00 + 1)];
    
    // U+2100-27BF
    [EmojiCharacterSet addCharactersInRange:NSMakeRange(0x2100, 0x27BF - 0x2100 + 1)];
    
    // U+1D000-1F9FF
    [EmojiCharacterSet addCharactersInRange:NSMakeRange(0x1D000, 0x1F9FF - 0x1D000 + 1)];
    return EmojiCharacterSet;
}

@end
