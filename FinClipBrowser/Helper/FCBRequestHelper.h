//
//  FCBRequestHelper.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCBRequestHelper : NSObject

+ (void)fetchCaptchaWithCallback:(void(^)(NSString *captchaId, UIImage *image, NSString *error))cllback;

+ (void)sendVerificationCodeWithType:(NSString *)type
                               phone:(NSString *)phone
                            areaCode:(NSString *)areaCode
                           captchaId:(NSString *)captchaId
                             captcha:(NSString *)captcha
                            callback:(void(^)(BOOL isSuccess, NSString *error))callback;

@end

NS_ASSUME_NONNULL_END
