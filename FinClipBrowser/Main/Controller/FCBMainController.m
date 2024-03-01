//
//  FCBMainController.m
//  FinClipBrowser
//
//  Created by vchan on 2023/2/27.
//

#import "FCBMainController.h"
#import <Masonry/Masonry.h>
#import "FCBUITool.h"
#import "FCBDefine.h"
#import "FCBLoginController.h"
#import "FCBQRCodeScanController.h"
#import "FCBListContentView.h"
#import "FCBWebViewController.h"
#import "FCBURLSessionHelper.h"
#import "FCBMiniProgramModel.h"
#import <YYModel/YYModel.h>
#import "FCBAppletHelper.h"
#import "FCBAPP.h"
#import "UIButton+FCBExtension.h"

@interface FCBMainController () <FCBListCollectionViewCellDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, strong) UIButton *instructionsButton;

@property (nonatomic, strong) FCBListContentView *listContentView;
@property (nonatomic, strong) UIImageView *operationLoginImageView;

@property (nonatomic, strong) UIButton *scanButton;
@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, strong) NSArray<FCBMiniProgramModel *> *list;

@end

@implementation FCBMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [FCBAppletHelper initApplet];
    
    [self prepareUI];
    [self layoutUI];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)prepareUI {
    self.view.backgroundColor = kRGB(0xF2F3F5);
    
    self.bgView = [[UIView alloc] init];
    [self.view addSubview:self.bgView];
    self.bgView.backgroundColor = FCBAPP.shared.isOperationLogin ? kRGB(0x27B7A2) : kRGB(0x125AFF);
    
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_logo"]];
    [self.view addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.text = NSLocalizedString(@"fpt_explore_with_mini_program",nil);
    self.titleLabel.font = kBoldFont(20);
    self.titleLabel.textColor = kRGB(0xFFFFFF);
    
    self.logoutButton = [[UIButton alloc] init];
    [self.view addSubview:self.logoutButton];
    self.logoutButton.titleLabel.font = kRegularFont(14);
    self.logoutButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 2);
    [self.logoutButton setImage:[UIImage imageNamed:@"home_logout"] forState:UIControlStateNormal];
    
    [self.logoutButton setTitle:NSLocalizedString(@"fpt_logout",nil) forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(logoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.instructionsButton = [[UIButton alloc] init];
    [self.view addSubview:self.instructionsButton];
    self.instructionsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 9);
    self.instructionsButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
    self.instructionsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    self.instructionsButton.titleLabel.font = kRegularFont(13);
    self.instructionsButton.layer.cornerRadius = 14;
    self.instructionsButton.backgroundColor = kRGBA(0x00000026);
    [self.instructionsButton setImage:[UIImage imageNamed:@"home_question"] forState:UIControlStateNormal];
    
    [self.instructionsButton setTitle:NSLocalizedString(@"fpt_usage_instruction",nil) forState:UIControlStateNormal];
    [self.instructionsButton addTarget:self action:@selector(instructionsButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //
    self.listContentView = [[FCBListContentView alloc] init];
    [self.view addSubview:self.listContentView];
    self.listContentView.delegate = self;
    self.listContentView.layer.cornerRadius = 8;
    self.listContentView.layer.masksToBounds = NO;
    self.listContentView.backgroundColor = UIColor.whiteColor;
    self.listContentView.layer.shadowColor = kRGBA(0x0000001A).CGColor;
    self.listContentView.layer.shadowOffset = CGSizeMake(0, 1);
    self.listContentView.layer.shadowOpacity = 1;
    self.listContentView.layer.shadowRadius = 3;
    
    self.operationLoginImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_cardbg"]];
    self.operationLoginImageView.contentMode = UIViewContentModeBottom;
    self.operationLoginImageView.layer.cornerRadius = 8;
    self.operationLoginImageView.layer.masksToBounds = NO;
    self.operationLoginImageView.backgroundColor = UIColor.whiteColor;
    self.operationLoginImageView.layer.shadowColor = kRGBA(0x0000001A).CGColor;
    self.operationLoginImageView.layer.shadowOffset = CGSizeMake(0, 1);
    self.operationLoginImageView.layer.shadowOpacity = 1;
    self.operationLoginImageView.layer.shadowRadius = 3;
    [self.view addSubview:self.operationLoginImageView];
    
    //
    self.scanButton = [[UIButton alloc] init];
    [self.view addSubview:self.scanButton];
    
    [self.scanButton setTitle:NSLocalizedString(@"fpt_scan_mini_program_code", nil) forState:UIControlStateNormal];
    [self.scanButton addTarget:self action:@selector(scanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (FCBAPP.shared.isOperationLogin) {
        self.scanButton.layer.cornerRadius = 65;
        self.scanButton.titleLabel.font = kRegularFont(15);
        self.scanButton.backgroundColor = kRGB(0x27B7A2);
        [self.scanButton setImage:[UIImage imageNamed:@"home_operator_scan"] forState:UIControlStateNormal];
    } else {
        self.scanButton.layer.cornerRadius = 24;
        self.scanButton.titleLabel.font = kRegularFont(16);
        self.scanButton.backgroundColor = kRGB(0x125AFF);
        [self.scanButton setImage:[UIImage imageNamed:@"login_button_scan"] forState:UIControlStateNormal];
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = infoDictionary[@"CFBundleShortVersionString"];
    NSString *appletVersion = [FATClient sharedClient].version;
    NSString *appVersionStr = NSLocalizedString(@"fpt_app_version", nil);
    NSString *sdkVersionStr = NSLocalizedString(@"fpt_sdk_version", nil);
    NSString *version = [NSString stringWithFormat:@"%@ %@ 丨 %@ %@ ",appVersionStr, appVersion,sdkVersionStr, appletVersion];
    //
    self.versionLabel = [[UILabel alloc] init];
    [self.view addSubview:self.versionLabel];
    self.versionLabel.text = version;
    self.versionLabel.font = kRegularFont(13);
    self.versionLabel.textColor = kRGB(0xB8B8B8);
    self.versionLabel.numberOfLines = 0;
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutUI {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        CGFloat top = [FCBUITool safeAreaInsets].top;
        make.height.equalTo(@(186 + top));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(18);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(14);
        make.left.equalTo(self.iconImageView);
    }];
    
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.right.equalTo(@(-20));
    }];
    
    [self.instructionsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.height.equalTo(@28);
    }];
    
    //
    [self.versionLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-12);
    }];
    
    if (FCBAPP.shared.isOperationLogin) {
        self.listContentView.hidden = YES;
        
        [self.operationLoginImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView.mas_bottom).offset(-68 + 25);
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.bottom.equalTo(self.versionLabel.mas_top).offset(-15);
        }];
        
        [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.operationLoginImageView);
            make.size.equalTo(@(CGSizeMake(130, 130)));
        }];
        [self.scanButton fcb_layoutWithTopImageAndSpace:8];
    } else {
        self.operationLoginImageView.hidden = YES;
        
        [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.versionLabel.mas_top).offset(-15);
            make.centerX.equalTo(self.view);
            make.size.equalTo(@(CGSizeMake(230, 48)));
        }];
        [self.scanButton fcb_layoutWithLeftImageAndSpace:3];
        
        [self.listContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView.mas_bottom).offset(-68 + 25);
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.bottom.equalTo(self.scanButton.mas_top).offset(-18);
        }];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //
    if (@available(iOS 11.0, *)) {
        self.bgView.layer.cornerRadius = 10;
        self.bgView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    } else {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.bgView.layer.mask = maskLayer;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -

- (void)loadData {
    if (FCBAPP.shared.isOperationLogin) {
        return;
    }
    
    NSString *serverUrl = FCBAPP.shared.serverUrl;
    NSString *miniProgramList = [serverUrl stringByAppendingFormat:@"%@%@",API_PREFIX_V1, kMiniProgramList];
    
    if (FCBAPP.shared.isUATEnvironment) {
        miniProgramList = [miniProgramList stringByAppendingString:@"?pageNo=0&pageSize=100"];
    } else {
        miniProgramList = [miniProgramList stringByAppendingString:@"?classification=published&pageNo=0&pageSize=100"];
    }
    kShowLoading;
    [FCBURLSessionHelper requestUrl:miniProgramList
                              method:FCBRequestMethodGet
                              params:nil
                   completionHandler:^(NSDictionary *responseObject, NSString *error) {
        kHideLoading;
        if (error == nil && [responseObject isKindOfClass:NSDictionary.class]) {
            NSArray *list = responseObject[@"data"][@"hot"];
            self.list = [NSArray yy_modelArrayWithClass:FCBMiniProgramModel.class json:list];
            [self.listContentView setListModel:self.list];
        }
    }];
}

#pragma mark - <FCBListCollectionViewCellDelegate>

- (void)didSelectItemAtIndex:(NSInteger)index {
    FCBMiniProgramModel *model = self.list[index];
    NSString *serverUrl = FCBAPP.shared.serverUrl;
    
    FATAppletRequest *request = [[FATAppletRequest alloc] init];
    request.appletId = model.appId;
    request.apiServer = serverUrl;
    request.transitionStyle = FATTranstionStylePush;
    [[FATClient sharedClient] startAppletWithRequest:request
                              InParentViewController:self
                                          completion:^(BOOL result, FATError *error) {
        
    } closeCompletion:^{
        
    }];
}

#pragma mark -

- (void)inputServerUrl:(NSString *)url {
    FATAppletQrCodeRequest *request = [[FATAppletQrCodeRequest alloc] init];
    request.qrCode = url;
    [[FATClient sharedClient] startAppletWithQrCodeRequest:request inParentViewController:self requestBlock:^(BOOL result, FATError *error) {
        if (result) {
            
        } else {
            NSString *msg = error.localizedDescription ? : NSLocalizedString(@"fpt_open_applet_fail", nil);
            kHUD(msg);
        }
    } completion:^(BOOL result, FATError *error) {
        
    } closeCompletion:^{
        
    }];
}

#pragma mark - Action

- (void)logoutButtonClick {
    UIAlertController *ctrl = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"fpt_confirm_logout", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"fpt_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"fpt_confirm", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [FCBAPP.shared logout];
        [self.navigationController setViewControllers:@[FCBLoginController.new] animated:NO];
    }];
    [ctrl addAction:cancel];
    [ctrl addAction:confirm];
    
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (void)instructionsButtonClick {
    FCBWebViewController *vc = [[FCBWebViewController alloc] initWithURL:kInstructionsURL];
    [self.navigationController pushViewController:vc animated:YES];
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

@end
