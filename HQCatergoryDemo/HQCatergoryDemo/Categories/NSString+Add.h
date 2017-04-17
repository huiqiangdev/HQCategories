//
//  NSString+Add.h
//  NewTest
//
//  Created by 余汪送 on 16/7/20.
//  Copyright © 2016年 余汪送. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark -- 编码 --

@interface NSString (Add)

- (NSString *)md5String;

- (NSString *)base64EncodedString;

- (NSString *)stringByURLEncode;

- (NSString *)stringByURLDecode;

+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString;
// 过滤特殊字符
- (NSString *)upLoadString;
//手机号正则表达式验证。
- (BOOL)validateMobile;

//判断是否是数字
- (BOOL)validateNumber;

//正则匹配用户密码 6 - 16 位数字和字母组合
- (BOOL)validatePassword;

//正则匹配是否是中文
- (BOOL)validateChinese;

//邮箱
- (BOOL)validateEmail;

//昵称
- (BOOL)validateNickname;

//验证16或者19未银行卡
- (BOOL)validateBankNo;

//验证是否是URL
- (BOOL)validateUrl;

//是否包含emo
- (NSRange)rangeOfEmoji;



- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size;

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;



- (BOOL)isExist;

- (BOOL)containsString:(NSString *)string;

- (NSString *)stringByTrim;

//获取app的版本
+ (NSString *)appVersion;

//sting格式:yyyy-MM-dd HH:mm:ss => MM-dd
- (NSString *)formatMMddDateString;
- (NSString *)formatYYYYMMDDDateString;

//sting格式:yyyy-MM-dd HH:mm:ss => HH:mm
- (NSString *)formatHHmmDateString;

//sting格式:yyyy-MM-dd HH:mm:ss => MM
- (NSString *)formatMMDateString;

//将1234567891212121212 银行卡号只显示取最后4位 => **** **** **** 1212
- (NSString *)formatBankNo;

//格式化润恒卡
- (NSString *)formatRHCardNo;

//格式化身份证号
- (NSString *)formatIDCard;

//获取银行卡后四位
- (NSString *)getBankNoLastFour;

//将15755382565 => 157****2565
- (NSString *)formatPhone;

- (NSMutableAttributedString *)setStringColor:(UIColor *)color withString:(NSString *)subString;

- (NSAttributedString *)attributedString;



@end










