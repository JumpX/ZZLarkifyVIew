//
//  ZZElementView.m
//  ZZLarkifyView
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZElementView.h"
#import <objc/runtime.h>

static const int reuseIDKey;
static const int IDKey;

@implementation ZZElementView

// 绘制元素（子类需重写）
- (void)bindElement:(ZZElementModel *)model value:(id)value type:(ZZElementType)type
{
    
}

// 需要 -bringSubviewToFront:
- (BOOL)shouldFront
{
    return NO;
}

#pragma mark - tapGesture

- (void)clearGestures
{
    if (self.gestureRecognizers && self.gestureRecognizers.count > 0) {
        self.gestureRecognizers = nil;
    }
}

- (void)addTapTarget:(id)target selector:(SEL)selecotr index:(NSUInteger)index
{
    self.userInteractionEnabled = YES;
    ZZTapGestureRecognizer *tapGesture = [[ZZTapGestureRecognizer alloc] initWithTarget:target action:selecotr index:index];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark -------------- 元素public方法 --------------

#pragma mark - NSTextAttachment

- (NSTextAttachment *)zzElementAttachment:(UIImage *)image font:(UIFont *)font height:(CGFloat)height
{
    return [self zzElementAttachment:image font:font height:height alignment:ZZAttachementVerticalAlignmentCenter];
}

- (NSTextAttachment *)zzElementAttachment:(UIImage *)image font:(UIFont *)font height:(CGFloat)height alignment:(ZZAttachementVerticalAlignment)alignment
{
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    CGFloat imgH = height;
    CGFloat imgW = (image.size.width / image.size.height) * imgH;
    CGFloat top = 0.0;
    //微调
    if (imgH < font.ascender) {
        switch (alignment) {
            case ZZAttachementVerticalAlignmentCenter:
                top = (imgH-font.ascender)/6.0;
                break;
            case ZZAttachementVerticalAlignmentTop:
                top = (imgH-font.ascender)/2.5;
                break;
            case ZZAttachementVerticalAlignmentBottom:
                break;
                
            default:
                break;
        }
    } else {
        top = (imgH-font.ascender)/1.8;
        if (top <= 0.5) {
            top = 0.0;
        }
    }
    attachment.bounds = CGRectMake(0, -top , imgW, imgH);
    return attachment;
}

#pragma mark - CGSize、CGRect

- (CGSize)zzElementSizeWithAttributedText:(NSAttributedString *)text font:(UIFont *)font numLine:(NSInteger)numLine
{
    UILabel *label = [UILabel new];
    label.frame = self.bounds;
    label.font = font;
    label.numberOfLines = numLine;
    label.attributedText = text;
    [label sizeToFit];
    CGSize size = label.size;
    label = nil;
    return size;
}

- (CGRect)zzElementFrameWithAttributedText:(NSAttributedString *)text font:(UIFont *)font numLine:(NSInteger)numLine
{
    return [self zzElementFrameWithAttributedText:text font:font numLine:numLine verticalAlignment:ZZTextVerticalAlignmentCenter];
}

- (CGRect)zzElementFrameWithAttributedText:(NSAttributedString *)text font:(UIFont *)font numLine:(NSInteger)numLine verticalAlignment:(ZZTextVerticalAlignment)verticalAlignment
{
    if (verticalAlignment == ZZTextVerticalAlignmentCenter) {
        return self.bounds;
    } else {
        CGRect rect = CGRectZero;
        CGSize size = [self zzElementSizeWithAttributedText:text font:font numLine:numLine];
        size.width = self.width;
        size.height = MIN(size.height, self.height);
        rect.size = size;
        if (verticalAlignment == ZZTextVerticalAlignmentBottom) {
            rect.origin.y = MAX((self.height - size.height), 0);
        }
        return rect;
    }
}

#pragma mark - NSAttributedString

- (NSAttributedString *)zzElementAttributedText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor
{
    return [self zzElementAttributedText:text font:font textColor:textColor isCenter:NO];
}

- (NSAttributedString *)zzElementAttributedText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor isCenter:(BOOL)isCenter
{
    return [self zzElementAttributedText:text attachment:nil font:font textColor:textColor isCenter:isCenter attachmentLeft:NO];
}

- (NSAttributedString *)zzElementAttributedText:(NSString *)text attachment:(nullable NSTextAttachment *)attachment font:(UIFont *)font textColor:(UIColor *)textColor isCenter:(BOOL)isCenter attachmentLeft:(BOOL)attachmentLeft
{
    NSMutableParagraphStyle *mParagraphStyle = [[NSMutableParagraphStyle  alloc] init];
    mParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    mParagraphStyle.lineSpacing = 0;
    if (isCenter) {
        mParagraphStyle.alignment = NSTextAlignmentCenter;
    } else {
        mParagraphStyle.alignment = NSTextAlignmentLeft;
    }
    
    NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:text];
    [mText addAttributes:@{NSParagraphStyleAttributeName:mParagraphStyle,
                           NSForegroundColorAttributeName:textColor,
                           NSFontAttributeName:font} range:NSMakeRange(0, text.length)];
    
    if (attachment != nil) {
        NSMutableAttributedString *mAttachmentText = [[NSMutableAttributedString alloc] init];
        if (attachmentLeft) {
            [mAttachmentText appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
            [mAttachmentText appendAttributedString:mText];
        } else {
            [mAttachmentText appendAttributedString:mText];
            [mAttachmentText appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
        }
        return mAttachmentText;
    } else {
        return mText;
    }
}

- (NSAttributedString *)zzElementAttributedText1:(NSAttributedString *)attributedText1 attributedText2:(NSAttributedString *)attributedText2 attributedText3:(NSAttributedString *)attributedText3 isCenter:(BOOL)isCenter
{
    NSMutableParagraphStyle *mParagraphStyle = [[NSMutableParagraphStyle  alloc] init];
    mParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    mParagraphStyle.lineSpacing = 0;
    if (isCenter) {
        mParagraphStyle.alignment = NSTextAlignmentCenter;
    } else {
        mParagraphStyle.alignment = NSTextAlignmentLeft;
    }
    
    NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText1];
    if (attributedText2 != nil) {
        [mText appendAttributedString:attributedText2];
    }
    if (attributedText3 != nil) {
        [mText appendAttributedString:attributedText3];
    }
    return mText;
}

@end

@implementation ZZElementView (ZZ)

- (NSString *)reuseID
{
    return objc_getAssociatedObject(self, &reuseIDKey);
}

- (void)setReuseID:(NSString *)reuseID
{
    objc_setAssociatedObject(self, &reuseIDKey, reuseID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)ID
{
    return objc_getAssociatedObject(self, &IDKey);
}

- (void)setID:(NSString *)ID
{
    objc_setAssociatedObject(self, &IDKey, ID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation ZZTapGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action index:(NSInteger)index
{
    if (self = [super initWithTarget:target action:action]) {
        self.numberOfTapsRequired = 1;
        self.numberOfTouchesRequired = 1;
        self.index = index;
    }
    return self;
}

@end

