//
//  UIButton+FCBExtension.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (FCBExtension)

- (void)fcb_layoutWithTopImageAndSpace:(CGFloat)space;
- (void)fcb_layoutWithLeftImageAndSpace:(CGFloat)space;
- (void)fcb_layoutWithBottomImageAndSpace:(CGFloat)space;
- (void)fcb_layoutWithRightImageAndSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
