//
//  ZZElementView.h
//  ZZLarkifyView
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZElementModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZZElementDataSource <NSObject>
@required

/**
 *  绘制元素
 *
 *  @param model                元素配置
 *  @param value                元素Value
 *  @param type                 元素子类型
 */
- (void)bindElement:(ZZElementModel *)model
              value:(id)value
               type:(ZZElementType)type;

@end


@interface ZZElementView : UIView

/**
 *  清除tapGesture
 */
- (void)clearGestures;
/**
 *  添加tapGesture
 *
 *  @param target               target
 *  @param selecotr             selecotr
 *  @param index                当前元素及model的index
 */
- (void)addTapTarget:(id)target
            selector:(SEL)selecotr
               index:(NSUInteger)index;
/**
 *  需要 -bringSubviewToFront:
 *
 *  @return BOOL
 */
- (BOOL)shouldFront;
/**
 *  绘制元素
 *
 *  @param model                元素配置
 *  @param value                元素Value
 *  @param type                 元素子类型
 */
- (void)bindElement:(ZZElementModel *)model
              value:(id)value
               type:(ZZElementType)type;

#pragma mark - 元素细节方法

/**
 *  图片附件-垂直居中
 *
 *  @param image                图片
 *  @param font                 字体
 *  @param height               高度
 *  @return NSTextAttachment
 */
- (NSTextAttachment *)zzElementAttachment:(UIImage *)image
                                     font:(UIFont *)font
                                   height:(CGFloat)height;
/**
 *  图片附件
 *
 *  @param image                图片
 *  @param font                 字体
 *  @param height               高度
 *  @param alignment            垂直位置
 *  @return NSTextAttachment
 */
- (NSTextAttachment *)zzElementAttachment:(UIImage *)image
                                     font:(UIFont *)font
                                   height:(CGFloat)height
                                alignment:(ZZAttachementVerticalAlignment)alignment;
/**
 *  富文本（纯文本）
 *
 *  @param text                 文本
 *  @param font                 字体
 *  @param textColor            字体颜色
 *  @param isCenter             文本居中
 *  @return NSAttributedString
 */
- (NSAttributedString *)zzElementAttributedText:(NSString *)text
                                           font:(UIFont *)font
                                      textColor:(UIColor *)textColor
                                       isCenter:(BOOL)isCenter;

/**
 *  富文本（文本+图片）
 *
 *  @param text                 文本
 *  @param attachment           图片
 *  @param font                 字体
 *  @param textColor            字体颜色
 *  @param isCenter             是否左右居中显示
 *  @param attachmentLeft       图片居左
 *  @return NSAttributedString
 */
- (NSAttributedString *)zzElementAttributedText:(NSString *)text
                                     attachment:(nullable NSTextAttachment *)attachment
                                           font:(UIFont *)font
                                      textColor:(UIColor *)textColor
                                       isCenter:(BOOL)isCenter
                                 attachmentLeft:(BOOL)attachmentLeft;
/**
 *  合并富文本
 *
 *  @param attributedText1      富文本1
 *  @param attributedText2      富文本2
 *  @param attributedText3      富文本3
 *  @param isCenter             文本居中
 *  @return NSAttributedString
 */
- (NSAttributedString *)zzElementAttributedText1:(NSAttributedString *)attributedText1
                                 attributedText2:(NSAttributedString *)attributedText2
                                 attributedText3:(NSAttributedString *)attributedText3
                                        isCenter:(BOOL)isCenter;
/**
 *  计算富文本实际CGSize
 *
 *  @param text                 富文本
 *  @param font                 字体
 *  @param numLine              行高
 *  @return CGSize
 */
- (CGSize)zzElementSizeWithAttributedText:(NSAttributedString *)text
                                     font:(UIFont *)font
                                  numLine:(NSInteger)numLine;
/**
 *  计算富文本CGRect
 
 *  @param text                 富文本
 *  @param font                 字体
 *  @param numLine              行高
 *  @return CGRect
 */
- (CGRect)zzElementFrameWithAttributedText:(NSAttributedString *)text
                                      font:(UIFont *)font
                                   numLine:(NSInteger)numLine;
/**
 *  计算富文本CGRect
 *
 *  @param text                 富文本
 *  @param font                 字体
 *  @param numLine              行高
 *  @param verticalAlignment    显示框内垂直居上显示
 *  @return CGRect
 */
- (CGRect)zzElementFrameWithAttributedText:(NSAttributedString *)text
                                      font:(UIFont *)font
                                   numLine:(NSInteger)numLine
                         verticalAlignment:(ZZTextVerticalAlignment)verticalAlignment;

@end

@interface ZZElementView (ZZ)

@property (nonatomic, copy)     NSString    *ID;           ///< 唯一ID
@property (nonatomic, copy)     NSString    *reuseID;      ///< 复用ID

@end

@interface ZZTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, assign)   NSInteger   index;

- (instancetype)initWithTarget:(id)target
                        action:(SEL)action
                         index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
