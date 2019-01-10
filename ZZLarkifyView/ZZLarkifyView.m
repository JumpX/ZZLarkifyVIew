//
//  ZZLarkifyView.m
//  ZZLarkifyView
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZLarkifyView.h"
#import "ZZLarkifyPool.h"

@interface ZZLarkifyView () {
    CGFloat _ratio;                  // 元素显示比例
    NSUInteger _count;               // 元素个数
    ZZLarkifyPool *_pool;            // 元素池（存放所有元素，用以复用）
    NSMutableArray <__kindof ZZElementView *>*_elements; // 元素集
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
        _elements = [NSMutableArray new];
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

#pragma mark - 重加载容器

- (void)reloadData
{
    [_pool hideAllElements]; // 1.先隐藏所有元素
    if ([self isDataValid]) { // 2.数据源可用
        for (NSUInteger index = 0; index < _count; index ++) {
            zz_dispatch_main_async_safe(^{ // 3.遍历并在主线程绘制元素
                ZZElementView *element = [self generateElement:index];
                element.hidden = NO;
                [self->_elements addObject:element];
            });
        }
        [_pool synPool:^(ZZElementView *element, BOOL shoudFront) { // 4.同步到元素池，予以复用
            if (shoudFront) [self bringSubviewToFront:element];
        }];
    }
}

#pragma mark - 重加载元素

- (void)reloadElementAtIndex:(NSUInteger)index
{
    if ([self isDataValid]) {// 1.数据源可用
        [self generateElement:index];// 2.遍历并在主线程绘制元素
        [_pool synPool:^(ZZElementView *element, BOOL shoudFront) { // 3.同步到元素池，予以复用
            if (shoudFront) [self bringSubviewToFront:element];
        }];
    }
}

#pragma mark - 绘制元素

- (ZZElementView *)generateElement:(NSUInteger)index
{
    ZZElementView *element = [self.dataSource larkifyView:self elementAtIndex:index];
    if ([self.dataSource respondsToSelector:@selector(larkifyView:rectForElementAtIndex:)]) {
        element.frame = [self.dataSource larkifyView:self rectForElementAtIndex:index];
    }
    if ([self.dataSource respondsToSelector:@selector(larkifyView:willDisplayElement:index:)]) {
        [self.dataSource larkifyView:self willDisplayElement:element index:index];
    }
    if (!element.superview) [self addSubview:element];
    
    [element clearGestures];
    if (self.delegate && [self.delegate respondsToSelector:@selector(larkifyView:canClickElementAtIndex:)]) {
        BOOL canClick = [self.delegate larkifyView:self canClickElementAtIndex:index];
        if (canClick) {
            [element addTapTarget:self selector:@selector(handleElement:) index:index];
        }
    }

    [_pool addElement:element forReuseID:element.reuseID];
    
    return element;
}

#pragma mark - 获取元素

- (ZZElementView *)elementAtIndex:(NSUInteger)index
{
    return _elements[index];
}

- (ZZElementView *)dequeueElementForReuseID:(NSString *)reuseID
{
    return [_pool dequeueElementForReuseID:reuseID ID:nil];
}

- (ZZElementView *)dequeueElementForReuseID:(NSString *)reuseID ID:(NSString *)ID
{
    return [_pool dequeueElementForReuseID:reuseID ID:ID];
}

#pragma mark - 点击容器

- (void)handleLarkifyView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLarkifyView:)]) {
        [self.delegate didClickLarkifyView:self];
    }
}

#pragma mark - 点击元素

- (void)handleElement:(ZZTapGestureRecognizer *)tapGesture
{
    if (tapGesture.index < 0 || tapGesture.index >= _count) return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(larkifyView:didClickElementAtIndex:)]) {
        [self.delegate larkifyView:self didClickElementAtIndex:tapGesture.index];
    }
}

#pragma mark - Valid (校验)

- (BOOL)isDataValid
{
    return [self isDataSourceValid:self.dataSource]
    && [self isRatioValid:self.dataSource]
    && [self isCountValid:self.dataSource];
}

- (BOOL)isDataSourceValid:(id<ZZLarkifyViewDataSource>)dataSource
{
    return dataSource
    && [dataSource respondsToSelector:@selector(ratioForLarkifyView:)]
    && [dataSource respondsToSelector:@selector(numberOfElementsInLarkifyView:)]
    && [dataSource respondsToSelector:@selector(larkifyView:elementAtIndex:)];
}

- (BOOL)isRatioValid:(id<ZZLarkifyViewDataSource>)dataSource
{
    _ratio = [dataSource ratioForLarkifyView:self];
    return (_ratio > 0.0);
}

- (BOOL)isCountValid:(id<ZZLarkifyViewDataSource>)dataSource
{
    _count = [dataSource numberOfElementsInLarkifyView:self];
    return (_count > 0.0);
}

@end
