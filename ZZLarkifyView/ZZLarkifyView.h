//
//  ZZLarkifyView.h
//  ZZLarkifyView
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZElementView.h"

NS_ASSUME_NONNULL_BEGIN

@class ZZLarkifyView;

@protocol ZZLarkifyViewDataSource <NSObject>
@required
- (CGFloat)ratioForLarkifyView:(ZZLarkifyView *)larkifyView;
- (NSUInteger)numberOfElementsInLarkifyView:(ZZLarkifyView *)larkifyView;
- (ZZElementView *)larkifyView:(ZZLarkifyView *)larkifyView elementAtIndex:(NSUInteger)index;

@optional
- (CGRect)larkifyView:(ZZLarkifyView *)larkifyView rectForElementAtIndex:(NSUInteger)index;
- (void)larkifyView:(ZZLarkifyView *)larkifyView willDisplayElement:(ZZElementView *)element index:(NSUInteger)index;

@end

@protocol ZZLarkifyViewDelegate <NSObject>
@required
- (void)didClickLarkifyView:(ZZLarkifyView *)larkifyView;

@optional
- (BOOL)larkifyView:(ZZLarkifyView *)larkifyView canClickElementAtIndex:(NSUInteger)index;
- (void)larkifyView:(ZZLarkifyView *)larkifyView didClickElementAtIndex:(NSUInteger)index;

@end

@interface ZZLarkifyView : UIView

@property (nonatomic, weak, nullable) id<ZZLarkifyViewDataSource>  dataSource;
@property (nonatomic, weak, nullable) id<ZZLarkifyViewDelegate>    delegate;

// 复用元素
- (ZZElementView *)dequeueElementForReuseID:(NSString *)reuseID;
- (ZZElementView *)dequeueElementForReuseID:(NSString *)reuseID ID:(NSString *)ID;

// 取元素
- (ZZElementView *)elementAtIndex:(NSUInteger)index;

// 重加载
- (void)reloadData;
- (void)reloadElementAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
