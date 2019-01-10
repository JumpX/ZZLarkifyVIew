//
//  ZZLarkify.h
//  ZZLarkifyView
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#ifndef ZZLarkify_h
#define ZZLarkify_h

#import "ZZUtils.h"

/**
 *  元素类型
 *
 *  分为主类型和各主类型下的子类型，若不能复用或通过可选协议去使用已有类型，则需按此格式新增元素类型：
 *  主类型按：0,1,2,3,4,5,...向后添加
 *  类型遮罩按：0xF,0xFF,0xFFF,0xFFF,...向后添加
 *  子类型按：(若主类型为Image)从0xF+1,0xF+2,...向后添加
 */
typedef NS_OPTIONS(NSUInteger, ZZElementType)
{
    // 主类型 mainEType
    
    ZZElementTypeMask                   =   0xF,            ///< 主类型遮罩
    ZZElementTypeUnknown                =   0,              ///< 未知
    ZZElementTypeImage                  =   1,              ///< 图片
    ZZElementTypeText                   =   2,              ///< 文本
    ZZElementTypePrice                  =   3,              ///< 价格
    ZZElementTypeButton                 =   4,              ///< 按钮
    
    // 子类型 subEType
    
    ZZElementTypeImageMask              =   0xFF,           ///< 图片
    ZZElementTypeImageNormal            =   0xF+1,          ///< 普通图片
    
    ZZElementTypeTextMask               =   0xFFF,          ///< 文本
    ZZElementTypeTextTitle              =   0xFF+1,         ///< 标题
    ZZElementTypeTextSlogan             =   0xFF+2,         ///< 运营语
    
    ZZElementTypePriceMask              =   0xFFFF,         ///< 价格
    ZZElementTypePriceNormal            =   0xFFF+1,        ///< 正常价
    ZZElementTypePriceLine              =   0xFFF+2,        ///< 划线价
    
    ZZElementTypeButtonMask             =   0xFFFFF,        ///< 按钮
    ZZElementTypeButtonNormal           =   0xFFFF+1,       ///< 正常按钮
};

// 附件垂直相对位置
typedef NS_ENUM(NSInteger, ZZAttachementVerticalAlignment) {
    ZZAttachementVerticalAlignmentCenter    = 0,///< 居中
    ZZAttachementVerticalAlignmentTop       = 1,///< 居上
    ZZAttachementVerticalAlignmentBottom    = 2,///< 居底
};

// 文本垂直相对位置
typedef NS_ENUM(NSInteger, ZZTextVerticalAlignment) {
    ZZTextVerticalAlignmentCenter    = 0,///< 居中
    ZZTextVerticalAlignmentTop       = 1,///< 居上
    ZZTextVerticalAlignmentBottom    = 2,///< 居底
};

// 分隔符
static NSString * const ZZDelimiter = @"#*$#";

// 元素ID
static force_inline NSString *ZZCreateID(NSUInteger index)
{
    return [NSString stringWithFormat:@"%zd",index];
}

// 元素复用ID
static force_inline NSString *ZZCreateReuseID(NSString *mainType, NSString *subType)
{
    return [NSString stringWithFormat:@"%@%@%@",mainType,ZZDelimiter,subType];
}

// 指定主类型、子类型
static force_inline NSString *zzReuseIDToElementType(ZZElementType mainEType, ZZElementType subEType)
{
    return [NSString stringWithFormat:@"%@%@%@",
            [NSString stringWithFormat:@"%zd",mainEType],
            ZZDelimiter,
            [NSString stringWithFormat:@"%zd",subEType]];
}

// 子类型
static force_inline ZZElementType ZZSubEType(NSString *subType, ZZElementType subEType, ZZElementType typeMask)
{
    ZZElementType newType = ZZElementTypeUnknown;
    if (subEType == ZZElementTypeUnknown) {
        newType = (([subType integerValue]+(typeMask >> 4)) & typeMask);
    } else {
        newType = ([subType integerValue] & typeMask);
    }
    if ((newType > (typeMask >> 4)) && (newType < typeMask)) return newType;
    return ZZElementTypeUnknown;
}

#pragma mark -------------- 元素public方法 --------------
// 比例值
static force_inline CGFloat outFloat(CGFloat inFloat, CGFloat ratio)
{
    return inFloat*ratio;
}
// 文本行数
static force_inline NSInteger ZZElementNumLine(NSString *numline, NSUInteger maxNum, NSUInteger defaultNum)
{
    NSInteger realNum = MIN([numline integerValue], maxNum);
    if (realNum > 0) return realNum;
    return defaultNum;
}
// 字体大小
static force_inline UIFont *ZZElementFont(NSString *fontsize, CGFloat defaultFont, CGFloat ratio, BOOL isBold)
{
    CGFloat realSize = [fontsize floatValue]*ratio;
    if (realSize > 0.0) {
        if (isBold) {
            return [UIFont boldSystemFontOfSize:realSize];
        } else {
            return [UIFont systemFontOfSize:realSize];
        }
    } else {
        if (isBold) {
            return [UIFont boldSystemFontOfSize:defaultFont*ratio];
        } else {
            return [UIFont systemFontOfSize:defaultFont*ratio];
        }
    }
}
//对齐方式
static force_inline NSTextAlignment ZZElementTextAlign(NSString *textAlign, NSTextAlignment defaultAlign)
{
    if ([textAlign integerValue] == 1) {
        return NSTextAlignmentCenter;
    } else {
        return defaultAlign?:NSTextAlignmentLeft;
    }
}
// 对齐方式
static force_inline BOOL ZZElementIsAlignCenter(NSTextAlignment textAlign)
{
    if (textAlign == NSTextAlignmentCenter) {
        return YES;
    } else {
        return NO;
    }
}
// 字体颜色
static force_inline UIColor *ZZElementTextColor(NSString *textColor, NSString *defaultColor)
{
    return [UIColor colorWithHex:textColor defaultHex:defaultColor];
}
// 背景色
static force_inline UIColor *zzElementBackgdColor(NSString *backgdColor, NSString *defaultColor)
{
    return [UIColor colorWithHex:backgdColor defaultHex:defaultColor];
}
// 价格拼接：￥88.8
static force_inline NSString *ZZElementPrice(NSString *price)
{
    if (ZZValidString(price)) {
        return [NSString stringWithFormat:@"￥%@",price];
    } else {
        return @"";
    }
}

#endif /* ZZLarkify_h */
