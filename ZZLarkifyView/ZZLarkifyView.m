//
//  ZZLarkifyView.m
//  ZZLarkifyView
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZLarkifyView.h"

#pragma mark ----------------------- ZZLarkifyPool -----------------------

@interface ZZLarkifyPool : NSObject {
    // 实际Pool，用于取出元素
    NSMutableDictionary<NSString *, NSMutableSet<ZZElementView *> *> * _realDict;
    // 临时Pool，用于新增元素
    NSMutableDictionary<NSString *, NSMutableSet<ZZElementView *> *> * _tempDict;
}

// 复用元素
- (ZZElementView *)dequeueElementViewForReuseID:(NSString *)reuseID;
- (ZZElementView *)dequeueElementViewForReuseID:(NSString *)reuseID ID:(NSString *)ID;

// 增加元素
- (void)addElement:(ZZElementView *)elementView forReuseID:(NSString *)reuseID;

// 隐藏所有元素
- (void)hideAllElements;
// 同步所有元素
- (void)synPool;
- (void)synPool:(void(^)(ZZElementView *elementView, BOOL shoudFront))callback;
// 清除所有元素
- (void)clear;

@end

#pragma mark ----------------------- ZZLarkifyView -----------------------

@interface ZZLarkifyView () {
    CGFloat _ratio;                  // 元素显示比例
    NSUInteger _count;               // 元素个数
    ZZLarkifyPool *_pool;            // 元素池（存放所有元素，用以复用）
}

@end

@implementation ZZLarkifyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        _pool = [ZZLarkifyPool new];
        _count = 0;
        _ratio = 0;
        ZZTapGestureRecognizer *tapGesture = [[ZZTapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLarkifyView) index:-1];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)dealloc
{
    _dataSource = nil;
    _delegate = nil;
}

#pragma mark - Core - 刷新容器

- (void)reloadData
{
    [_pool hideAllElements];// hide所有元素
    
    if (![self isDataValid]) return;
    
    for (NSInteger index = 0; index < _count; index ++) {
        // 遍历元素，主线程绘制
        zz_dispatch_main_async_safe(^{
            [self generateElement:index];
        });
    }
    
    [_pool synPool:^(ZZElementView *elementView, BOOL shoudFront) {
        if (shoudFront) [self bringSubviewToFront:elementView];
    }];
}

- (void)generateElement:(NSInteger)index
{
    // (1).获取配置Model
    ZZElementModel *elementModel = [self.dataSource larkifyView:self modelForElementAtIndex:index];
    
    // (2).配置Model必须可用
    if ([elementModel isModelValid:_ratio index:index]) {
        
        // (3).获取Class和ZZElementTypes
        ZZElementClassInfo *classInfo = [self convertTypes:elementModel];
        
        if (classInfo) {
            
            // (4).获取显示Value
            id elementValue = [self.dataSource larkifyView:self valueForElementAtIndex:index];
            
            // (5).Value必须可用
            if ([self isValueValid:elementValue type:classInfo.subEType]) {
                
                // (6).获取元素View
                ZZElementView *elementView = [self createElement:classInfo.elementClass model:elementModel];
                
                // (7).绘制元素
                [self bindElement:elementView model:elementModel value:elementValue type:classInfo.subEType];
                
                // (8).元素添加Tap
                [self elementAddGesture:elementView index:index];
                
                // (9).元素进复用池
                [_pool addElement:elementView forReuseID:elementView.reuseID];
            }
        }
    }
}

#pragma mark - Core - 刷新元素（同一类型）

- (void)reloadElement:(NSString *)mainType subType:(NSString *)subType
{
    if (![self isTypesValid:mainType subType:subType]) return;
    if (![self isDataValid]) return;
    
    for (NSInteger index = 0; index < _count; index ++) {
        // 匹配元素，主线程刷新
        zz_dispatch_main_async_safe(^{
            [self generateElement:index mainType:mainType subType:subType];
        });
    }
}

- (void)generateElement:(NSInteger)index mainType:(NSString *)mainType subType:(NSString *)subType
{
    // (1).获取配置Model
    ZZElementModel *elementModel = [self.dataSource larkifyView:self modelForElementAtIndex:index];
    
    // (2).配置Model必须可用，以及元素类型一致
    if ([elementModel isModelValid:_ratio index:index] &&
        [elementModel isTypesEqual:mainType subType:subType]) {
        
        // (3).获取Class和ZZElementTypes
        ZZElementClassInfo *classInfo = [self convertTypes:elementModel];
        
        if (classInfo) {
            
            // (4).获取显示Value
            id elementValue = [self.dataSource larkifyView:self valueForElementAtIndex:index];
            
            // (5).Value必须可用
            if ([self isValueValid:elementValue type:classInfo.subEType]) {
                
                // (6).获取元素View
                ZZElementView *elementView = [self createElement:classInfo.elementClass model:elementModel];
                
                // (7).绘制元素
                [self bindElement:elementView model:elementModel value:elementValue type:classInfo.subEType];
                
                // (8).元素添加Tap
                [self elementAddGesture:elementView index:index];
                
                // (9).元素进复用池
                [_pool addElement:elementView forReuseID:elementView.reuseID];
                
                // (10).同步复用池，以及角标等元素bringFront
                [_pool synPool:^(ZZElementView *elementView, BOOL shoudFront) {
                    if (shoudFront) {
                        [self bringSubviewToFront:elementView];
                    }
                }];
            } else {
                // (5).Value不可用则隐藏
                ZZElementView *elementView = [self createElement:classInfo.elementClass model:elementModel];
                if (elementView) elementView.hidden = YES;
            }
        }
    }
}

#pragma mark - Core - 获取对应model

- (nullable ZZElementModel *)modelForElementAtIndex:(NSUInteger)index
{
    if (![self isDataValid]) return nil;
    
    return [self.dataSource larkifyView:self modelForElementAtIndex:index];
}

#pragma mark - handle (响应手势)

- (void)handleLarkifyView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLarkifyView:)]) {
        [self.delegate didClickLarkifyView:self];
    }
}

- (void)handleElementView:(ZZTapGestureRecognizer *)tapGesture
{
    if (tapGesture.index < 0 || tapGesture.index >= _count) return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(larkifyView:didClickElementAtIndex:)]) {
        [self.delegate larkifyView:self didClickElementAtIndex:tapGesture.index];
    }
}

#pragma - 元素 <View、Class、ZZElementTypes、AddGesture、bindElement>

// 元素View
- (ZZElementView *)createElement:(Class)elementClass model:(ZZElementModel *)elementModel
{
    ZZElementView *elementView = [_pool dequeueElementViewForReuseID:elementModel.reuseID ID:elementModel.ID];
    
    // 元素Class类型校验，不匹配则重新生成
    if (elementView && ![elementView isMemberOfClass:[elementClass class]]) {
        if (elementView.superview) {
            [elementView removeFromSuperview];
        }
        elementView = nil;
    }
    
    if (!elementView) {
        elementView = [elementClass new];
        [self addSubview:elementView];
    } else {
        elementView.hidden = NO;
    }
    
    elementView.ID = elementModel.ID;
    elementView.reuseID = elementModel.reuseID;
    elementView.frame = elementModel.rect;
    
    return elementView;
}

// 元素Class和ZZElementTypes
- (ZZElementClassInfo *)convertTypes:(ZZElementModel *)elementModel
{
    NSString *mainType = elementModel.mainType;
    NSString *subType = elementModel.subType;
    ZZElementClassInfo *classInfo = [ZZElementClassInfo classInfoWithMainType:mainType subType:subType];
    [elementModel updateClassInfo:classInfo];
    
    return classInfo;
}

// 元素添加Tap
- (void)elementAddGesture:(ZZElementView *)elementView index:(NSInteger)index
{
    [elementView clearGestures];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(larkifyView:canClickElementAtIndex:)]) {
        BOOL canClick = [self.delegate larkifyView:self canClickElementAtIndex:index];
        if (canClick) {
            [(ZZElementView *)elementView addTapTarget:self selector:@selector(handleElementView:) index:index];
        }
    }
}

// 绘制元素
- (void)bindElement:(ZZElementView *)elementView model:(ZZElementModel *)model value:(id)value type:(ZZElementType)subEType
{
    if ([elementView respondsToSelector:@selector(bindElement:value:type:)]) {
        [(id<ZZElementDataSource>)elementView bindElement:model value:value type:subEType];
    }
}

#pragma mark - Valid (校验)

- (BOOL)isDataValid
{
    return [self isDataSourceValid:self.dataSource]
    && [self isRatioValid:self.dataSource]
    && [self isCountValid:self.dataSource];
}

- (BOOL)isTypesValid:(NSString *)mainType subType:(NSString *)subType
{
    return ValidString(mainType) && ValidString(subType);
}

- (BOOL)isValueValid:(id)elementValue type:(ZZElementType)subEType
{
    return ValidSet(elementValue);
}

- (BOOL)isDataSourceValid:(id<ZZLarkifyViewDataSource>)dataSource
{
    return dataSource
    && [dataSource respondsToSelector:@selector(ratioForElementInLarkifyView:)]
    && [dataSource respondsToSelector:@selector(numberOfElementsInLarkifyView:)]
    && [dataSource respondsToSelector:@selector(larkifyView:modelForElementAtIndex:)]
    && [dataSource respondsToSelector:@selector(larkifyView:valueForElementAtIndex:)];
}

- (BOOL)isRatioValid:(id<ZZLarkifyViewDataSource>)dataSource
{
    _ratio = [dataSource ratioForElementInLarkifyView:self];
    return (_ratio > 0.0);
}

- (BOOL)isCountValid:(id<ZZLarkifyViewDataSource>)dataSource
{
    _count = [dataSource numberOfElementsInLarkifyView:self];
    return (_count > 0.0);
}

@end

#pragma mark ----------------------- ZZLarkifyPool -----------------------

@implementation ZZLarkifyPool

- (instancetype)init
{
    if (self = [super init]) {
        _realDict = [NSMutableDictionary new];
        _tempDict = [NSMutableDictionary new];
    }
    return self;
}

- (ZZElementView *)dequeueElementViewForReuseID:(NSString *)reuseID
{
    return [self dequeueElementViewForReuseID:reuseID ID:nil];
}

- (ZZElementView *)dequeueElementViewForReuseID:(NSString *)reuseID ID:(NSString *)ID
{
    if (!reuseID || reuseID.length == 0) return nil;
    
    __block ZZElementView *elementView = nil;
    NSMutableSet *reuseSet = [_realDict objectForKey:reuseID];
    if (reuseSet && reuseSet.count > 0) {
        if (!ID || ID.length == 0) {
            elementView = [reuseSet anyObject];
        } else {
            [reuseSet enumerateObjectsUsingBlock:^(ZZElementView * _Nonnull view, BOOL * _Nonnull stop) {
                if ([view.ID isEqualToString:ID]) {
                    elementView = view;
                    *stop = YES;
                }
            }];
            if (!elementView) {
                elementView = [reuseSet anyObject];
            }
        }
        [reuseSet removeObject:elementView];
    }
    return elementView;
}

- (void)addElement:(ZZElementView *)elementView forReuseID:(NSString *)reuseID
{
    if (!elementView || !reuseID || reuseID.length == 0) return;
    
    NSMutableSet *reuseSet = [_tempDict objectForKey:reuseID];
    if (!reuseSet) {
        reuseSet = [NSMutableSet set];
        [_tempDict setObject:reuseSet forKey:reuseID];
    }
    [reuseSet addObject:elementView];
}

- (void)hideAllElements
{
    [_realDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableSet<ZZElementView *> * _Nonnull elements, BOOL * _Nonnull stop) {
        [elements enumerateObjectsUsingBlock:^(ZZElementView * _Nonnull element, BOOL * _Nonnull stop) {
            zz_dispatch_main_async_safe(^{
                element.hidden = YES;
            });
        }];
    }];
}

- (void)synPool
{
    if (_tempDict.count <= 0) return;
    
    [_realDict addEntriesFromDictionary:_tempDict];
    [_tempDict removeAllObjects];
}

- (void)synPool:(void(^)(ZZElementView *elementView, BOOL shoudFront))callback
{
    [_tempDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableSet<ZZElementView *> * _Nonnull elements, BOOL * _Nonnull stop) {
        [elements enumerateObjectsUsingBlock:^(ZZElementView * _Nonnull element, BOOL * _Nonnull stop) {
            if (callback) {
                callback(element, [element shouldFront]);
            }
        }];
    }];
    [self synPool];
}

- (void)clear
{
    if (_realDict.count <= 0) return;
    
    for (NSMutableSet<ZZElementView *> *elements in _realDict.allValues) {
        [elements enumerateObjectsUsingBlock:^(ZZElementView * _Nonnull element, BOOL * _Nonnull stop) {
            if (element.superview) {
                zz_dispatch_main_async_safe(^{
                    [element removeFromSuperview];
                });
            }
        }];
    }
    [_realDict removeAllObjects];
}

@end

