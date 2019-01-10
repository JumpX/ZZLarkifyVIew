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
        self.contentView.backgroundColor = [UIColor colorWithHex:@"#0000ff"];
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

#pragma mark - ZZCellProtocol

- (void)bindCell:(ZZCellModel *)cellModel
{
    if (!cellModel || ![cellModel isKindOfClass:[ZZCellModel class]]) return;
    self.cellModel = cellModel;
    self.larkifyView.backgroundColor = [UIColor colorWithHex:cellModel.bgColor];
    self.larkifyView.frame = [cellModel larkifyViewFrame];
}

- (void)willDisplayCell
{
    [self.larkifyView reloadData];
}

#pragma mark - larkifyView
#pragma mark - larkifyViewDataSource

- (CGFloat)ratioForLarkifyView:(ZZLarkifyView *)larkifyView
{
    return [self.cellModel cellRatio];
}

- (NSUInteger)numberOfElementsInLarkifyView:(ZZLarkifyView *)larkifyView
{
    return self.cellModel.elements.count;
}

- (CGRect)larkifyView:(ZZLarkifyView *)larkifyView rectForElementAtIndex:(NSUInteger)index
{
    ZZElementModel *model = self.cellModel.elements[index];
    CGFloat ratio = [self ratioForLarkifyView:larkifyView];
    if (![model isModelValid:ratio index:index]) return CGRectZero;
    return model.rect;
}

- (ZZElementView *)larkifyView:(ZZLarkifyView *)larkifyView elementAtIndex:(NSUInteger)index
{
    ZZElementModel *model = self.cellModel.elements[index];
    NSString *ID = ZZCreateID(index);
    NSString *reuseID = ZZCreateReuseID(model.mainType, model.subType);
    ZZElementView *element = [larkifyView dequeueElementForReuseID:reuseID ID:ID];
    if (!element) {
        element = [[model.classInfo.elementClass alloc] initWithReuseID:reuseID ID:ID];
    }
    return element;
}

- (void)larkifyView:(ZZLarkifyView *)larkifyView willDisplayElement:(ZZElementView *)element index:(NSUInteger)index
{
    ZZElementModel *model = self.cellModel.elements[index];
    [(id<ZZElementProtocol>)element bindElement:model value:self.cellModel.data[model.key] type:model.eType];
}

#pragma mark - larkifyViewDelegate

- (void)didClickLarkifyView:(ZZLarkifyView *)larkifyView
{
    NSLog(@">>>> click larkifyView");
}

- (BOOL)larkifyView:(ZZLarkifyView *)larkifyView canClickElementAtIndex:(NSUInteger)index
{
    ZZElementModel *model = self.cellModel.elements[index];
    if (model.classInfo.subEType == ZZElementTypeButtonNormal) {
        return YES;
    } else {
        return NO;
    }
}

- (void)larkifyView:(ZZLarkifyView *)larkifyView didClickElementAtIndex:(NSUInteger)index
{
    NSLog(@">>>> click element");
}

@end
