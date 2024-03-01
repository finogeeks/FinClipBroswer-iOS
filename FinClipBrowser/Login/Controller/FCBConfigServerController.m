//
//  FCBConfigServerController.m
//  FinClipBrowser
//
//  Created by vchan on 2023/2/28.
//

#import "FCBConfigServerController.h"
#import <Masonry/Masonry.h>
#import "FCBURLSessionHelper.h"
#import "FCBQRCodeScanController.h"
#import "FCBLoginController.h"
#import "FCBUITool.h"
#import "FCBDefine.h"
#import "FCBAPP.h"

@interface FCBConfigServerController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *scanButton;
@property (nonatomic, strong) UIButton *defaultServerButton;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *manualLabel;
@property (nonatomic, strong) UILabel *scanLabel;
@property (nonatomic, strong) UILabel *defaultServerLabel;

@property (nonatomic, strong) UITextField *manualTextField;

@end

@implementation FCBConfigServerController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareUI];
    [self layoutUI];
    
    self.manualTextField.text = FCBAPP.shared.serverUrl;
    
    self.closeButton.hidden = self.navigationController.presentingViewController == nil;
    [self textFieldTextDidChange];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)prepareUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.closeButton = [[UIButton alloc] init];
    [self.view addSubview:self.closeButton];
    [self.closeButton setImage:[UIImage imageNamed:@"login_nav_close"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    [self.view addSubview:self.titleLabel];
    self.titleLabel.text = NSLocalizedString(@"fpt_server_address_prompt", nil);
    self.titleLabel.font = kBoldFont(18);
    self.titleLabel.textColor = kRGB(0x2C3E51);
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.numberOfLines = 0;
    [self.view addSubview:self.detailLabel];
    self.detailLabel.text = NSLocalizedString(@"fpt_fetch_config_prompt", nil);
    self.detailLabel.font = kRegularFont(13);
    self.detailLabel.textColor = kRGB(0x9A9EA5);
    
    self.manualLabel = [[UILabel alloc] init];
    [self.view addSubview:self.manualLabel];
    self.manualLabel.text = NSLocalizedString(@"fpt_manual_input", nil);
    self.manualLabel.font = kRegularFont(13);
    self.manualLabel.textColor = kRGB(0x2C3E51);
    
    self.manualTextField = [[UITextField alloc] init];
    [self.view addSubview:self.manualTextField];
    self.manualTextField.placeholder = NSLocalizedString(@"fpt_example_url", nil);
    UILabel *placeholderLabel = [self.manualTextField valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = kRGB(0xC6C6C6);
    placeholderLabel.font = kRegularFont(16);
    self.manualTextField.backgroundColor = kRGB(0xF2F2F2);
    self.manualTextField.textColor = kRGB(0x000000);
    self.manualTextField.layer.cornerRadius = 4;
    self.manualTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12.5, 10)];
    self.manualTextField.leftViewMode = UITextFieldViewModeAlways;
    self.manualTextField.delegate = self;
    self.manualTextField.layer.cornerRadius = 4;
    self.manualTextField.returnKeyType = UIReturnKeyDone;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:self.manualTextField];
    
    self.doneButton = [[UIButton alloc] init];
    [self.view addSubview:self.doneButton];
    self.doneButton.layer.cornerRadius = 4;
    self.doneButton.backgroundColor = kRGB(0x4285F4);
    [self.doneButton setImage:[UIImage imageNamed:@"login_input_go"] forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.scanLabel = [[UILabel alloc] init];
    [self.view addSubview:self.scanLabel];
    self.scanLabel.text = NSLocalizedString(@"fpt_scan_config", nil);
    self.scanLabel.font = kRegularFont(13);
    self.scanLabel.textColor = kRGB(0x2C3E51);
    
    self.scanButton = [[UIButton alloc] init];
    [self.view addSubview:self.scanButton];
    self.scanButton.layer.cornerRadius = 24;
    self.scanButton.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 3);
    self.scanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
    self.scanButton.backgroundColor = kRGB(0x4285F4);
    [self.scanButton setImage:[UIImage imageNamed:@"login_button_scan"] forState:UIControlStateNormal];
    [self.scanButton setTitle:NSLocalizedString(@"fpt_scan_qr_code_config_server", nil) forState:UIControlStateNormal];
    [self.scanButton addTarget:self action:@selector(scanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.defaultServerLabel = [[UILabel alloc] init];
    [self.view addSubview:self.defaultServerLabel];
    self.defaultServerLabel.text = NSLocalizedString(@"fpt_test_environment", nil);
    self.defaultServerLabel.font = kRegularFont(13);
    self.defaultServerLabel.textColor = kRGB(0x2C3E51);
    
    self.defaultServerButton = [[UIButton alloc] init];
    [self.view addSubview:self.defaultServerButton];
    self.defaultServerButton.layer.cornerRadius = 24;
    self.defaultServerButton.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 3);
    self.defaultServerButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
    self.defaultServerButton.backgroundColor = kRGB(0x4285F4);
    [self.defaultServerButton setImage:[UIImage imageNamed:@"login_button_fc"] forState:UIControlStateNormal];
    [self.defaultServerButton setTitle:NSLocalizedString(@"fpt_fin_clip_environment", nil) forState:UIControlStateNormal];
    [self.defaultServerButton addTarget:self action:@selector(defaultServerButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutUI {
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(12));
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.size.equalTo(@(CGSizeMake(32, 32)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.closeButton.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(@(28));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.manualLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(30);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.manualTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.manualLabel.mas_bottom).offset(15);
        make.left.equalTo(self.titleLabel);
        make.height.equalTo(@48);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-28));
        make.centerY.equalTo(self.manualTextField);
        make.left.equalTo(self.manualTextField.mas_right).offset(8);
        make.size.equalTo(@(CGSizeMake(48, 48)));
    }];
    
    [self.scanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.manualTextField.mas_bottom).offset(25);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanLabel.mas_bottom).offset(15);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.doneButton);
        make.height.equalTo(@48);
    }];
    
    [self.defaultServerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanButton.mas_bottom).offset(25);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.defaultServerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.defaultServerLabel.mas_bottom).offset(15);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.doneButton);
        make.height.equalTo(@48);
    }];
}

- (void)inputServerUrl:(NSString *)url {
    while ([url hasSuffix:@"/"]) {
        url = [url substringToIndex:url.length - 1];
    }
    
    kShowLoading;
    [self verifyServerUrl:url callback:^(BOOL isSuccess, NSString *env, NSString *msg) {
        kHideLoading;
        if (isSuccess) {
            FCBAPP.shared.serverUrl = url;
            FCBAPP.shared.env = env;
            if (self.closeButton.hidden) {
                FCBLoginController *vc = [[FCBLoginController alloc] init];
                [self.navigationController setViewControllers:@[vc] animated:YES];
            } else {
                [self closeButtonClick];
            }
        } else {
            kHUD(msg);
        }
    }];
}

- (void)verifyServerUrl:(NSString *)url callback:(void(^)(BOOL isSuccess, NSString *env, NSString *msg))callback {
    if (![url hasPrefix:@"http"]) {
        callback ? callback(NO, nil, NSLocalizedString(@"fpt_error_url", nil)) : nil;
        return;
    }
    
    NSString *urlString = [url stringByAppendingFormat:@"%@%@", API_PREFIX_V1, TEST_URL];
    [FCBURLSessionHelper requestUrl:urlString
                              method:FCBRequestMethodGet
                              params:nil
                   completionHandler:^(NSDictionary *responseObject, NSString *error) {
        if (error) {
            callback ? callback(NO, nil, NSLocalizedString(@"fpt_invalid_url", nil)) : nil;
            return;
        }
        
        NSString *urlString = [url stringByAppendingFormat:@"%@%@", API_PREFIX_V1, kGetEnvironmentUrl];
        [FCBURLSessionHelper requestUrl:urlString
                                  method:FCBRequestMethodGet
                                  params:nil
                       completionHandler:^(NSDictionary *responseObject, NSString *error) {
            NSString *env = responseObject[@"data"][@"env"];
            if (error || !env.length) {
                kHUD(NSLocalizedString(@"fpt_invalid_url", nil));
                return;
            }
            callback ? callback(YES, env, nil) : nil;
        }];
    }];
}

#pragma mark - Action

- (void)closeButtonClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonClick {
    [self inputServerUrl:self.manualTextField.text];
}

- (void)scanButtonClick {
    FCBQRCodeScanController *vc = [[FCBQRCodeScanController alloc] init];
    vc.callback = ^(NSString *qrCode) {
        if (qrCode.length) {
            [self inputServerUrl:qrCode];
        } else {
            kHUD(NSLocalizedString(@"fpt_qr_error_url", nil));
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)defaultServerButtonClick {
    [self inputServerUrl:kSAASServerURL];
}

#pragma mark - <NSNotificationCenter>

- (void)textFieldTextDidChange {
    self.doneButton.enabled = self.manualTextField.text.length > 0;
}

#pragma mark - <UITextFieldDelegate>


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self doneButtonClick];
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
