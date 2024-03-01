//
//  FCBVerificationCodeController.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/10.
//

#import "FCBVerificationCodeController.h"
#import "FCBMainButton.h"
#import "FCBTextFieldView.h"
#import "FCBUITool.h"
#import <Masonry/Masonry.h>
#import "FCBVerificationCodeView.h"
#import "FCBRequestHelper.h"
#import "FCBAPP.h"

@interface FCBVerificationCodeController ()<FCBVerificationCodeDelegate>

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *areaCode;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *captchaId;
@property (nonatomic, copy) NSString *captcha;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) FCBVerificationCodeView *verificationCodeView;

@property (nonatomic, strong) FCBMainButton *doneButton;
@property (nonatomic, strong) UIButton *refetchButton;

@property (nonatomic, assign) NSTimeInterval startInterval;

@end

@implementation FCBVerificationCodeController

- (instancetype)initWithPhone:(NSString *)phone
                     areaCode:(NSString *)areaCode
                         type:(NSString *)type
                    captchaId:(NSString *)captchaId
                      captcha:(NSString *)captcha {
    if (self = [super init]) {
        self.phone = phone;
        self.areaCode = areaCode;
        self.type = type;
        self.captchaId = captchaId;
        self.captcha = captcha;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareUI];
    [self layoutUI];
    
    [self startTime];
    [self sendVerificationCodeAction];
}

- (void)prepareUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.titleLabel = [[UILabel alloc] init];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.text = NSLocalizedString(@"fpt_enter_v_code", nil);
    self.titleLabel.font = kBoldFont(22);
    self.titleLabel.textColor = kRGB(0x2C3E51);
    
    self.detailLabel = [[UILabel alloc] init];
    [self.view addSubview:self.detailLabel];
    self.detailLabel.text = [NSLocalizedString(@"fpt_v_code_send_to", nil) stringByAppendingString:self.phone ? : @""];
    self.detailLabel.font = kRegularFont(12);
    self.detailLabel.textColor = kRGB(0x2C3E51);
    
    self.verificationCodeView = [[FCBVerificationCodeView alloc] initWithVerificationCodeCount:6];
    self.verificationCodeView.delegate = self;
    [self.verificationCodeView becomeFirstResponder];
    [self.view addSubview:self.verificationCodeView];
    
    self.doneButton = [[FCBMainButton alloc] initWithNormalTitle:self.mainButtonTitle];
    [self.view addSubview:self.doneButton];
    self.doneButton.enabled = NO;
    [self.doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.refetchButton = [[UIButton alloc] init];
    [self.view addSubview:self.refetchButton];
    self.refetchButton.titleLabel.font = kRegularFont(14);
    [self.refetchButton setTitleColor:kRGB(0x4285F4) forState:UIControlStateNormal];
    [self.refetchButton setTitleColor:kRGB(0x9D9D9D) forState:UIControlStateDisabled];
    [self.refetchButton addTarget:self action:@selector(refetchButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutUI {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(8);
        make.left.equalTo(@(28));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(53);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.verificationCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(6);
        make.left.equalTo(@20);
        make.right.equalTo(@(-20));
        make.height.equalTo(@60);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verificationCodeView.mas_bottom).offset(25);
        make.left.equalTo(self.detailLabel);
        make.right.equalTo(@(-28));
        make.height.equalTo(@(48));
    }];
    
    [self.refetchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.doneButton.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
}

- (void)setMainButtonTitle:(NSString *)mainButtonTitle {
    _mainButtonTitle = mainButtonTitle;
    [self.doneButton setTitle:mainButtonTitle forState:UIControlStateNormal];
}

- (void)startTime {
    self.startInterval = [NSDate.date timeIntervalSince1970];
    [self performSelector:@selector(updateTime) withObject:nil afterDelay:1];
    [self updateTime];
}

- (void)updateTime {
    NSTimeInterval current = NSDate.date.timeIntervalSince1970;
    NSInteger interval = (int)(current - self.startInterval);
    if (interval >= 60) {
        self.refetchButton.enabled = YES;
        [self.refetchButton setTitle:NSLocalizedString(@"fpt_re_get_v_code", nil) forState:UIControlStateNormal];
    } else {
        self.refetchButton.enabled = NO;
        NSString *title = [NSString stringWithFormat:@"%@(%ld)",NSLocalizedString(@"fpt_re_get_v_code", nil) ,60 - interval];
        [self.refetchButton setTitle:title forState:UIControlStateNormal];
        [self performSelector:@selector(updateTime) withObject:nil afterDelay:1];
    }
}

#pragma mark - <FCBVerificationCodeDelegate>

- (void)verificationCodeDidChange:(NSString *)code {
    if (code.length == 6) {
        self.doneButton.enabled = YES;
        [self doneButtonClick];
    } else {
        self.doneButton.enabled = NO;
    }
}

#pragma mark - Action

- (void)doneButtonClick {
    self.verificationCodeCallback ? self.verificationCodeCallback(self.verificationCodeView.code) : nil;
}

- (void)refetchButtonClick {
    [self.verificationCodeView reset];
    [self startTime];
    [self sendVerificationCodeAction];
    
}

- (void)sendVerificationCodeAction {
    [FCBRequestHelper sendVerificationCodeWithType:self.type
                                             phone:self.phone
                                          areaCode:self.areaCode
                                         captchaId:self.captchaId
                                           captcha:self.captcha
                                          callback:^(BOOL isSuccess, NSString *error) {
        if (!isSuccess) {
            kHUD(NSLocalizedString(@"fpt_sms_send_fail", nil));
        }
    }];
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

@end
