//
//  ZZElementViewImage.m
//  ZZLarkifyViewDemo
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZElementViewImage.h"
#import "SDWebImage.h"

@interface ZZElementViewImage ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZZElementViewImage

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)bindElement:(ZZElementModel *)model value:(id)value type:(ZZElementType)type
{
    switch (type) {
        case ZZElementTypeImageNormal:
        {
            self.imageView.frame = self.bounds;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:value]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UI

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
