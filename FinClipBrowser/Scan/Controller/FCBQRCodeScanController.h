//
//  FCBQRCodeScanController.m
//  FinClipBrowser
//
//  Created by vchan on 2023/2/28.
//

#import <UIKit/UIKit.h>

@interface FCBQRCodeScanController : UIViewController

@property (nonatomic, copy) void(^callback)(NSString *qrCode);

@end

