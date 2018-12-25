//
//  ZZElementViewPrice.m
//  ZZLarkifyViewDemo
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZElementViewPrice.h"

@interface ZZElementViewPrice ()

@property (nonatomic, strong) UILabel          *priceLabel;
@property (nonatomic, strong) UILabel          *midLine; // 划线价

@end

@implementation ZZElementViewPrice

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.priceLabel];
    }
    return self;
}

- (void)bindElement:(ZZElementModel *)model value:(id)value type:(ZZElementType)type
{
    switch (type) {
        case ZZElementTypePriceNormal:
        {
            NSString *price = ZZElementPrice(value);
            UIFont *font = ZZElementFont(model.size, 48, model.ratio, model.bold.boolValue);
            UIColor *textColor = ZZElementTextColor(model.color, @"#F02C2C");
            NSTextAlignment textAlign = ZZElementTextAlign(model.align, NSTextAlignmentLeft);
            BOOL isCenter = ZZElementIsAlignCenter(textAlign);
            NSAttributedString *attributedText = [self zzElementAttributedText:price font:font textColor:textColor isCenter:isCenter];
            CGRect rect = [self zzElementFrameWithAttributedText:attributedText font:font numLine:1 verticalAlignment:ZZTextVerticalAlignmentCenter];
            self.priceLabel.frame = rect;
            self.priceLabel.attributedText = attributedText;
        }
            break;
        case ZZElementTypePriceLine:
        {
            NSString *price = ZZElementPrice(value);
            UIFont *font = ZZElementFont(model.size, 36, model.ratio, model.bold.boolValue);
            UIColor *textColor = ZZElementTextColor(model.color, @"#999999");
            NSTextAlignment textAlign = ZZElementTextAlign(model.align, NSTextAlignmentLeft);
            BOOL isCenter = ZZElementIsAlignCenter(textAlign);
            NSAttributedString *attributedText = [self zzElementAttributedText:price font:font textColor:textColor isCenter:isCenter];
            CGRect rect = [self zzElementFrameWithAttributedText:attributedText font:font numLine:1 verticalAlignment:ZZTextVerticalAlignmentCenter];
            self.priceLabel.frame = rect;
            self.priceLabel.attributedText = attributedText;
            CGSize realSize = [self zzElementSizeWithAttributedText:attributedText font:font numLine:1];
            self.midLine.frame = CGRectMake(isCenter?MAX((self.width-realSize.width)/2.0, 0):0, rect.size.height/2.0-0.5, MIN(self.width, realSize.width), 1.0);
            self.midLine.backgroundColor = textColor;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UI

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.numberOfLines = 1;
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _priceLabel;
}

- (UILabel *)midLine
{
    if (!_midLine) {
        _midLine = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_midLine];
    }
    return _midLine;
}

@end
