//
//  FCBUITool.h
//  FinClipBrowser
//
//  Created by vchan on 2023/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kRGB(rgb)   [FCBUITool colorWithRGBValue:(rgb)]
#define kRGBA(rgba) [FCBUITool colorWithRGBAValue:(rgba)]

#define kRegularFont(size) [FCBUITool regularFontWithSize:(size)]
#define kMediumFont(size) [FCBUITool mediumFontWithSize:(size)]
#define kBoldFont(size) [FCBUITool boldFontWithSize:(size)]

#define kHUD(info) [FCBUITool showInfo:(info)]
#define kShowLoading [FCBUITool showLoading:YES]
#define kHideLoading [FCBUITool showLoading:NO]

@interface FCBUITool : NSObject

+ (UIColor *)colorWithRGBValue:(NSInteger)rgb;
+ (UIColor *)colorWithRGBAValue:(NSInteger)rgba;

+ (UIFont *)regularFontWithSize:(CGFloat)size;
+ (UIFont *)mediumFontWithSize:(CGFloat)size;
+ (UIFont *)boldFontWithSize:(CGFloat)size;

+ (UIEdgeInsets)safeAreaInsets;

+ (void)showInfo:(NSString *)info;
+ (void)showLoading:(BOOL)isShow;

+ (NSString *)logoUrl:(NSString *)logo;


@end

NS_ASSUME_NONNULL_END
