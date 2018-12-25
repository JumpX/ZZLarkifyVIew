//
//  ZZElementViewText.m
//  ZZLarkifyViewDemo
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZElementViewText.h"

@interface ZZElementViewText ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation ZZElementViewText

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)bindElement:(ZZElementModel *)model value:(id)value type:(ZZElementType)type
{
    switch (type) {
        case ZZElementTypeTextTitle:
        {
            UIFont *font = ZZElementFont(model.size, 42, model.ratio, model.bold.boolValue);
            UIColor *textColor = ZZElementTextColor(model.color, @"#000000");
            NSTextAlignment textAlign = ZZElementTextAlign(model.align, NSTextAlignmentLeft);
            BOOL isCenter = ZZElementIsAlignCenter(textAlign);
            NSAttributedString *attributedText = [self zzElementAttributedText:value font:font textColor:textColor isCenter:isCenter];
            CGRect rect = [self zzElementFrameWithAttributedText:attributedText font:font numLine:model.lineNum.integerValue verticalAlignment:ZZTextVerticalAlignmentTop];
            self.textLabel.frame = rect;
            self.textLabel.numberOfLines = model.lineNum.integerValue;
            self.textLabel.attributedText = attributedText;
        }
            break;
        case ZZElementTypeTextSlogan:
        {
            UIFont *font = ZZElementFont(model.size, 42, model.ratio, model.bold.boolValue);
            UIColor *textColor = ZZElementTextColor(model.color, @"#000000");
            NSTextAlignment textAlign = ZZElementTextAlign(model.align, NSTextAlignmentLeft);
            BOOL isCenter = ZZElementIsAlignCenter(textAlign);
            NSAttributedString *attributedText = [self zzElementAttributedText:value font:font textColor:textColor isCenter:isCenter];
            CGRect rect = [self zzElementFrameWithAttributedText:attributedText font:font numLine:model.lineNum.integerValue verticalAlignment:ZZTextVerticalAlignmentTop];
            self.textLabel.frame = rect;
            self.textLabel.numberOfLines = model.lineNum.integerValue;
            self.textLabel.attributedText = attributedText;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UI

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [UILabel new];
    }
    return _textLabel;
}

@end
