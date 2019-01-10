//
//  ZZCellModel.m
//  ZZLarkifyViewDemo
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZCellModel.h"

@implementation ZZCellModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    [self.elements enumerateObjectsUsingBlock:^(ZZElementModel *_Nonnull elementModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [self convertTypes:elementModel];
    }];
    return YES;
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"elements": @"ZZElementModel"};
}

- (void)convertTypes:(ZZElementModel *)elementModel
{
    NSString *mainType = elementModel.mainType;
    NSString *subType = elementModel.subType;
    ZZElementClassInfo *classInfo = [ZZElementClassInfo classInfoWithMainType:mainType subType:subType];
    [elementModel updateClassInfo:classInfo];
}

- (CGFloat)p_width
{
    return (_edgeLeft.floatValue + _width.floatValue + _edgeRight.floatValue);
}

- (CGFloat)p_height
{
    return (_edgeTop.floatValue + _height.floatValue + _edgeBottem.floatValue);
}

- (CGFloat)cellRatio
{
    if ([self p_width] <= 0) return 0;
    return SCREEN_WIDTH/[self p_width];
}

- (CGFloat)cellHeight
{
    if ([self cellRatio] <= 0) return 0;
    return [self p_height]*[self cellRatio];
}

- (CGRect)larkifyViewFrame
{
    CGFloat left = _edgeLeft.floatValue*[self cellRatio];
    CGFloat top = _edgeTop.floatValue*[self cellRatio];
    CGFloat width = _width.floatValue*[self cellRatio];
    CGFloat height = _height.floatValue*[self cellRatio];
    return CGRectMake(left, top, width, height);
}

@end
