//
//  ZZLarkifyPool.h
//  ZZLarkifyView
//
//  Created by ZZ.Jungle on 2019/1/10.
//  Copyright (c) 2019 ZZ.Jungle. All rights reserved.
//

#import "ZZElementView.h"

@interface ZZLarkifyPool : NSObject

// 复用元素
- (ZZElementView *)dequeueElementForReuseID:(NSString *)reuseID;
- (ZZElementView *)dequeueElementForReuseID:(NSString *)reuseID ID:(NSString *)ID;

// 增加元素
- (void)addElement:(ZZElementView *)element forReuseID:(NSString *)reuseID;

// 隐藏所有元素
- (void)hideAllElements;
// 同步所有元素
- (void)synPool;
- (void)synPool:(void(^)(ZZElementView *element, BOOL shoudFront))callback;
// 清除所有元素
- (void)clear;

@end
