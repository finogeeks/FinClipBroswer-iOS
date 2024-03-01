//
//  FCBUITool.m
//  FinClipBrowser
//
//  Created by vchan on 2023/2/28.
//

#import "FCBUITool.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FCBDefine.h"
#import "FCBAPP.h"

@implementation FCBUITool

# pragma mark - Color

+ (UIColor *)colorWithRGBValue:(NSInteger)rgba {
    CGFloat red = ((float)((rgba & 0xFF0000) >> 16)) / 255.0;
    CGFloat green = ((float)((rgba & 0xFF00) >> 8)) / 255.0;
    CGFloat blue = ((float)(rgba & 0xFF)) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)colorWithRGBAValue:(NSInteger)rgba {
    CGFloat red = ((float)((rgba & 0xFF000000) >> 24)) / 255.0;
    CGFloat green = ((float)((rgba & 0xFF0000) >> 16)) / 255.0;
    CGFloat blue = ((float)((rgba & 0xFF00) >> 8)) / 255.0;
    CGFloat alpha = ((float)(rgba & 0xFF)) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark - Font

+ (UIFont *)regularFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

+ (UIFont *)mediumFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
}

+ (UIFont *)boldFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
}

#pragma mark - safeAreaInsets

+ (UIEdgeInsets)safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return UIApplication.sharedApplication.keyWindow.safeAreaInsets;
    } else {
        return UIEdgeInsetsMake(20, 0, 0, 0);
    }
}

#pragma mark - Hud

+ (void)showInfo:(NSString *)info {
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setBackgroundColor:kRGBA(0x000000CC)];
    [SVProgressHUD setForegroundColor:kRGB(0xFFFFFF)];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setImageViewSize:CGSizeZero];
    [SVProgressHUD showInfoWithStatus:info];
}

+ (void)showLoading:(BOOL)isShow {
    if (isShow) {
        [SVProgressHUD show];
    } else {
        [SVProgressHUD dismiss];
    }
}

#pragma mark - Logo

+ (NSString *)logoUrl:(NSString *)logo {
    NSString *serverUrl = FCBAPP.shared.serverUrl;
    if (!serverUrl) {
        serverUrl = @"";
    }
    
    if ([logo hasPrefix:@"http"]) {
        return logo;
    } else if ([logo hasPrefix:@"/"]) {
        return [serverUrl stringByAppendingString:logo];
    } else {
        return [[serverUrl stringByAppendingString:@"/api/v1/mop/netdisk/download/"] stringByAppendingString:logo];
    }
}

@end
