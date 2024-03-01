//
//  FCBPhoneTextFieldView.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/15.
//

#import "FCBPhoneTextFieldView.h"
#import "FCBUITool.h"
#import <Masonry/Masonry.h>

@interface FCBPhoneTextFieldView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *areaCodeButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *spaceView;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholder;

@end

@implementation FCBPhoneTextFieldView

- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
                     areaCode:(NSString *)areaCode {
    if (self = [super init]) {
        self.title = title;
        self.placeholder = placeholder;
        self.areaCode = areaCode;
        [self prepareUI];
        [self layoutUI];
        
    }
    return self;
}

- (void)prepareUI {
    self.backgroundColor = UIColor.whiteColor;
    
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = self.title;
    self.titleLabel.font = kRegularFont(12);
    self.titleLabel.textColor = kRGB(0x2C3E51);
    
    self.textField = [[UITextField alloc] init];
    [self addSubview:self.textField];
    self.textField.placeholder = self.placeholder;
    UILabel *placeholderLabel = [self.textField valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = kRGB(0xC6C6C6);
    placeholderLabel.font = kRegularFont(16);
    self.textField.backgroundColor = kRGB(0xFFFFFF);
    
    self.areaCodeButton = [[UIButton alloc] init];
    self.areaCodeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    self.areaCodeButton.titleLabel.font = kRegularFont(16);
    [self.areaCodeButton setTitle:self.areaCode forState:UIControlStateNormal];
    [self.areaCodeButton setTitleColor:kRGB(0x333333) forState:UIControlStateNormal];
    [self.areaCodeButton setImage:[UIImage imageNamed:@"login_input_arrow"] forState:UIControlStateNormal];
    [self addSubview:self.areaCodeButton];
    
    self.spaceView = [[UIView alloc] init];
    [self addSubview:self.spaceView];
    self.spaceView.backgroundColor = kRGB(0xEAEAEA);
    
    self.lineView = [[UIView alloc] init];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = kRGB(0xEAEAEA);
}

- (void)layoutUI {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.height.equalTo(@(25));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.right.equalTo(self);
        make.height.equalTo(@(36));
    }];
    
    [self.areaCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.textField);
        make.right.equalTo(self.textField.mas_left).offset(-8);
        make.left.equalTo(self);
        make.width.equalTo(@(56));
    }];
    
    [self.spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.areaCodeButton.mas_right);
        make.centerY.equalTo(self.areaCodeButton);
        make.size.equalTo(@(CGSizeMake(.5, 22)));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(0);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(.5);
        make.height.equalTo(@(.5));
    }];
}

- (void)setAreaCode:(NSString *)areaCode {
    _areaCode = areaCode;
    
    [self.areaCodeButton setTitle:areaCode forState:UIControlStateNormal];
    [self.areaCodeButton.titleLabel sizeToFit];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.areaCodeButton layoutIfNeeded];
    CGSize titleSize = self.areaCodeButton.titleLabel.frame.size;
    CGSize imageSize = self.areaCodeButton.imageView.frame.size;
    CGFloat space = 2;
    self.areaCodeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width - space, 0, imageSize.width + space);
    self.areaCodeButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + space , 0, -titleSize.width - space);
}

@end
