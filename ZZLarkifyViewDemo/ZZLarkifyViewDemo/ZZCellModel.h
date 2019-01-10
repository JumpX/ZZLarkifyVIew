//
//  ZZCellModel.h
//  ZZLarkifyViewDemo
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZUtils.h"
#import "YYModel.h"
#import "ZZElementModel.h"

@interface ZZCellModel : NSObject <YYModel>

@property (nonatomic, copy) NSString        *edgeTop;       ///< 上边距
@property (nonatomic, copy) NSString        *edgeLeft;      ///< 左边距
@property (nonatomic, copy) NSString        *edgeBottem;    ///< 下边距
@property (nonatomic, copy) NSString        *edgeRight;     ///< 右边距

@property (nonatomic, copy) NSString        *width;         ///< 容器宽
@property (nonatomic, copy) NSString        *height;        ///< 容器高

@property (nonatomic, copy) NSString        *bgColor;       ///< 背景色
@property (nonatomic, copy) NSArray <__kindof ZZElementModel*> *elements;  ///< 元素集
@property (nonatomic, copy) NSDictionary    *data;          ///< 元素集 对应展示的values

- (CGFloat)cellRatio;
- (CGFloat)cellHeight;
- (CGRect)larkifyViewFrame;

@end
