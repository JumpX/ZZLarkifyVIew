//
//  ZZLarkifyPool.m
//  ZZLarkifyView
//
//  Created by ZZ.Jungle on 2019/1/10.
//  Copyright (c) 2019 ZZ.Jungle. All rights reserved.
//

#import "ZZLarkifyPool.h"

@interface ZZLarkifyPool () {
    // 实际Pool，用于取出元素
    NSMutableDictionary <NSString *, NSMutableSet<ZZElementView *> *> *_realDict;
    // 临时Pool，用于新增元素
    NSMutableDictionary <NSString *, NSMutableSet<ZZElementView *> *> * _tempDict;
}

@end

@implementation ZZLarkifyPool

- (instancetype)init
{
    if (self = [super init]) {
        _realDict = [NSMutableDictionary new];
        _tempDict = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - 取出元素

- (ZZElementView *)dequeueElementForReuseID:(NSString *)reuseID
{
    return [self dequeueElementForReuseID:reuseID ID:nil];
}

- (ZZElementView *)dequeueElementForReuseID:(NSString *)reuseID ID:(NSString *)ID
{
    if (!ZZValidString(reuseID)) return nil;
    
    __block ZZElementView *element = nil;
    NSMutableSet *reuseSet = [_realDict objectForKey:reuseID];
    if (reuseSet && reuseSet.count > 0) {
        if (!ZZValidString(ID)) {
            element = [reuseSet anyObject];
        } else {
            [reuseSet enumerateObjectsUsingBlock:^(ZZElementView * _Nonnull view, BOOL * _Nonnull stop) {
                if ([view.ID isEqualToString:ID]) {
                    element = view;
                    *stop = YES;
                }
            }];
            if (!element) {
                element = [reuseSet anyObject];
            }
        }
        [reuseSet removeObject:element];
    }
    return element;
}

#pragma mark - 新增元素

- (void)addElement:(ZZElementView *)element forReuseID:(NSString *)reuseID
{
    if (!element || !ZZValidString(reuseID)) return;
    
    NSMutableSet *reuseSet = [_tempDict objectForKey:reuseID];
    if (!reuseSet) {
        reuseSet = [NSMutableSet set];
        [_tempDict setObject:reuseSet forKey:reuseID];
    }
    [reuseSet addObject:element];
}

#pragma mark - 隐藏元素

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

#pragma mark - 同步元素池

- (void)synPool
{
    if (_tempDict.count <= 0) return;
    
    [_realDict addEntriesFromDictionary:_tempDict];
    [_tempDict removeAllObjects];
}

- (void)synPool:(void(^)(ZZElementView *element, BOOL shoudFront))callback
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

#pragma mark - 清空元素池

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
