//
//  UIColor+ZZ.h
//  ZZLarkifyViewDemo
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZZ)

+ (UIColor *)randomColor;

+ (UIColor *)colorWithHex:(NSString *)hex;
+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(NSString *)hex defaultHex:(NSString *)defaultHex;
+ (UIColor *)colorWithHex:(NSString *)hex defaultHex:(NSString *)defaultHex alpha:(CGFloat)alpha;

@end
