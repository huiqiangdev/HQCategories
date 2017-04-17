//
//  NSString+Add.m
//  NewTest
//
//  Created by 余汪送 on 16/7/20.
//  Copyright © 2016年 余汪送. All rights reserved.
//


#import "NSString+Add.h"
#import "NSData+Add.h"
#import <objc/runtime.h>

#pragma mark -- 编码 --

@implementation NSString (Add)

- (NSString *)md5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5String];
}

- (NSString *)base64EncodedString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
}

+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString {
    NSData *data = [NSData dataWithBase64EncodedString:base64EncodedString];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)upLoadString {
    return [self stringByTrimmingCharactersInSet:[self emojiSet]];
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
#pragma mark -- 正则式验证 --

//手机号正则表达式验证。
- (BOOL)validateMobile
{
    NSString *mobile = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    return [regextestmobile evaluateWithObject:self];
    
}

//判断是否是数字
- (BOOL)validateNumber
{
    NSString *mobile = @"^[0-9]*$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    return [regextestmobile evaluateWithObject:self];
}

//正则匹配用户密码 8 - 16 位数字、字母、字符组合（必须由其中两种组成）
- (BOOL)validatePassword
{
    BOOL result = NO;
    if ([self length] >= 6 && [self length] <= 16){
//        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";//数字和字母组合
        NSString *regex = @"(?!^[0-9]+$)(?!^[a-zA-Z]+$)(?!^[`~!@#\\$%\\^&\\*\\(\\)_\\+\\-=\\[\\]{}\\|;:'\"<,>\\.\\?/]+$).{6,16}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:self];
    }
    return result;
    
}

//正则匹配是否是中文
- (BOOL)validateChinese {
    NSString *chinese = @"^[\u4E00-\u9FA5]*$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chinese];
    return [regextestmobile evaluateWithObject:self];
}


//邮箱
- (BOOL)validateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

//是否包含emo
- (NSRange)rangeOfEmoji {
    NSMutableCharacterSet  *emojiCharacterSet = [[NSMutableCharacterSet alloc] init];
    // U+FE00-FE0F (Variation Selectors)
    [emojiCharacterSet addCharactersInRange:NSMakeRange(0xFE00, 0xFE0F - 0xFE00 + 1)];
    // U+2100-27BF
    [emojiCharacterSet addCharactersInRange:NSMakeRange(0x2100, 0x27BF - 0x2100 + 1)];
    // U+1D000-1F9FF
    [emojiCharacterSet addCharactersInRange:NSMakeRange(0x1D000, 0x1F9FF - 0x1D000 + 1)];
    
    return [self rangeOfCharacterFromSet:emojiCharacterSet];
}

//昵称
- (BOOL)validateNickname
{
    //^[\u4e00-\u9fa5_a-zA-Z0-9]{4,10} 判断长度
    NSString *nicknameRegex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:self];
}

//验证16或者19未银行卡
- (BOOL)validateBankNo {
    NSString *bankNoRegex = @"^([0-9]{16}|[0-9]{19})$";
    NSPredicate *bankNoPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNoRegex];
    return [bankNoPredicate evaluateWithObject:self];
}

//验证是否是URL
- (BOOL)validateUrl {
    NSString *urlRegex = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlRegex];
    return [urlPredicate evaluateWithObject:self];
}


#pragma mark -- 获取文本大小 --

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size {
    return [self sizeForFont:font size:size mode:NSLineBreakByWordWrapping];
}

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}



#pragma mark -- 其他相关 --

- (BOOL)isExist {
    if (!self || [self isEqualToString:@"(null)"] || [self isEqualToString:@""] || [self isEqualToString:@"<null>"] || [self isEqualToString:@"null"]) {
        return NO;
    }
    return YES;
}

- (BOOL)containsString:(NSString *)string {
    if (string == nil) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}

- (NSString *)stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

+ (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}




//sting格式:yyyy-MM-dd HH:mm:ss => MM-dd
- (NSString *)formatMMddDateString {
    NSArray *strings = [self componentsSeparatedByString:@" "];
    NSString *yyyyMMddString = strings[0];
    NSArray *strings_new = [yyyyMMddString componentsSeparatedByString:@"-"];
    if (strings_new.count < 3) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@-%@",strings_new[1],strings_new[2]];
}
- (NSString *)formatYYYYMMDDDateString {
    NSArray *strings = [self componentsSeparatedByString:@" "];
    if (strings.count < 2) {
        return nil;
    }
    return strings[0];
}

//sting格式:yyyy-MM-dd HH:mm:ss => HH:mm
- (NSString *)formatHHmmDateString {
    NSArray *strings = [self componentsSeparatedByString:@" "];
    if (strings.count < 2) {
        return nil;
    }
    NSString *HHmmDateString = strings[1];
    strings = [HHmmDateString componentsSeparatedByString:@":"];
    if (strings.count < 2) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@:%@",strings[0],strings[1]];
}

//sting格式:yyyy-MM-dd HH:mm:ss => MM
- (NSString *)formatMMDateString {
    NSArray *strings = [self componentsSeparatedByString:@" "];
    NSString *yyyyMMddString = strings[0];
    NSArray *strings_new = [yyyyMMddString componentsSeparatedByString:@"-"];
    if (strings_new.count < 3) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@",strings_new[1]];
}

//将1234567891212121212 银行卡号只显示取最后4位 => **** **** **** 1212
- (NSString *)formatBankNo {
    if (self.length < 4) {
        return nil;
    }
    NSString *lastString = [self substringWithRange:NSMakeRange(self.length - 4, 4)];
    return [NSString stringWithFormat:@"**** **** **** %@",lastString];
}

//格式化润恒卡
- (NSString *)formatRHCardNo {
    if (self.length < 6) {
        return nil;
    }
    NSString *firstStr = [self substringWithRange:NSMakeRange(0, 3)];
    NSString *lastString = [self substringWithRange:NSMakeRange(self.length - 3, 3)];
    return [NSString stringWithFormat:@"%@****%@",firstStr, lastString];
}

//格式化身份证号
- (NSString *)formatIDCard {
    if (self.length < 10) {
        return nil;
    }
    NSString *firstStr = [self substringWithRange:NSMakeRange(0, 6)];
    NSString *lastString = [self substringWithRange:NSMakeRange(self.length - 4, 4)];
    return [NSString stringWithFormat:@"%@****%@",firstStr, lastString];
}

- (NSString *)getBankNoLastFour {
    if (self.length < 4) {
        return nil;
    }
    NSString *lastString = [self substringWithRange:NSMakeRange(self.length - 4, 4)];
    return lastString;
}

//将15755382565 => 157****2565
- (NSString *)formatPhone {
//    if (![self validateMobile]) {
//        return self;
//    }
    if (self.length < 7) {
        return nil;
    }
    NSString *firstStr = [self substringWithRange:NSMakeRange(0, 3)];
    NSString *lastString = [self substringWithRange:NSMakeRange(self.length - 4, 4)];
    return [NSString stringWithFormat:@"%@****%@",firstStr, lastString];
}

- (NSMutableAttributedString *)setStringColor:(UIColor *)color withString:(NSString *)subString {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:self];
    NSRange range = [self rangeOfString:subString];
    if (range.location != NSNotFound) {
        [attString addAttribute:NSForegroundColorAttributeName value:color range:range];
    }else{
        [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
    }
    return attString;
}

- (NSAttributedString *)attributedString {
    return [[NSAttributedString alloc]initWithString:self];
}

@end










