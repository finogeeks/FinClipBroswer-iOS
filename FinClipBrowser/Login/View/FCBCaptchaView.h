//
//  FCBCaptchaView.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FCBCaptchaViewDelegate <NSObject>

- (void)didClickCaptcha;
- (void)captchaDidChange;

@end

@interface FCBCaptchaView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, readonly) NSString *captcha;
@property (nonatomic, strong, readonly) UITextField *textField;

@property (nonatomic, weak) id<FCBCaptchaViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
