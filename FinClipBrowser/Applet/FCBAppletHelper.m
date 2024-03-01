//
//  FCBAppletHelper.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/7.
//

#import "FCBAppletHelper.h"
#import "FCBDefine.h"
#import "FCBUITool.h"
#import "FCBAPP.h"

#if __has_include(<FinAppletGDMap/FinAppletGDMap.h>)
#import <FinAppletGDMap/FinAppletGDMap.h>
#endif

#if __has_include(<FinAppletBLE/FinAppletBLE.h>)
#import <FinAppletBLE/FinAppletBLE.h>
#endif

#if __has_include(<FinAppletContact/FinAppletContact.h>)
#import <FinAppletContact/FinAppletContact.h>
#endif

#if __has_include(<FinAppletClipBoard/FinAppletClipBoard.h>)
#import <FinAppletClipBoard/FinAppletClipBoard.h>
#endif

#if __has_include(<FinAppletLive/FinAppletLive.h>)
#ifdef __arm64__
#import <FinAppletLive/FinAppletLive.h>
#endif
#endif

//#if __has_include(<FinAppletShare/FinAppletShare.h>)
//#import <FinAppletShare/FinAppletShare.h>
//#endif

#if __has_include(<FinAppletAgoraRTC/FinAppletAgoraRTC.h>)
#import <FinAppletAgoraRTC/FinAppletAgoraRTC.h>
#endif

@implementation FCBAppletHelper

+ (void)initApplet {
    FATConfig *config = [self storeConfig];
    FATUIConfig *uiConfig = [self uiConfig];
    
    BOOL flag = [[FATClient sharedClient] initWithConfig:config uiConfig:uiConfig error:nil];
    if (flag) {
    } else {
    }
    
    [FATClient sharedClient].enableLog = YES;
    [[FATClient sharedClient].logManager initLogWithLogDir:nil logLevel:FATLogLevelVerbose consoleLog:YES];
    
    //
#if __has_include(<FinAppletGDMap/FinAppletGDMap.h>)
    [FATGDMapComponent setGDMapAppKey:@"your GDMap key"];
    [FATGDMapComponent setGDMapPrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain PrivacyAgreement:AMapPrivacyAgreeStatusDidAgree];
#endif
    
#if __has_include(<FinAppletBLE/FinAppletBLE.h>)
    
#endif
    
#if __has_include(<FinAppletContact/FinAppletContact.h>)
    [FATContactComponent registerComponent];
#endif

#if __has_include(<FinAppletClipBoard/FinAppletClipBoard.h>)
    [FATClipBoardComponent registerComponent];
#endif
    
#if __has_include(<FinAppletLive/FinAppletLive.h>)
#ifdef __arm64__
    [FATLiveComponent registerComponent];
#else
    NSLog(@"⚠️⚠️⚠️ FinClipLive only Supported ARM64 ⚠️⚠️⚠️");
#endif
#endif
    
#if __has_include(<FinAppletAgoraRTC/FinAppletAgoraRTC.h>)
    [FATAgoraRTCComponent registerComponent];
#endif
}

+ (FATConfig *)storeConfig {
    NSString *serverUrl = FCBAPP.shared.serverUrl;
    
    FATStoreConfig *storeConfig = [[FATStoreConfig alloc] init];
    storeConfig.sdkKey = kAppKeyUrl;
    storeConfig.sdkSecret = kAppSecretUrl;
    storeConfig.apiServer = serverUrl;
    storeConfig.cryptType = FATApiCryptTypeSM;
    storeConfig.apmServer = serverUrl;
    storeConfig.fingerprint = nil;
    storeConfig.encryptServerData = NO;
    
    FATConfig *config = [FATConfig configWithStoreConfigs:@[storeConfig]];
#ifdef DEBUG
    config.appletDebugMode = FATAppletDebugModeEnable;
#endif
    config.currentUserId = FCBAPP.shared.account;
    NSString *preferredLang = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([preferredLang isEqualToString:@"zh-Hans"] || [preferredLang isEqualToString:@"zh-Hant"] || [preferredLang isEqualToString:@"zh-Hans-CN"]) {
        config.language = FATPreferredLanguageSimplifiedChinese;
    } else {
        config.language = FATPreferredLanguageEnglish;
    }
    return config;
}

+ (FATUIConfig *)uiConfig {
    FATUIConfig *uiConfig = [[FATUIConfig alloc] init];
    uiConfig.hideForwardMenu = YES;
    uiConfig.hideShareAppletMenu = YES;
    uiConfig.useNativeLiveComponent = YES;
    return uiConfig;
}

@end
