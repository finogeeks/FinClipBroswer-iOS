//
//  UIButton+FCBExtension.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/29.
//

#import "UIButton+FCBExtension.h"

typedef NS_ENUM(NSUInteger, VCHButtonStyle) {
    VCHButtonStyleTopImage,
    VCHButtonStyleLeftImage,
    VCHButtonStyleBottomImage,
    VCHButtonStyleRightImage    
};

@implementation UIButton (FCBExtension)

- (void)fcb_layoutWithTopImageAndSpace:(CGFloat)space {
    [self fcb_layoutWithStyle:VCHButtonStyleTopImage space:space];
}

- (void)fcb_layoutWithLeftImageAndSpace:(CGFloat)space {
    [self fcb_layoutWithStyle:VCHButtonStyleLeftImage space:space];
}

- (void)fcb_layoutWithBottomImageAndSpace:(CGFloat)space {
    [self fcb_layoutWithStyle:VCHButtonStyleBottomImage space:space];
}

- (void)fcb_layoutWithRightImageAndSpace:(CGFloat)space {
    [self fcb_layoutWithStyle:VCHButtonStyleRightImage space:space];
}

- (void)fcb_layoutWithStyle:(VCHButtonStyle)style space:(CGFloat)space {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
    CGFloat labelHeight = self.titleLabel.intrinsicContentSize.height;
    
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    CGFloat halfSpace = space / 2;
    
    switch (style) {
        case VCHButtonStyleTopImage: {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight - halfSpace, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight - halfSpace, 0);
        } break;
        case VCHButtonStyleLeftImage: {
            imageEdgeInsets = UIEdgeInsetsMake(0, -halfSpace, 0, halfSpace);
            labelEdgeInsets = UIEdgeInsetsMake(0, halfSpace, 0, -halfSpace);
        } break;
        case VCHButtonStyleBottomImage: {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight - halfSpace, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight - halfSpace, -imageWith, 0, 0);
        } break;
        case VCHButtonStyleRightImage: {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + halfSpace, 0, -labelWidth - halfSpace);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith - halfSpace, 0, imageWith + halfSpace);
        } break;
    }
    
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

@end
