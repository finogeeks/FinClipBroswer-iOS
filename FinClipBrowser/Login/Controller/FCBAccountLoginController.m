//
//  FCBAccountLoginController.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/9.
//

#import "FCBAccountLoginController.h"
#import <Masonry/Masonry.h>
#import "FCBUITool.h"
#import "FCBTextFieldView.h"
#import "FCBAPP.h"
#import "FCBDefine.h"
#import "FCBURLSessionHelper.h"
#import "NSString+FCBExtension.h"
#import <YYModel/YYModel.h>
#import "FCBMainController.h"
#import "FCBForgetPwdController.h"
#import "FCBMainButton.h"
#import "FCBSMSLoginController.h"
#import "FCBRequestHelper.h"
#import "FCBCaptchaView.h"

@interface FCBAccountLoginController ()<UITextFieldDelegate, FCBCaptchaViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *verifyLoginButton;

@property (nonatomic, strong) FCBTextFieldView *phoneView;
@property (nonatomic, strong) FCBTextFieldView *passwordView;

@property (nonatomic, strong) FCBCaptchaView *captchaView;

@property (nonatomic, strong) MASConstraint *topConstraint;
@property (nonatomic, strong) FCBMainButton *loginButton;
@property (nonatomic, strong) UIButton *forgetButton;

@property (nonatomic, assign) BOOL isShowCaptcha;
@property (nonatomic, copy) NSString *captchaId;
@property (nonatomic, strong) UIImage *image;

@end

@implementation FCBAccountLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareUI];
    [self layoutUI];
    [self textFieldTextDidChange];
    [self updateUI];
    
    self.verifyLoginButton.hidden = FCBAPP.shared.isOperationLogin || !FCBAPP.shared.isUATEnvironment;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)prepareUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.titleLabel = [[UILabel alloc] init];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.text = NSLocalizedString(@"fpt_account_login", nil);
    self.titleLabel.font = kBoldFont(22);
    self.titleLabel.textColor = kRGB(0x2C3E51);
    
    self.verifyLoginButton = [[UIButton alloc] init];
    [self.view addSubview:self.verifyLoginButton];
    self.verifyLoginButton.titleLabel.font = kRegularFont(13);
    [self.verifyLoginButton setTitleColor:kRGB(0x9A9EA5) forState:UIControlStateNormal];
    [self.verifyLoginButton setTitle:NSLocalizedString(@"fpt_sms_login_tips", nil) forState:UIControlStateNormal];
    [self.verifyLoginButton addTarget:self action:@selector(verifyLoginButtonClock) forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneView = [[FCBTextFieldView alloc] initWithTitle:NSLocalizedString(@"fpt_phone", nil) placeholder:NSLocalizedString(@"fpt_enter_phone_number", nil) isSecurity:NO];
    [self.view addSubview:self.phoneView];
    self.phoneView.textField.delegate = self;
    self.phoneView.textField.returnKeyType = UIReturnKeyNext;
    [self.phoneView.textField becomeFirstResponder];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:self.phoneView.textField];
    
    self.passwordView = [[FCBTextFieldView alloc] initWithTitle:NSLocalizedString(@"fpt_password", nil) placeholder:NSLocalizedString(@"fpt_enter_password", nil) isSecurity:YES];
    [self.view addSubview:self.passwordView];
    self.passwordView.textField.delegate = self;
    self.passwordView.textField.returnKeyType = UIReturnKeyDone;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:self.passwordView.textField];
    
    self.captchaView = [[FCBCaptchaView alloc] init];
    self.captchaView.delegate = self;
    [self.view addSubview:self.captchaView];
    
    self.loginButton = [[FCBMainButton alloc] initWithNormalTitle:NSLocalizedString(@"fpt_login", nil)];
    [self.view addSubview:self.loginButton];
    [self.loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.forgetButton = [[UIButton alloc] init];
    [self.view addSubview:self.forgetButton];
    self.forgetButton.titleLabel.font = kRegularFont(14);
    [self.forgetButton setTitleColor:kRGB(0x4285F4) forState:UIControlStateNormal];
    [self.forgetButton setTitle:NSLocalizedString(@"fpt_forget_password", nil) forState:UIControlStateNormal];
    [self.forgetButton addTarget:self action:@selector(forgetButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutUI {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(8);
        make.left.equalTo(@(28));
    }];
    
    [self.verifyLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.right.equalTo(@(-28));
        make.left.equalTo(@(28));
    }];
    
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyLoginButton.mas_bottom).offset(26);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.verifyLoginButton);
    }];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView.mas_bottom).offset(15);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.verifyLoginButton);
    }];
    
    [self.captchaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom).offset(15);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.verifyLoginButton);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        self.topConstraint = make.top.equalTo(self.passwordView.mas_bottom).offset(25);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.verifyLoginButton);
        make.height.equalTo(@(48));
    }];
    
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
}

- (void)updateUI {
    if (self.isShowCaptcha) {
        self.captchaView.hidden = NO;
        self.captchaView.image = self.image;
        self.topConstraint.offset(100);
    } else {
        self.captchaView.hidden = YES;
        self.topConstraint.offset(25);
    }
}

- (void)fetchCaptcha {
    [FCBRequestHelper fetchCaptchaWithCallback:^(NSString *captchaId, UIImage *image, NSString *error) {
        if (error) {
            kHUD(error);
            return;
        }
        self.captchaId = captchaId;
        self.image = image;
        [self updateUI];
    }];
}

#pragma mark - Action

- (void)verifyLoginButtonClock {
    if (self.navigationController.viewControllers.count > 1) {
        UIViewController *vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
        if ([vc isKindOfClass:FCBSMSLoginController.class]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    //
    FCBSMSLoginController *vc = [[FCBSMSLoginController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginButtonClick {
    NSString *serverUrl = FCBAPP.shared.serverUrl;
    NSString *getPasswordEncryption = [serverUrl stringByAppendingFormat:@"%@%@",API_PREFIX_V1, kGetPasswordEncryption];
    kShowLoading;
    [FCBURLSessionHelper requestUrl:getPasswordEncryption
                              method:FCBRequestMethodGet
                              params:nil
                   completionHandler:^(NSDictionary *responseObject, NSString *error) {
        if (error == nil && [responseObject isKindOfClass:NSDictionary.class]) {
            int type = [responseObject[@"data"][@"type"] intValue];
            
            NSString *account = self.phoneView.textField.text ? : @"";
            NSString *password = self.passwordView.textField.text ? : @"";
            NSString *captchaId = @"";
            NSString *captchaStr = @"";
            if (self.isShowCaptcha) {
                captchaId = self.captchaId ?: @"";
                captchaStr = self.captchaView.captcha ? : @"";
            }
            
            NSMutableDictionary *params = @{@"account" : account.fcb_DESEncrypt,
                                            @"isWeb" : @(NO),
                                            @"captchaId" : captchaId,
                                            @"captchaStr" : captchaStr
            }.mutableCopy;
            
            if (type == 1) {
                [params setValue:password.fcb_passwordEncrypt forKey:@"password"];
            } else {
                [params setValue:password.fcb_md5 forKey:@"password"];
            }
            
            NSString *urlString = [serverUrl stringByAppendingFormat:@"%@%@",API_PREFIX_V1, kAccountLogin];
            [FCBURLSessionHelper requestUrl:urlString
                                      method:FCBRequestMethodPost
                                      params:params
                           completionHandler:^(NSDictionary *responseObject, NSString *error) {
                kHideLoading;
                if (error == nil && [responseObject isKindOfClass:NSDictionary.class]) {
                    FCBUserInfo *info = [FCBUserInfo yy_modelWithJSON:responseObject[@"data"]];
                    [FCBAPP.shared loginWithUserInfo:info];
                    FCBAPP.shared.account = account;
                    
                    [self.navigationController setViewControllers:@[FCBMainController.new] animated:NO];
                } else {
                    NSInteger captchaErrCount = [responseObject[@"data"][@"captchaErrCount"] intValue];
                    if (captchaErrCount > 2) {
                        self.isShowCaptcha = YES;
                    }
                    if (self.isShowCaptcha) {
                        [self fetchCaptcha];
                    }
                    kHUD(NSLocalizedString(@"fpt_login_err", nil));
                }
            }];
        } else {
            kHideLoading;
            kHUD(NSLocalizedString(@"fpt_login_err", nil));
        }
    }];
}

- (void)forgetButtonClick {
    FCBForgetPwdController *vc = [[FCBForgetPwdController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - <NSNotificationCenter>

- (void)textFieldTextDidChange {
    BOOL enabled = self.phoneView.textField.text.length > 0 && self.passwordView.textField.text.length > 0;
    self.loginButton.enabled = enabled;
}

#pragma mark - <FCBCaptchaViewDelegate>

- (void)didClickCaptcha {
    [self fetchCaptcha];
}

- (void)captchaDidChange {
    [self textFieldTextDidChange];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.phoneView.textField) {
        [self.passwordView.textField becomeFirstResponder];
    } else if (textField == self.passwordView.textField) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loginButtonClick];
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
