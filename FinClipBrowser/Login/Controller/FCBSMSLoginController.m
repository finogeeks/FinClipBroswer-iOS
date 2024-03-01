//
//  FCBSMSLoginController.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/10.
//

#import "FCBSMSLoginController.h"
#import "FCBUITool.h"
#import "FCBTextFieldView.h"
#import "FCBMainButton.h"
#import <Masonry/Masonry.h>
#import "FCBAccountLoginController.h"
#import "FCBVerificationCodeController.h"
#import "FCBURLSessionHelper.h"
#import "FCBAPP.h"
#import "FCBDefine.h"
#import <YYModel/YYModel.h>
#import "NSString+FCBExtension.h"
#import "FCBRequestHelper.h"
#import "FCBMainController.h"
#import "FCBPhoneTextFieldView.h"
#import "FCBAreaCodeSelectController.h"

@interface FCBSMSLoginController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *accountVerifyButton;

@property (nonatomic, strong) FCBPhoneTextFieldView *phoneView;

@property (nonatomic, strong) FCBMainButton *verifyButton;

@property (nonatomic, strong) NSString *countryNameCN;

@end

@implementation FCBSMSLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareUI];
    [self layoutUI];
    [self textFieldTextDidChange];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)prepareUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.titleLabel = [[UILabel alloc] init];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.text = NSLocalizedString(@"fpt_sms_login", nil);
    self.titleLabel.font = kBoldFont(22);
    self.titleLabel.textColor = kRGB(0x2C3E51);
    
    self.accountVerifyButton = [[UIButton alloc] init];
    [self.view addSubview:self.accountVerifyButton];
    self.accountVerifyButton.titleLabel.font = kRegularFont(13);
    [self.accountVerifyButton setTitleColor:kRGB(0x9A9EA5) forState:UIControlStateNormal];
    [self.accountVerifyButton setTitle:NSLocalizedString(@"fpt_account_login", nil) forState:UIControlStateNormal];
    [self.accountVerifyButton addTarget:self action:@selector(accountVerifyButtonClock) forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneView = [[FCBPhoneTextFieldView alloc] initWithTitle:NSLocalizedString(@"fpt_phone", nil) placeholder:NSLocalizedString(@"fpt_enter_only_phone_number", nil) areaCode:@"+86"];
    [self.view addSubview:self.phoneView];
    self.phoneView.textField.delegate = self;
    self.phoneView.textField.returnKeyType = UIReturnKeyNext;
    [self.phoneView.textField becomeFirstResponder];
    [self.phoneView.areaCodeButton addTarget:self action:@selector(areaCodeButtoncClick) forControlEvents:UIControlEventTouchUpInside];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:self.phoneView.textField];
    
    self.verifyButton = [[FCBMainButton alloc] initWithNormalTitle:NSLocalizedString(@"fpt_get_sms_code", nil)];
    [self.view addSubview:self.verifyButton];
    [self.verifyButton addTarget:self action:@selector(verifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutUI {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(8);
        make.left.equalTo(@(28));
    }];
    
    [self.accountVerifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(@(-28));
    }];
    
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountVerifyButton.mas_bottom).offset(26);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(@(-28));
    }];
    
    [self.verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView.mas_bottom).offset(25);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(@(-28));
        make.height.equalTo(@(48));
    }];
}

- (void)didGetVerificationCode:(NSString *)verificationCode {
    NSString *phone = self.phoneView.textField.text;
    
    NSString *serverUrl = FCBAPP.shared.serverUrl;
    NSString *urlString = [serverUrl stringByAppendingFormat:@"%@%@",API_PREFIX_V2, kOrganLogin];
    NSDictionary *params = @{
        @"carrier" : FCBAPP.shared.carrierName,
        @"from" : @"app",
        @"type" : @"oneClick-verifyCode",
        @"account" : phone.fcb_DESEncrypt,
        @"areaCode" : self.phoneView.areaCode ? : @"",
        @"verifyCode" : verificationCode ? : @"",
    };
    [FCBURLSessionHelper requestUrl:urlString
                              method:FCBRequestMethodPost
                              params:params
                   completionHandler:^(NSDictionary *responseObject, NSString *error) {
        if (error == nil && [responseObject isKindOfClass:NSDictionary.class]) {
            FCBUserInfo *info = [FCBUserInfo yy_modelWithJSON:responseObject[@"data"]];
            [FCBAPP.shared loginWithUserInfo:info];
            FCBAPP.shared.account = phone;
            
            [self dismissViewControllerAnimated:NO completion:nil];
            [self.navigationController setViewControllers:@[FCBMainController.new] animated:NO];
        } else {
            kHUD(NSLocalizedString(@"fpt_login_err", nil));
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

- (void)accountVerifyButtonClock {
    if (self.navigationController.viewControllers.count > 1) {
        UIViewController *vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
        if ([vc isKindOfClass:FCBAccountLoginController.class]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    //
    FCBAccountLoginController *vc = [[FCBAccountLoginController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)verifyButtonClick {
    NSString *phone = self.phoneView.textField.text ? : @"";
    NSString *areaCode = self.phoneView.areaCode ? : @"";
    FCBVerificationCodeController *vc = [[FCBVerificationCodeController alloc] initWithPhone:phone
                                                                                    areaCode:areaCode
                                                                                        type:@"one-click-verify-code"
                                                                                   captchaId:nil
                                                                                     captcha:nil];
    vc.mainButtonTitle = NSLocalizedString(@"fpt_login", nil);
    vc.verificationCodeCallback = ^(NSString *verificationCode) {
        [self didGetVerificationCode:verificationCode];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - <NSNotificationCenter>

- (void)textFieldTextDidChange {
    BOOL enabled = self.phoneView.textField.text.length > 0;
    self.verifyButton.enabled = enabled;
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self verifyButtonClick];
    });
    return YES;
}

#pragma mark - UITouch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

@end
