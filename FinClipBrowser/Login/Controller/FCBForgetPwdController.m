//
//  FCBForgetPwdController.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/9.
//

#import "FCBForgetPwdController.h"
#import "FCBMainButton.h"
#import "FCBPhoneTextFieldView.h"
#import "FCBUITool.h"
#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>
#import "FCBVerificationCodeController.h"
#import "FCBAreaCodeSelectController.h"
#import "FCBCaptchaView.h"
#import "FCBRequestHelper.h"
#import "FCBAPP.h"
#import "FCBDefine.h"
#import "FCBURLSessionHelper.h"
#import "NSString+FCBExtension.h"
#import "FCBInputNewPwdController.h"
#import "FCBMainController.h"
#import <AFNetworking/AFNetworking.h>

@interface FCBForgetPwdController () <UITextFieldDelegate, FCBCaptchaViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) FCBPhoneTextFieldView *phoneView;
@property (nonatomic, strong) FCBCaptchaView *captchaView;
@property (nonatomic, strong) FCBMainButton *verifyButton;

@property (nonatomic, assign) BOOL isShowCaptcha;
@property (nonatomic, copy) NSString *captchaId;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *verificationCode;

@property (nonatomic, copy) NSString *countryNameCN;

@end

@implementation FCBForgetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareUI];
    [self layoutUI];
    [self textFieldTextDidChange];
    [self fetchCaptcha];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)prepareUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.titleLabel = [[UILabel alloc] init];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.text = NSLocalizedString(@"fpt_verify_phone", nil);
    self.titleLabel.font = kBoldFont(22);
    self.titleLabel.textColor = kRGB(0x2C3E51);
    
    self.phoneView = [[FCBPhoneTextFieldView alloc] initWithTitle:NSLocalizedString(@"fpt_phone", nil) placeholder:NSLocalizedString(@"fpt_enter_only_phone_number", nil) areaCode:@"+86"];
    [self.view addSubview:self.phoneView];
    self.phoneView.textField.delegate = self;
    self.phoneView.textField.returnKeyType = UIReturnKeyNext;
    [self.phoneView.textField becomeFirstResponder];
    [self.phoneView.areaCodeButton addTarget:self action:@selector(areaCodeButtoncClick) forControlEvents:UIControlEventTouchUpInside];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:self.phoneView.textField];
    
    self.captchaView = [[FCBCaptchaView alloc] init];
    self.captchaView.textField.returnKeyType = UIReturnKeyDone;
    self.captchaView.textField.delegate = self;
    self.captchaView.delegate = self;
    [self.view addSubview:self.captchaView];
    
    self.verifyButton = [[FCBMainButton alloc] initWithNormalTitle:NSLocalizedString(@"fpt_get_sms_code", nil)];
    [self.view addSubview:self.verifyButton];
    [self.verifyButton addTarget:self action:@selector(verifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutUI {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(8);
        make.left.equalTo(@(28));
    }];
    
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(26);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(@(-28));
    }];
    
    [self.captchaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView.mas_bottom).offset(15);
        make.left.right.equalTo(self.phoneView);
    }];
    
    [self.verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.captchaView.mas_bottom).offset(25);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.phoneView);
        make.height.equalTo(@(48));
    }];
}

- (void)fetchCaptcha {
    [FCBRequestHelper fetchCaptchaWithCallback:^(NSString *captchaId, UIImage *image, NSString *error) {
        if (error) {
            kHUD(error);
            return;
        }
        self.captchaId = captchaId;
        self.image = image;
        self.captchaView.image = self.image;
    }];
}

- (void)didGetVerificationCode:(NSString *)verificationCode {
    self.verificationCode = verificationCode;
    
    FCBInputNewPwdController *vc = [[FCBInputNewPwdController alloc] init];
    vc.inputNewPwdCallback = ^(NSString *pwd) {
        [self resetPWd:pwd];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)resetPWd:(NSString *)pwd {
    NSString *serverUrl = FCBAPP.shared.serverUrl;
    kShowLoading;
    NSString *getPasswordEncryption = [serverUrl stringByAppendingFormat:@"%@%@",API_PREFIX_V1, kGetPasswordEncryption];
    [FCBURLSessionHelper requestUrl:getPasswordEncryption
                              method:FCBRequestMethodGet
                              params:nil
                   completionHandler:^(NSDictionary *responseObject, NSString *error) {
        if (error == nil && [responseObject isKindOfClass:NSDictionary.class]) {
            int type = [responseObject[@"data"][@"type"] intValue];
            
            NSString *pwdEncode = type == 1 ? pwd.fcb_passwordEncrypt : pwd.fcb_md5;
            NSString *phone = self.phoneView.textField.text.fcb_DESEncrypt ? : @"";
            NSString *verificationCode = self.verificationCode ? : @"";
            
            NSString *urlString = [serverUrl stringByAppendingFormat:@"%@%@",API_PREFIX_V1, kResetPwd];
            NSDictionary *params = @{
                @"newPassword" : pwdEncode,
                @"phone" : phone,
                @"verifyCode" : verificationCode,
            };
            [FCBURLSessionHelper requestUrl:urlString
                                      method:FCBRequestMethodPost
                                      params:params
                           completionHandler:^(NSDictionary *responseObject, NSString *error) {
                kHideLoading;
                if (error == nil && [responseObject[@"errcode"] isEqualToString:@"OK"]){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    kHUD(NSLocalizedString(@"fpt_psd_change_fail", nil));
                }
            }];
        } else {
            kHideLoading;
            kHUD(NSLocalizedString(@"fpt_psd_change_fail", nil));
        }
    }];
}

#pragma mark - Action

- (void)areaCodeButtoncClick {
    FCBAreaCodeSelectController *vc = [[FCBAreaCodeSelectController alloc] initWithAreaCode:self.phoneView.areaCode
                                                                              countryNameCN:self.countryNameCN];
    vc.selectedCallback = ^(NSString *areaCode, NSString *countryNameCN) {
        self.phoneView.areaCode = areaCode;
        self.countryNameCN = countryNameCN;
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)verifyButtonClick {
    NSString *type = @"forget";
    NSString *phone = self.phoneView.textField.text;
    NSString *areaCode = self.phoneView.areaCode;
    NSString *captchaId = self.captchaId;
    NSString *captcha = self.captchaView.captcha;
    
    [FCBRequestHelper sendVerificationCodeWithType:type
                                             phone:phone
                                          areaCode:areaCode
                                         captchaId:captchaId
                                           captcha:captcha
                                          callback:^(BOOL isSuccess, NSString *error) {
        if (isSuccess) {
            FCBVerificationCodeController *vc = [[FCBVerificationCodeController alloc] initWithPhone:phone
                                                                                            areaCode:areaCode
                                                                                                type:type
                                                                                           captchaId:captchaId
                                                                                             captcha:captcha];
            vc.mainButtonTitle = NSLocalizedString(@"fpt_v_code_next", nil);
            vc.verificationCodeCallback = ^(NSString *verificationCode) {
                [self didGetVerificationCode:verificationCode];
            };
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            kHUD(NSLocalizedString(@"fpt_sms_send_fail", nil));
        }
    }];
}

#pragma mark - <FCBCaptchaViewDelegate>

- (void)didClickCaptcha {
    [self fetchCaptcha];
}

- (void)captchaDidChange {
    [self textFieldTextDidChange];
}

#pragma mark - <NSNotificationCenter>

- (void)textFieldTextDidChange {
    self.verifyButton.enabled = self.phoneView.textField.text.length && self.captchaView.captcha.length;
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.phoneView.textField) {
        [self.captchaView.textField becomeFirstResponder];
    } else if (textField == self.captchaView.textField) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self verifyButtonClick];
        });
    }
    return YES;
}

#pragma mark - UITouch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

@end
