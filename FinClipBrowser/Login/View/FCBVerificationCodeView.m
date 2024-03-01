//
//  FCBVerificationCodeView.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/13.
//

#import "FCBVerificationCodeView.h"
#import <Masonry/Masonry.h>
#import "FCBUITool.h"

@class FCBVerificationCodeTextField;

@protocol FCBVerificationCodeTextFieldDelegate <UITextFieldDelegate>

@optional
- (void)verificationCodeTextFieldDeleteBackward:(FCBVerificationCodeTextField *)textField;

@end

@interface FCBVerificationCodeTextField : UITextField <UITextFieldDelegate>

@property (nullable, nonatomic, weak) id<FCBVerificationCodeTextFieldDelegate> verificationCodeDelegate;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation FCBVerificationCodeTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = kRGB(0xFFFFFF);
    self.textColor = kRGB(0x333333);
    self.font = kMediumFont(25);
    
    if (@available(iOS 12.0, *)) {
        self.textContentType = UITextContentTypeOneTimeCode;
    }
    
    self.lineView = [[UIView alloc] init];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = kRGB(0xEAEAEA);
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(.5));
    }];
}

- (void)deleteBackward {
    if (self.text.length) {
        [super deleteBackward];
    } else if ([self.verificationCodeDelegate respondsToSelector:@selector(verificationCodeTextFieldDeleteBackward:)]) {
        [self.verificationCodeDelegate verificationCodeTextFieldDeleteBackward:self];
    }
}

@end


/// ######
/// FCBVerificationCodeView
@interface FCBVerificationCodeView () <UITextFieldDelegate, FCBVerificationCodeTextFieldDelegate>

@property (nonatomic, strong) NSArray<FCBVerificationCodeTextField *> *list;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, assign) NSInteger count;

@end

@implementation FCBVerificationCodeView

- (instancetype)initWithVerificationCodeCount:(NSInteger)count {
    if (self = [super init]) {
        self.count = count;
        
        [self prepareUI];
        [self layoutUI];
    }
    return self;
}

- (void)prepareUI {
    self.backgroundColor = UIColor.whiteColor;
    
    NSMutableArray *array = NSMutableArray.array;
    for (int i = 0; i < self.count; i++) {
        FCBVerificationCodeTextField *view = [[FCBVerificationCodeTextField alloc] init];
        view.delegate = self;
        view.verificationCodeDelegate = self;
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(textFieldTextDidChangeNotification:)
                                                   name:UITextFieldTextDidChangeNotification
                                                 object:view];
        [array addObject:view];
    }
    self.list = array.copy;
    
    self.stackView = [[UIStackView alloc] initWithArrangedSubviews:self.list];
    self.stackView.distribution = UIStackViewDistributionEqualSpacing;
    [self addSubview:self.stackView];
}

- (void)layoutUI {
    [self.list mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
    }];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (NSString *)code {
    NSString *code = @"";
    for (int i = 0; i < self.list.count; i++) {
        if (self.list[i].text) {
            code = [code stringByAppendingString:self.list[i].text];
        }
    }
    return code;
}

- (void)textFieldDidInput {
    if ([self.delegate respondsToSelector:@selector(verificationCodeDidChange:)]) {
        [self.delegate verificationCodeDidChange:self.code];
    }
}

- (void)textFieldTextDidChange:(FCBVerificationCodeTextField *)textField {
    if (textField.text.length > 0) {
        NSString *text = textField.text;
        textField.text = [text substringToIndex:1];
        
        NSUInteger index = [self.list indexOfObject:textField];
        if ((index < self.list.count - 1) && (text.length > 1)) {
            text = [text substringFromIndex:1];
            if (text.length) {
                self.list[index + 1].text = text;
                [self textFieldTextDidChange:self.list[index + 1]];
            }
        }
    }
    [self becomeFirstResponder];
    [self textFieldDidInput];
}

- (void)reset {
    for (int i = 0; i < self.list.count; i++) {
        self.list[i].text = nil;
    }
    [self becomeFirstResponder];
}

#pragma mark - <NSNotificationCenter>

- (void)textFieldTextDidChangeNotification:(NSNotification *)noti {
    FCBVerificationCodeTextField *textField = noti.object;
    [self textFieldTextDidChange:textField];
}

#pragma mark - <UITextFieldDelegate>

- (void)verificationCodeTextFieldDeleteBackward:(FCBVerificationCodeTextField *)textField {
    if (textField.text.length == 0) {
        NSUInteger index = [self.list indexOfObject:textField];
        if (index != NSNotFound && index > 0) {
            self.list[index - 1].text = nil;
            [self.list[index - 1] becomeFirstResponder];
        }
    }
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self becomeFirstResponder];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

#pragma mark - hitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view) {
        return self;
    }
    return view;
}

#pragma mark -

- (BOOL)becomeFirstResponder {
    NSInteger count = self.list.count;
    if (count == 0) {
        return [super becomeFirstResponder];
    }
    
    for (int i = 0; i < count; i++) {
        if (self.list[i].text.length == 0) {
            return [self.list[i] becomeFirstResponder];
        }
    }
    
    return [self.list.lastObject becomeFirstResponder];
}

@end
