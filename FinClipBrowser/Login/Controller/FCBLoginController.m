//
//  FCBLoginController.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/2.
//

#import "FCBLoginController.h"
#import <Masonry/Masonry.h>
#import "FCBUITool.h"
#import "FCBDefine.h"
#import "FCBConfigServerController.h"
#import "FCBMainController.h"
#import "FCBURLSessionHelper.h"
#import "NSString+FCBExtension.h"
#import "FCBUserInfo.h"
#import <YYModel/YYModel.h>
#import "FCBAPP.h"
#import "FCBAccountLoginController.h"
#import "FCBSMSLoginController.h"
#import "FCBNavigationController.h"

@interface FCBLoginController ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *loginLabel;

@property (nonatomic, strong) UIButton *configServerButton;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *smsLoginButton;
@property (nonatomic, strong) UIButton *accountLoginButton;

@end

@implementation FCBLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareUI];
    [self layoutUI];
}

- (void)prepareUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg"]];
    [self.view addSubview:self.bgImageView];
    //
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo_full"]];
    [self.view addSubview:self.iconImageView];
    //
    self.loginLabel = [[UILabel alloc] init];
    [self.view addSubview:self.loginLabel];
    self.loginLabel.font = kBoldFont(30);
    self.loginLabel.textColor = kRGB(0x2C3E51);
    //
    self.configServerButton = [[UIButton alloc] init];
    [self.view addSubview:self.configServerButton];
    self.configServerButton.titleLabel.font = kRegularFont(15);
    [self.configServerButton setTitle:NSLocalizedString(@"fpt_config_ser", nil) forState:UIControlStateNormal];
    [self.configServerButton setTitleColor:kRGB(0x9A9EA5) forState:UIControlStateNormal];
    [self.configServerButton addTarget:self action:@selector(configServerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.switchButton = [[UIButton alloc] init];
    [self.view addSubview:self.switchButton];
    self.switchButton.titleLabel.font = kRegularFont(13);
    [self.switchButton setImage:[UIImage imageNamed:@"login_switch"] forState:UIControlStateNormal];
    [self.switchButton setTitleColor:kRGB(0x9A9EA5) forState:UIControlStateNormal];
    [self.switchButton addTarget:self action:@selector(switchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.smsLoginButton = [[UIButton alloc] init];
    [self.view addSubview:self.smsLoginButton];
    self.smsLoginButton.backgroundColor = kRGB(0xFFFFFF);
    self.smsLoginButton.layer.cornerRadius = 24;
    self.smsLoginButton.layer.borderColor = kRGB(0xEEF0F2).CGColor;
    self.smsLoginButton.layer.borderWidth = 1;
    self.smsLoginButton.titleLabel.font = kRegularFont(15);
    [self.smsLoginButton setTitle:NSLocalizedString(@"fpt_sms_login", nil) forState:UIControlStateNormal];
    [self.smsLoginButton setTitleColor:kRGB(0x888C93) forState:UIControlStateNormal];
    [self.smsLoginButton addTarget:self action:@selector(smsLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.accountLoginButton = [[UIButton alloc] init];
    [self.view addSubview:self.accountLoginButton];
    self.accountLoginButton.backgroundColor = kRGB(0xFFFFFF);
    self.accountLoginButton.layer.cornerRadius = 24;
    self.accountLoginButton.titleLabel.font = kRegularFont(15);
    [self.accountLoginButton setTitle:NSLocalizedString(@"fpt_account_login", nil) forState:UIControlStateNormal];
    [self.accountLoginButton setTitleColor:kRGB(0x888C93) forState:UIControlStateNormal];
    [self.accountLoginButton addTarget:self action:@selector(accountLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutUI {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@28);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(115);
    }];
    
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(27);
    }];
    
    [self.configServerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-28));
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(15);
    }];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView);
        make.top.equalTo(self.loginLabel.mas_bottom).offset(6);
    }];
    //
   
    
    [self.accountLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@28);
        make.right.equalTo(@(-28));
        make.height.equalTo(@48);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-24);
    }];
    
    [self.smsLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@28);
        make.right.equalTo(@(-28));
        make.height.equalTo(@48);
        make.bottom.equalTo(self.accountLoginButton.mas_top).offset(-12);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self updateUI];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleDefault;
}

- (void)updateUI {
    if (FCBAPP.shared.isOperationLogin) {
        self.loginLabel.text = NSLocalizedString(@"fpt_op_login", nil);
        [self.switchButton setTitle:NSLocalizedString(@"fpt_switch_ee_login", nil) forState:UIControlStateNormal];
    } else {
        self.loginLabel.text = NSLocalizedString(@"fpt_enterprise_login", nil);
        [self.switchButton setTitle:NSLocalizedString(@"fpt_switch_op_login", nil) forState:UIControlStateNormal];
    }
    
    if (!FCBAPP.shared.isOperationLogin && FCBAPP.shared.isUATEnvironment) {
        self.smsLoginButton.hidden = NO;
        self.accountLoginButton.hidden = NO;
        
        self.accountLoginButton.backgroundColor = kRGB(0xFFFFFF);
        self.accountLoginButton.titleLabel.font = kRegularFont(15);
        [self.accountLoginButton setTitle:NSLocalizedString(@"fpt_account_login", nil) forState:UIControlStateNormal];
        [self.accountLoginButton setTitleColor:kRGB(0x888C93) forState:UIControlStateNormal];
        
//        [self.accountLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.smsLoginButton.mas_right).offset(9);
//            make.right.equalTo(@(-28));
//            make.bottom.height.width.equalTo(self.smsLoginButton);
//        }];
    } else {
        self.smsLoginButton.hidden = YES;
        self.accountLoginButton.hidden = NO;
        
        self.accountLoginButton.backgroundColor = kRGB(0x4285F4);
        self.accountLoginButton.titleLabel.font = kRegularFont(16);
        [self.accountLoginButton setTitle:NSLocalizedString(@"fpt_account_password_login", nil) forState:UIControlStateNormal];
        [self.accountLoginButton setTitleColor:kRGB(0xFFFFFF) forState:UIControlStateNormal];
        
//        [self.accountLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@28);
//            make.right.equalTo(@(-28));
//            make.height.equalTo(@48);
//            make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-24);
//        }];
    }
}

- (void)loginWithToken:(NSString *)token {
    NSString *serverUrl = FCBAPP.shared.serverUrl;
    NSString *urlString = [serverUrl stringByAppendingFormat:@"%@%@",API_PREFIX_V2, kOrganLogin];
    NSDictionary *params = @{
        @"carrier" : FCBAPP.shared.carrierName,
        @"from" : @"app",
        @"type" : @"oneClick",
        @"oneClickToken" : token ? : @"",
        @"account" : @"",
        @"areaCode" : @"",
        @"verifyCode" : @"",
    };
    kShowLoading;
    [FCBURLSessionHelper requestUrl:urlString
                              method:FCBRequestMethodPost
                              params:params
                   completionHandler:^(NSDictionary *responseObject, NSString *error) {
        kHideLoading;
        if (error == nil && [responseObject isKindOfClass:NSDictionary.class]) {
            FCBUserInfo *info = [FCBUserInfo yy_modelWithJSON:responseObject[@"data"]];
            [FCBAPP.shared loginWithUserInfo:info];
            
            NSString *account = FCBAPP.shared.userInfo.phone.fcb_DESDecrypt;
            FCBAPP.shared.account = account;
            
            [self dismissViewControllerAnimated:NO completion:nil];
            [self.navigationController setViewControllers:@[FCBMainController.new] animated:NO];
        } else {
            kHUD(NSLocalizedString(@"fpt_login_err", nil));
        }
    }];
}

#pragma mark - Action

- (void)configServerButtonClick {
    FCBConfigServerController *vc = [[FCBConfigServerController alloc] init];
    FCBNavigationController *nav = [[FCBNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)switchButtonClick {
    FCBAPP.shared.isOperationLogin = !FCBAPP.shared.isOperationLogin;
    [self updateUI];
}

- (void)smsLoginButtonClick {
    FCBSMSLoginController *vc = [[FCBSMSLoginController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)accountLoginButtonClick {
    FCBAccountLoginController *vc = [[FCBAccountLoginController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

