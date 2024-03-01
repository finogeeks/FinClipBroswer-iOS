//
//  FCBDefine.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/2.
//

#ifndef FCBDefine_h
#define FCBDefine_h

#import <Foundation/Foundation.h>
#import "FCBAPP.h"

// finclip appKey and secret
#define kAppKeyUrl @"22LyZEib0gLTQdU3MUauAfm+m7PCpCHZRMKS3X8Fyq08NDQIavxKhnteuHH2EV6c"
#define kAppSecretUrl @"8e0dafa7757dd8fe"

//FinClip.com server
#define kSAASServerURL @"https://api.finclip.com"

//Service Agreement
#define kAgreementLink  @"https://www.finclip.com/terms#service"
//Privacy Policy
#define kPolicyLink     @"https://www.finclip.com/terms#privacy"
//User Guide
#define kInstructionsURL @"https://www.finclip.com/mop/document/introduce/functionDescription/finclip.html"

//Server Configuration
#define API_PREFIX_V1 @"/api/v1/mop"
#define API_PREFIX_V2 @"/api/v2/mop"

//Test server environment is available url
#define TEST_URL @"/applets-ecol-account/operation/ftHelper/testUrl"
#define kGetEnvironmentUrl @"/applets-ecol-account/organ/auth/get-evn"
//login interface
//check jwt is available
#define kTestJwtValid @"/applets-ecol-account/operation/ftHelper/testJwtValid"
//refresh token
#define kRefreshToken @"/applets-ecol-device-security/refresh/token"
//Get the Graphic Verification Code Interface
#define kOrganGetCaptchaUrl @"/applets-ecol-account/common/captcha"
//Send SMS verification code Interface
#define kOrganSendVerificationCodeUrl @"/applets-ecol-account/organ/phone/verify-code"
#define kOperationSendVerificationCodeUrl @"/applets-ecol-account/operation/worker/phone/verify-code"
//Account Login Interface
#define kGetPasswordEncryption  @"/applets-ecol-account/common/password/encryption"
#define kOrganLogin     @"/applets-ecol-account/organ/login"
#define kOperationLogin @"/applets-ecol-account/operation/login"
//reset pwd Interface
#define kOrganResetPwd @"/applets-ecol-account/organ/account/password/forget"
#define kOperationResetPwd @"/applets-ecol-account/operation/worker/forgot/password"
//home page data Interface
#define kMiniProgramList @"/finstore/dev/config/helper"


/////////////
#define kAccountLogin (FCBAPP.shared.isOperationLogin ? kOperationLogin : kOrganLogin)
#define kGetCaptchaUrl kOrganGetCaptchaUrl
#define kSendVerificationCodeUrl (FCBAPP.shared.isOperationLogin ? kOperationSendVerificationCodeUrl : kOrganSendVerificationCodeUrl)
#define kResetPwd (FCBAPP.shared.isOperationLogin ? kOperationResetPwd : kOrganResetPwd)
#endif /* FCBDefine_h */
