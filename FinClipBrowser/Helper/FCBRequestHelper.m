//
//  FCBRequestHelper.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/14.
//

#import "FCBRequestHelper.h"
#import "FCBURLSessionHelper.h"
#import "FCBAPP.h"
#import "FCBDefine.h"
#import "NSString+FCBExtension.h"

@implementation FCBRequestHelper

+ (void)fetchCaptchaWithCallback:(void(^)(NSString *captchaId, UIImage *image, NSString *error))cllback {
    NSString *serverUrl = FCBAPP.shared.serverUrl;
    NSString *getPasswordEncryption = [serverUrl stringByAppendingFormat:@"%@%@",API_PREFIX_V1, kGetCaptchaUrl];
    
    NSDictionary *params = @{@"width" : @(144), @"height" : @(68)};
    
    [FCBURLSessionHelper requestUrl:getPasswordEncryption
                             method:FCBRequestMethodPost
                             params:params
                  completionHandler:^(NSDictionary *responseObject, NSString *error) {
        NSString *captchaId = responseObject[@"data"][@"id"];
        NSString *imageBase64 = responseObject[@"data"][@"imageBase64"];
        NSArray *array = [imageBase64 componentsSeparatedByString:@","];
        UIImage *image = nil;
        if (array.count == 2) {
            imageBase64 = array[1];
            image = [UIImage imageWithData:imageBase64.fcb_base64DecodeWithData];
        }
        
        if (captchaId.length && image) {
            cllback ? cllback(captchaId, image, nil) : nil;
        } else {
            cllback ? cllback(nil, nil, error) : nil;
        }
    }];
}

+ (void)sendVerificationCodeWithType:(NSString *)type
                               phone:(NSString *)phone
                            areaCode:(NSString *)areaCode
                           captchaId:(NSString *)captchaId
                             captcha:(NSString *)captcha
                            callback:(void (^)(BOOL, NSString *))callback {
    type = type ?: @"";
    phone = (phone ?: @"").fcb_DESEncrypt;
    areaCode = areaCode ?: @"";
    captchaId = captchaId ?: @"";
    captcha = captcha ?: @"";
    
    NSString *serverUrl = FCBAPP.shared.serverUrl;
    NSString *urlString = [serverUrl stringByAppendingFormat:@"%@%@", API_PREFIX_V1, kSendVerificationCodeUrl];
    
    NSDictionary *params = nil;
    if (FCBAPP.shared.isOperationLogin) {
        urlString = [urlString stringByAppendingFormat:@"?type=%@&traceId=&phone=%@&captchaStr=%@&captchaId=%@", type, phone, captcha, captchaId];
    } else {
        params = @{
            @"phone" : phone,
            @"type" : type,
            @"areaCode" : areaCode,
            @"captchaId" : captchaId,
            @"captchaStr" : captcha,
        };
    }
    
    [FCBURLSessionHelper requestUrl:urlString
                             method:FCBAPP.shared.isOperationLogin ? FCBRequestMethodGet : FCBRequestMethodPost
                             params:params
                  completionHandler:^(NSDictionary *responseObject, NSString *error) {
        if (error == nil && [responseObject[@"errcode"] isEqual:@"OK"]) {
            callback ? callback(YES, nil) : nil;
        } else {
            callback ? callback(NO, error) : nil;
        }
    }];
}

@end
