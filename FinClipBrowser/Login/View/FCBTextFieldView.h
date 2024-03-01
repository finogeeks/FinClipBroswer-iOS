//
//  FCBTextFieldView.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCBTextFieldView : UIView

- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
                   isSecurity:(BOOL)isSecurity;

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UITextField *textField;

@end

NS_ASSUME_NONNULL_END
