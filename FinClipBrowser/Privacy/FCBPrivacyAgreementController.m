//
//  FCBPrivacyAgreementController.m
//  FinClipBrowser
//
//  Created by vchan on 2023/2/27.
//

#import "FCBPrivacyAgreementController.h"
#import <Masonry/Masonry.h>
#import "FCBUITool.h"
#import "FCBDefine.h"
#import "FCBWebViewController.h"

@interface FCBPrivacyAgreementController ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *exitButton;

@end

@implementation FCBPrivacyAgreementController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.definesPresentationContext = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kRGBA(0x00000080);
    
    [self prepareUI];
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)prepareUI {
    self.contentView = [[UIView alloc] init];
    self.contentView.layer.cornerRadius = 6;
    [self.view addSubview:self.contentView];
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.text = NSLocalizedString(@"fpt_protocol_txt", nil);
    self.titleLabel.font = kBoldFont(16);
    self.titleLabel.textColor = kRGB(0x111111);
    
    self.textView = [[UITextView alloc] init];
    [self.contentView addSubview:self.textView];
    self.textView.backgroundColor = UIColor.whiteColor;
    self.textView.editable = false;
//    self.textView.scrollEnabled = false;
    self.textView.delegate = self;
    //Setting Paragraph Style
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSString *text = NSLocalizedString(@"fpt_clause_content", nil);
    NSRange range1 = [text rangeOfString:NSLocalizedString(@"fpt_service_agreement", nil)];
    NSRange range2 = [text rangeOfString:NSLocalizedString(@"fpt_privacy_policy", nil)];
    //
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:text];
    [mutAttString addAttributes:@{NSForegroundColorAttributeName:kRGB(0x333333),
                                  NSParagraphStyleAttributeName:paragraphStyle,
                                  NSFontAttributeName:kRegularFont(16)}
                          range:NSMakeRange(0, mutAttString.length)];
    //
    if (range1.location != NSNotFound) {
        [mutAttString addAttributes:@{NSForegroundColorAttributeName:kRGB(0x1C0000),
                                      NSLinkAttributeName:kAgreementLink}
                              range:range1];
    }
    if (range2.location != NSNotFound) {
        [mutAttString addAttributes:@{NSForegroundColorAttributeName:kRGB(0x1C0000),
                                      NSLinkAttributeName:kPolicyLink}
                              range:range2];
    }
    self.textView.attributedText = mutAttString;
    
    self.agreeButton = [[UIButton alloc] init];
    [self.contentView addSubview:self.agreeButton];
    self.agreeButton.layer.cornerRadius = 24;
    self.agreeButton.backgroundColor = kRGB(0x4285F4);
    self.agreeButton.titleLabel.font = kRegularFont(16);
    [self.agreeButton setTitle:NSLocalizedString(@"fpt_agree", nil) forState:UIControlStateNormal];
    [self.agreeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.agreeButton addTarget:self action:@selector(agreeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.exitButton = [[UIButton alloc] init];
    [self.contentView addSubview:self.exitButton];
    self.exitButton.titleLabel.font = kRegularFont(15);
    [self.exitButton setTitle:NSLocalizedString(@"fpt_do_not_use", nil) forState:UIControlStateNormal];
    [self.exitButton setTitleColor:kRGB(0x9B9B9B) forState:UIControlStateNormal];
    [self.exitButton addTarget:self action:@selector(exitButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutUI {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.equalTo(@(37));
        make.right.equalTo(@(-37));
        make.height.equalTo(@(386));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(@(30));
        make.left.greaterThanOrEqualTo(@(20));
        make.right.lessThanOrEqualTo(@(-20));
    }];
    
   
    
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@(20));
        make.bottom.equalTo(@(-20));
    }];
    
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(236, 48)));
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.exitButton.mas_top).offset(-10);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(18);
        make.left.equalTo(@(32));
        make.right.equalTo(@(-32));
        make.bottom.lessThanOrEqualTo(self.agreeButton.mas_top).offset(-20);
    }];
}

- (void)didTapString:(NSString *)tapString {
    if ([tapString isEqualToString:kAgreementLink] ||
        [tapString isEqualToString:kPolicyLink]) {
        FCBWebViewController *vc = [[FCBWebViewController alloc] initWithURL:tapString];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Action

- (void)exitButtonClick {
    self.clickCallback ? self.clickCallback(NO) : nil;
}

- (void)agreeButtonClick {
    self.clickCallback ? self.clickCallback(YES) : nil;
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - <UITextViewDelegate>

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    [self didTapString:URL.absoluteString];
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction  API_AVAILABLE(ios(10.0)) {
    [self didTapString:URL.absoluteString];
    return NO;
}

@end
