//
//  ZZElementModel.m
//  ZZLarkifyView
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZElementModel.h"

@implementation ZZElementModel

#pragma mark - Class、ZZElementType

- (void)updateClassInfo:(ZZElementClassInfo *)classInfo
{
    _classInfo = classInfo;
    _eType = classInfo.subEType;
}

#pragma mark - Valid (校验)

- (BOOL)isTypesEqual:(NSString *)mainType subType:(NSString *)subType
{
    if ([self isTypesValid:mainType subType:subType]) {
        if ([_mainType isEqualToString:mainType] &&
            [_subType isEqualToString:subType]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isModelValid:(CGFloat)ratio index:(NSInteger)index
{
    return [self isTypesValid] && [self isRectValid:ratio] && [self isIDsValid:index];
}

- (BOOL)isTypesValid:(NSString *)mainType subType:(NSString *)subType
{
    return ZZValidString(mainType) && ZZValidString(subType);
}

- (BOOL)isTypesValid
{
    return [self isTypesValid:_mainType subType:_subType];
}

- (BOOL)isIDsValid:(NSInteger)index
{
    if (!ZZValidString(_reuseID)) {
        _reuseID = ZZCreateReuseID(_mainType, _subType);
    }
    if (!ZZValidString(_ID)) {
        _ID = [NSString stringWithFormat:@"%zd", index];
    }
    return YES;
}

- (BOOL)isRectValid:(CGFloat)ratio
{
    _ratio = ratio;
    if (_ratio > 0 && _w.floatValue > 0 && _h.floatValue > 0) {
        
        _rect = CGRectMake(outFloat(_x.floatValue, _ratio),
                           outFloat(_y.floatValue, _ratio),
                           outFloat(_w.floatValue, _ratio),
                           outFloat(_h.floatValue, _ratio));
        return YES;
    } else {
        _rect = CGRectZero;
        return NO;
    }
}

@end

#pragma mark - ZZElementClassInfo

@implementation ZZElementClassInfo

+ (instancetype)classInfoWithMainType:(NSString *)mainType subType:(NSString *)subType
{
    if (!ZZValidString(mainType) || !ZZValidString(subType)) return nil;
    
    ZZElementType mainEType = ([mainType integerValue] & ZZElementTypeMask);
    ZZElementType subEType = ZZElementTypeUnknown;
    Class elementClass;
    switch (mainEType) {
        case ZZElementTypeImage:
            elementClass = NSClassFromString(@"ZZElementViewImage");
            subEType = ZZSubEType(subType, subEType, ZZElementTypeImageMask);
            break;
        case ZZElementTypeText:
            elementClass = NSClassFromString(@"ZZElementViewText");
            subEType = ZZSubEType(subType, subEType, ZZElementTypeTextMask);
            break;
        case ZZElementTypePrice:
            elementClass = NSClassFromString(@"ZZElementViewPrice");
            subEType = ZZSubEType(subType, subEType, ZZElementTypePriceMask);
            break;
        case ZZElementTypeButton:
            elementClass = NSClassFromString(@"ZZElementViewButton");
            subEType = ZZSubEType(subType, subEType, ZZElementTypeButtonMask);
            break;
        default:
            break;
    }
    
    if (mainEType == ZZElementTypeUnknown ||
        subEType == ZZElementTypeUnknown) return nil;
    
    ZZElementClassInfo *classInfo = [[ZZElementClassInfo alloc] initWithClass:elementClass mainType:mainEType subType:subEType];
    return classInfo;
}

- (instancetype)initWithClass:(Class)cls mainType:(ZZElementType)mainType subType:(ZZElementType)subType
{
    if (!cls) return nil;
    if (self = [super init]) {
        _elementClass = cls;
        _mainEType = mainType;
        _subEType = subType;
    }
    return self;
}

@end
