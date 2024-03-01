//
//  FCBAreaCodeSelectController.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCBAreaCodeSelectController : UIViewController

- (instancetype)initWithAreaCode:(NSString *)areaCode countryNameCN:(NSString *)countryNameCN;

@property (nonatomic, copy) void(^selectedCallback)(NSString *areaCode, NSString *countryNameCN);

@end

NS_ASSUME_NONNULL_END
