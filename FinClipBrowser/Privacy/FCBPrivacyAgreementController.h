//
//  FCBPrivacyAgreementController.h
//  FinClipBrowser
//
//  Created by vchan on 2023/2/27.
//

#import <UIKit/UIKit.h>

@interface FCBPrivacyAgreementController : UIViewController

@property (nonatomic, copy) void(^clickCallback)(BOOL isAgree);

@end

