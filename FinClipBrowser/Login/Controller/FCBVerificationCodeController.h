//
//  FCBVerificationCodeController.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCBVerificationCodeController : UIViewController

- (instancetype)initWithPhone:(NSString *)phone
                     areaCode:(NSString *)areaCode
                         type:(NSString *)type
                    captchaId:(NSString * _Nullable)captchaId
                      captcha:(NSString * _Nullable)captcha;

@property (nonatomic, copy) NSString *mainButtonTitle;

@property (nonatomic, copy) void(^verificationCodeCallback)(NSString *verificationCode);

@end

NS_ASSUME_NONNULL_END
