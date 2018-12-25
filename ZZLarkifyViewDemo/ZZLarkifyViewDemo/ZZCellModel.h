//
//  ZZCellModel.h
//  ZZLarkifyViewDemo
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZUtils.h"
#import "YYModel.h"

@interface ZZCellModel : NSObject <YYModel>

@property (nonatomic, copy) NSString        *width;     ///< 宽
@property (nonatomic, copy) NSString        *height;    ///< 高
@property (nonatomic, copy) NSString        *bgColor;   ///< 背景色
@property (nonatomic, copy) NSDictionary    *data;      ///< values
@property (nonatomic, copy) NSArray         *elements;  ///< 元素集

- (CGFloat)cellHeight:(NSInteger)index;

@end
