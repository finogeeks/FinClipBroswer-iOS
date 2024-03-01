//
//  FCBPhoneTextFieldView.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCBPhoneTextFieldView : UIView

- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
                     areaCode:(NSString *)areaCode;

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UITextField *textField;
@property (nonatomic, strong, readonly) UIButton *areaCodeButton;

@property (nonatomic, copy) NSString *areaCode;

@end

NS_ASSUME_NONNULL_END
