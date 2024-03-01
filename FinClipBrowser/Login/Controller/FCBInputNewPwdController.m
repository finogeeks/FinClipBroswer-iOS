//
//  FCBInputNewPwdController.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/10.
//

#import "FCBInputNewPwdController.h"
#import "FCBMainButton.h"
#import "FCBTextFieldView.h"
#import "FCBUITool.h"
#import <Masonry/Masonry.h>

@interface FCBInputNewPwdController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) FCBTextFieldView *passwordView;
@property (nonatomic, strong) UILabel *passwordCountLabel;

@property (nonatomic, strong) FCBTextFieldView *confirmView;
@property (nonatomic, strong) UILabel *confirmCountLabel;

@property (nonatomic, strong) FCBMainButton *resetPasswordButton;

@end

@implementation FCBInputNewPwdController

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
    self.titleLabel.text = NSLocalizedString(@"fpt_enter_new_psd", nil);
    self.titleLabel.font = kBoldFont(22);
    self.titleLabel.textColor = kRGB(0x2C3E51);
    
    self.passwordView = [[FCBTextFieldView alloc] initWithTitle:NSLocalizedString(@"fpt_new_psd", nil) placeholder:NSLocalizedString(@"fpt_rule_psd", nil) isSecurity:YES];
    [self.view addSubview:self.passwordView];
    self.passwordView.textField.delegate = self;
    self.passwordView.textField.returnKeyType = UIReturnKeyNext;
    [self.passwordView.textField becomeFirstResponder];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:self.passwordView.textField];
    
    self.passwordCountLabel = [[UILabel alloc] init];
    [self.view addSubview:self.passwordCountLabel];
    self.passwordCountLabel.font = kRegularFont(12);
    self.passwordCountLabel.textColor = kRGB(0x9A9EA5);
    
    self.confirmView = [[FCBTextFieldView alloc] initWithTitle:NSLocalizedString(@"fpt_sure_psd", nil) placeholder:NSLocalizedString(@"fpt_again_psd", nil) isSecurity:YES];
    [self.view addSubview:self.confirmView];
    self.confirmView.textField.delegate = self;
    self.confirmView.textField.returnKeyType = UIReturnKeyDone;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:self.confirmView.textField];
    
    self.confirmCountLabel = [[UILabel alloc] init];
    [self.view addSubview:self.confirmCountLabel];
    self.confirmCountLabel.font = kRegularFont(12);
    self.confirmCountLabel.textColor = kRGB(0x9A9EA5);
    
    self.resetPasswordButton = [[FCBMainButton alloc] initWithNormalTitle:NSLocalizedString(@"fpt_reset_psd", nil)];
    [self.view addSubview:self.resetPasswordButton];
    [self.resetPasswordButton addTarget:self action:@selector(resetPasswordButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutUI {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(8);
        make.left.equalTo(@(28));
    }];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(26);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(@(-26));
    }];
    
    [self.passwordCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom).offset(0);
        make.right.equalTo(self.passwordView);
    }];
    
    [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom).offset(20);
        make.left.right.equalTo(self.passwordView);
    }];
    
    [self.confirmCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmView.mas_bottom).offset(0);
        make.right.equalTo(self.confirmView);
    }];
    
    [self.resetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmView.mas_bottom).offset(32);
        make.left.right.equalTo(self.confirmView);
        make.height.equalTo(@(48));
    }];
}

#pragma mark - Action

- (void)resetPasswordButtonClick {
    NSString *pwd = self.passwordView.textField.text;
    NSString *confirm = self.confirmView.textField.text;
    
    if (![pwd isEqualToString:confirm]) {
        kHUD(NSLocalizedString(@"fpt_psd_two_no_same", nil));
        return;
    }
    
    NSString *pattern = @"^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,20}$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray<NSTextCheckingResult *> *result = [regex matchesInString:pwd options:0 range:NSMakeRange(0, pwd.length)];
    if (!result.count) {
        kHUD(NSLocalizedString(@"fpt_psd_type_err", nil));
        return;
    }
    
    self.inputNewPwdCallback ? self.inputNewPwdCallback(confirm) : nil;
}

#pragma mark - <NSNotificationCenter>

- (void)textFieldTextDidChange {
    BOOL enabled = self.passwordView.textField.text.length > 0 && self.confirmView.textField.text.length > 0;
    self.resetPasswordButton.enabled = enabled;
    
    self.passwordCountLabel.text = [NSString stringWithFormat:@"%zd/20", self.passwordView.textField.text.length];
    self.confirmCountLabel.text = [NSString stringWithFormat:@"%zd/20", self.confirmView.textField.text.length];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordView.textField) {
        [self.confirmView.textField becomeFirstResponder];
    } else if (textField == self.confirmView.textField) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resetPasswordButtonClick];
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
