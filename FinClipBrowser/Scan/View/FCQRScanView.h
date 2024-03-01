//
//  FCQRScanView.m
//  FinClipBrowser
//
//  Created by vchan on 2023/2/28.
//

#import <UIKit/UIKit.h>

@interface FCQRScanView : UIView

@property (nonatomic, assign) CGRect rectOfInterest;

- (void)startAnimation;
- (void)pauseAnimation;

@end

