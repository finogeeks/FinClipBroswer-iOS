//
//  FCBTextFieldView.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/9.
//

#import "FCBTextFieldView.h"
#import "FCBUITool.h"
#import <Masonry/Masonry.h>

@interface FCBTextFieldView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *securityButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL isSecurity;

@end

@implementation FCBTextFieldView

- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
                   isSecurity:(BOOL)isSecurity {
    if (self = [super init]) {
        self.title = title;
        self.placeholder = placeholder;
        self.isSecurity = isSecurity;
        
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
    
    self.lineView = [[UIView alloc] init];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = kRGB(0xEAEAEA);
    
    if (self.isSecurity) {
        self.securityButton = [[UIButton alloc] init];
        [self.securityButton setImage:[UIImage imageNamed:@"login_input_show"] forState:UIControlStateNormal];
        [self.securityButton setImage:[UIImage imageNamed:@"login_input_hide"] forState:UIControlStateSelected];
        self.securityButton.selected = YES;
        self.textField.secureTextEntry = self.securityButton.selected;
        [self.securityButton addTarget:self action:@selector(securityButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.textField.rightView = self.securityButton;
        self.textField.rightViewMode = UITextFieldViewModeWhileEditing;
    }
    
}

- (void)layoutUI {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.height.equalTo(@(25));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.left.right.equalTo(self);
        make.height.equalTo(@(36));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(0);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(.5);
        make.height.equalTo(@(.5));
    }];
}

- (void)securityButtonClick {
    self.securityButton.selected = !self.securityButton.isSelected;
    
    self.textField.secureTextEntry = self.securityButton.selected;
}

@end
