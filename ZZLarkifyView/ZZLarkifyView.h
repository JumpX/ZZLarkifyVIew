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
- (CGFloat)ratioForElementInLarkifyView:(ZZLarkifyView *)larkifyView;
- (NSUInteger)numberOfElementsInLarkifyView:(ZZLarkifyView *)larkifyView;
- (ZZElementModel *)larkifyView:(ZZLarkifyView *)larkifyView modelForElementAtIndex:(NSUInteger)index;
- (id)larkifyView:(ZZLarkifyView *)larkifyView valueForElementAtIndex:(NSUInteger)index;

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

- (nullable ZZElementModel *)modelForElementAtIndex:(NSUInteger)index;

- (void)reloadData;
- (void)reloadElement:(NSString *)mainType subType:(NSString *)subType;

@end

NS_ASSUME_NONNULL_END
