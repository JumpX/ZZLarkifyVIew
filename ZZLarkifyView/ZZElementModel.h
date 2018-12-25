//
//  ZZElementModel.h
//  ZZLarkifyView
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZLarkify.h"

@class ZZElementClassInfo;
@interface ZZElementModel : NSObject

@property (nonatomic, copy) NSString *mainType;     ///< 主类型
@property (nonatomic, copy) NSString *subType;      ///< 子类型
@property (nonatomic, copy) NSString *x;            ///< 左
@property (nonatomic, copy) NSString *y;            ///< 上
@property (nonatomic, copy) NSString *w;            ///< 宽
@property (nonatomic, copy) NSString *h;            ///< 高
@property (nonatomic, copy) NSString *lineNum;      ///< 行高
@property (nonatomic, copy) NSString *align;        ///< 文本居中
@property (nonatomic, copy) NSString *bold;         ///< 字体加粗
@property (nonatomic, copy) NSString *size;         ///< 字体大小
@property (nonatomic, copy) NSString *color;        ///< 字体颜色
@property (nonatomic, copy) NSString *key;          ///< key


#pragma mark - 自定义字段

@property (nonatomic, copy, readonly)   NSString *ID;        ///< 唯一ID
@property (nonatomic, copy, readonly)   NSString *reuseID;   ///< 复用ID：mainType+subType
@property (nonatomic, assign, readonly) CGRect   rect;       ///< 元素frame
@property (nonatomic, assign, readonly) CGFloat  ratio;      ///< 元素缩放比例：实际值/下发值
@property (nonatomic, assign, readonly) ZZElementType eType; ///< 元素类型
@property (nonatomic, strong, readonly) ZZElementClassInfo *classInfo; ///< 存放Class和ZZElementType类型

#pragma mark - 自定义方法

- (BOOL)isModelValid:(CGFloat)ratio index:(NSInteger)index;
- (BOOL)isTypesEqual:(NSString *)mainType subType:(NSString *)subType;
- (void)updateClassInfo:(ZZElementClassInfo *)classInfo;

@end

@interface ZZElementClassInfo : NSObject

@property (nonatomic, assign, readonly) Class           elementClass;
@property (nonatomic, assign, readonly) ZZElementType   mainEType;
@property (nonatomic, assign, readonly) ZZElementType   subEType;

/**
 *  扩展新元素
 */
+ (instancetype)classInfoWithMainType:(NSString *)mainType
                              subType:(NSString *)subType;
@end
