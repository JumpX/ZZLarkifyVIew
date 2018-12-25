//
//  ZZTableViewCell.m
//  ZZLarkifyViewDemo
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZLarkifyView.h"
#import "ZZCellModel.h"

@interface ZZTableViewCell () <ZZLarkifyViewDataSource, ZZLarkifyViewDelegate>

@property (nonatomic, strong) ZZLarkifyView     *larkifyView;
@property (nonatomic, strong) ZZCellModel       *cellModel;

@end

@implementation ZZTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.larkifyView = ({
            ZZLarkifyView *larkifyView = [ZZLarkifyView new];
            larkifyView.dataSource = self;
            larkifyView.delegate = self;
            larkifyView;
        });
        [self.contentView addSubview:self.larkifyView];
    }
    return self;
}

- (void)bindData:(ZZCellModel *)cellModel frame:(CGRect)frame
{
    if (!cellModel || ![cellModel isKindOfClass:[ZZCellModel class]]) return;
    
    self.cellModel = cellModel;
    self.backgroundColor = [UIColor colorWithHex:cellModel.bgColor];
    self.larkifyView.frame = frame;
    [self.larkifyView reloadData];
}

- (CGFloat)ratioForElementInLarkifyView:(ZZLarkifyView *)larkifyView
{
    return self.larkifyView.width/self.cellModel.width.floatValue;
}

- (ZZElementModel *)larkifyView:(ZZLarkifyView *)larkifyView modelForElementAtIndex:(NSUInteger)index
{
    return self.cellModel.elements[index];
}

- (id)larkifyView:(ZZLarkifyView *)larkifyView valueForElementAtIndex:(NSUInteger)index
{
    ZZElementModel *model = [larkifyView modelForElementAtIndex:index];
    return self.cellModel.data[model.key];
}

- (NSUInteger)numberOfElementsInLarkifyView:(ZZLarkifyView *)larkifyView
{
    return self.cellModel.elements.count;
}

- (void)didClickLarkifyView:(ZZLarkifyView *)larkifyView
{
    NSLog(@">>>> click larkifyView");
}

- (BOOL)larkifyView:(ZZLarkifyView *)larkifyView canClickElementAtIndex:(NSUInteger)index
{
    ZZElementModel *model = [larkifyView modelForElementAtIndex:index];
    if (model.eType == ZZElementTypeButtonNormal) {
        return YES;
    }
    return NO;
}

- (void)larkifyView:(ZZLarkifyView *)larkifyView didClickElementAtIndex:(NSUInteger)index
{
    ZZElementModel *model = [larkifyView modelForElementAtIndex:index];
    if (model.eType == ZZElementTypeButtonNormal) {
        NSLog(@">>>> click elementView");
    }
}

@end
