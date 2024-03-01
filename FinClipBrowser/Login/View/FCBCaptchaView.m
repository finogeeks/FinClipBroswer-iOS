//
//  FCBCaptchaView.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/14.
//

#import "FCBCaptchaView.h"
#import "FCBUITool.h"
#import <Masonry/Masonry.h>

@interface FCBCaptchaView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *captchaButton;

@end

@implementation FCBCaptchaView

- (instancetype)init {
    if (self = [super init]) {
        [self prepareUI];
        [self layoutUI];
    }
    
    return self;
}

- (void)prepareUI {
    self.backgroundColor = UIColor.whiteColor;
    
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = NSLocalizedString(@"fpt_pic_code", nil);
    self.titleLabel.font = kRegularFont(12);
    self.titleLabel.textColor = kRGB(0x2C3E51);
    
    self.textField = [[UITextField alloc] init];
    [self addSubview:self.textField];
    self.textField.placeholder = NSLocalizedString(@"fpt_pic_code_hint", nil);
    UILabel *placeholderLabel = [self.textField valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = kRGB(0xC6C6C6);
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.font = kRegularFont(12);
    self.textField.backgroundColor = kRGB(0xFFFFFF);
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:self.textField];

    self.lineView = [[UIView alloc] init];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = kRGB(0xEAEAEA);
    
    self.captchaButton = [[UIButton alloc] init];
    [self.captchaButton addTarget:self action:@selector(captchaButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.captchaButton];
}

- (void)layoutUI {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.height.equalTo(@(25));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.left.equalTo(self);
        make.height.equalTo(@(36));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(0);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(.5);
        make.height.equalTo(@(.5));
    }];
    
    [self.captchaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(72, 34)));
        make.left.equalTo(self.textField.mas_right).offset(0);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)setImage:(UIImage *)image {
    [self.captchaButton setImage:image forState:UIControlStateNormal];
}

- (NSString *)captcha {
    return self.textField.text;
}

- (void)captchaButtonClick {
    if ([self.delegate respondsToSelector:@selector(didClickCaptcha)]) {
        [self.delegate didClickCaptcha];
    }
}

- (void)textFieldTextDidChange {
    if ([self.delegate respondsToSelector:@selector(captchaDidChange)]) {
        [self.delegate captchaDidChange];
    }
}

@end
