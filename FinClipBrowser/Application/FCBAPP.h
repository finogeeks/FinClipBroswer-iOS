//
//  FCBAPP.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/8.
//

#import <Foundation/Foundation.h>
#import "FCBUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCBAPP : NSObject

+ (instancetype)shared;

@property (nonatomic, strong, readonly, nullable) FCBUserInfo *userInfo;

@property (nonatomic, strong) NSString *serverUrl;
@property (nonatomic, strong) NSString *env;//Current Environment
@property (nonatomic, assign, readonly) BOOL isUATEnvironment;
@property (nonatomic, copy) NSString *account;

/// is Operation
@property (nonatomic, assign) BOOL isOperationLogin;
/// Operation name
@property (nonatomic, strong, readonly) NSString *carrierName;

- (void)refreshTokenAfter:(NSInteger)interval;
- (void)loginWithUserInfo:(FCBUserInfo *)userInfo;
- (void)clearUserInfo;
- (void)logout;

@end

NS_ASSUME_NONNULL_END
