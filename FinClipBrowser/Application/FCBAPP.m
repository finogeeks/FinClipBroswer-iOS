//
//  FCBAPP.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/8.
//

#import "FCBAPP.h"
#import "FCBUserInfo.h"
#import "FCBURLSessionHelper.h"
#import "FCBUITool.h"
#import "FCBDefine.h"
#import <FinApplet/FinApplet.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "NSString+FCBExtension.h"

NSString * const kFCBConfigServerURLKey = @"kFCBConfigServerURLKey";
NSString * const kFCBEnvironmentURLKey = @"kFCBEnvironmentURLKey";
NSString * const kFCBUserInfoKey = @"kFCBUserInfoKey";
NSString * const kFCBIsOperateLoginKey = @"kFCBIsOperateLoginKey";
NSString * const kFCBAccountKey = @"kFCBAccountKey";

@interface FCBAPP ()

@property (nonatomic, strong) FCBUserInfo *userInfo;

@end

@implementation FCBAPP

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self customInit];
    }
    return self;
}
- (void)customInit {
    _serverUrl = [NSUserDefaults.standardUserDefaults stringForKey:kFCBConfigServerURLKey];
    _env = [NSUserDefaults.standardUserDefaults stringForKey:kFCBEnvironmentURLKey];
    _account = [NSUserDefaults.standardUserDefaults stringForKey:kFCBAccountKey];
    
    NSData *data = [NSUserDefaults.standardUserDefaults objectForKey:kFCBUserInfoKey];
    if ([data isKindOfClass:NSData.class]) {
        _userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    _isOperationLogin = [NSUserDefaults.standardUserDefaults boolForKey:kFCBIsOperateLoginKey];
    
    //
    UIButton.appearance.adjustsImageWhenHighlighted = NO;
}

- (void)loginWithUserInfo:(FCBUserInfo *)userInfo {
    self.userInfo = userInfo;
    
    [self refreshTokenAfter:0];
}

- (void)clearUserInfo {
    self.userInfo = nil;
    self.account = @"";
}

- (void)logout {
    [FATClient.sharedClient clearLocalApplets];
    [self clearUserInfo];
}

#pragma mark - private

- (void)refreshTokenAfter:(NSInteger)interval {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_refreshToken) object:nil];
    [self performSelector:@selector(_refreshToken) withObject:nil afterDelay:interval];
}

- (void)_refreshToken {
    NSString *refreshTokenUrl = [self.serverUrl stringByAppendingFormat:@"%@%@",API_PREFIX_V1, kRefreshToken];
    NSString *refreshToken = self.userInfo.refreshToken;
    if (refreshToken.length == 0) {
        return;
    }
    
    [FCBURLSessionHelper requestUrl:refreshTokenUrl
                              method:FCBRequestMethodPost
                              params:@{@"refreshToken" : refreshToken}
                   completionHandler:^(NSDictionary *responseObject, NSString *error) {
        //NSString *userId = responseObject[@"data"][@"userId"];
        NSString *refreshToken = responseObject[@"data"][@"refreshToken"];
        NSString *jwtToken = responseObject[@"data"][@"jwtToken"];
        NSInteger expireTime = [responseObject[@"data"][@"expireTime"] intValue];
        
        FCBUserInfo *info = self.userInfo;
        info.refreshToken = refreshToken;
        info.jwtToken = jwtToken;
        info.jwtTokenExpireTime = expireTime;
        self.userInfo = info;
        
        [self refreshTokenAfter:expireTime / 60];
    }];
}

#pragma mark - @property

- (void)setUserInfo:(FCBUserInfo *)userInfo {
    _userInfo = userInfo;
    
    NSData *data = nil;
    if (userInfo) {
        data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    }
    [NSUserDefaults.standardUserDefaults setObject:data forKey:kFCBUserInfoKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)setServerUrl:(NSString *)serverUrl {
    _serverUrl = serverUrl;
    [NSUserDefaults.standardUserDefaults setValue:serverUrl forKey:kFCBConfigServerURLKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)setEnv:(NSString *)env {
    _env = env;
    [NSUserDefaults.standardUserDefaults setValue:env forKey:kFCBEnvironmentURLKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)setIsOperationLogin:(BOOL)isOperationLogin {
    _isOperationLogin = isOperationLogin;
    [NSUserDefaults.standardUserDefaults setBool:isOperationLogin forKey:kFCBIsOperateLoginKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)setAccount:(NSString *)account {
    _account = account;
    [NSUserDefaults.standardUserDefaults setValue:account forKey:kFCBAccountKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

#pragma mark -

- (NSString *)carrierName {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    return carrier.carrierName ? : @"";
}

- (BOOL)isUATEnvironment {
    return [self.env isEqualToString:@"mop-uat"];
}

@end
