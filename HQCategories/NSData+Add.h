//
//  NSData+Add.h
//  NewTest
//
//  Created by 余汪送 on 16/7/20.
//  Copyright © 2016年 余汪送. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Add)

- (NSString *)md5String;

- (NSData *)md5Data;

- (NSString *)base64EncodedString;

+ (NSData *)dataWithBase64EncodedString:(NSString *)base64EncodedString;

@end
