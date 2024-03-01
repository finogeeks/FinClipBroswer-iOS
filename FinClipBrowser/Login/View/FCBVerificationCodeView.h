//
//  FCBVerificationCodeView.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FCBVerificationCodeDelegate <UITextFieldDelegate>

@optional
- (void)verificationCodeDidChange:(NSString *)code;

@end

@interface FCBVerificationCodeView : UIView

- (instancetype)initWithVerificationCodeCount:(NSInteger)count;

@property (nonatomic, weak, nullable) id<FCBVerificationCodeDelegate> delegate;

@property (nonatomic, copy, readonly, nullable) NSString *code;

/// override becomeFirstResponder
- (BOOL)becomeFirstResponder;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
