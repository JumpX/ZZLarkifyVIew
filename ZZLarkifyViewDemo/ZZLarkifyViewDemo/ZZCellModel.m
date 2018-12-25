//
//  ZZCellModel.m
//  ZZLarkifyViewDemo
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZCellModel.h"

@implementation ZZCellModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"elements": @"ZZElementModel"};
}

- (CGFloat)cellHeight:(NSInteger)index
{
    if (_width.floatValue <= 0 ||
        _height.floatValue <= 0) return 0;
    
    return (_height.floatValue/_width.floatValue)*SCREEN_WIDTH;
}

@end
