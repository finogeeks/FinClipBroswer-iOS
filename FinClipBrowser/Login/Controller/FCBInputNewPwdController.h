//
//  FCBInputNewPwdController.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCBInputNewPwdController : UIViewController

@property (nonatomic, copy) void(^inputNewPwdCallback)(NSString *pwd);

@end

NS_ASSUME_NONNULL_END
