//
//  AppDelegate.m
//  FinClipBrowser
//
//  Created by vchan on 2023/2/27.
//

#import "AppDelegate.h"
#import "FCBPrivacyAgreementController.h"
#import "FCBMainController.h"
#import "FCBLoginController.h"
#import "FCBConfigServerController.h"
#import "FCBDefine.h"
#import "FCBURLSessionHelper.h"
#import "FCBAPP.h"
#import "FCBNavigationController.h"

static NSString * const kFCBIsAgreePrivacyAgreementKey = @"kFCBIsAgreePrivacyAgreementKey";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    __kindof UIViewController *root = nil;
    
    NSString *serverUrl = FCBAPP.shared.serverUrl;
    if (serverUrl.length) {
        if (FCBAPP.shared.userInfo.jwtToken.length) {
            __block BOOL isAutoLogin = NO;
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            
            NSString *urlString = [API_PREFIX_V1 stringByAppendingString:kTestJwtValid];
            [FCBURLSessionHelper requestUrl:urlString
                                      queue:dispatch_queue_create("FCB.TestJwtValid.Queue", DISPATCH_QUEUE_SERIAL)
                                     method:FCBRequestMethodGet
                                     params:nil
                          completionHandler:^(NSDictionary *responseObject, NSString *error) {
                if (error == nil && [responseObject isKindOfClass:NSDictionary.class]) {
                    NSString *result = responseObject[@"data"][@"result"];
                    if ([result isEqualToString:@"OK"]) {
                        isAutoLogin = YES;
                    }
                }
                dispatch_semaphore_signal(semaphore);
            }];
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));
            dispatch_semaphore_wait(semaphore, time);
            
            if (isAutoLogin) {
                root = [[FCBMainController alloc] init];
                [FCBAPP.shared refreshTokenAfter:0];
            } else {
                [FCBAPP.shared clearUserInfo];
                root = [[FCBLoginController alloc] init];
            }
        } else {
            root = [[FCBLoginController alloc] init];
        }
    } else {
        root = [[FCBConfigServerController alloc] init];
    }
    
    //
    FCBNavigationController *nav = [[FCBNavigationController alloc] initWithRootViewController:root];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    //
    [self showPrivacyAgreementControllerIfNeed];
    
    return YES;
}

#pragma mark - Private

- (void)showPrivacyAgreementControllerIfNeed {
    BOOL isAgreed = [NSUserDefaults.standardUserDefaults boolForKey:kFCBIsAgreePrivacyAgreementKey];
    if (!isAgreed) {
        FCBPrivacyAgreementController *privacyAgreementVC = [[FCBPrivacyAgreementController alloc] init];
        privacyAgreementVC.clickCallback = ^(BOOL isAgree) {
            if (isAgree) {
                [NSUserDefaults.standardUserDefaults setBool:YES forKey:kFCBIsAgreePrivacyAgreementKey];
            } else {
                exit(0);
            }
        };
        UIViewController *rootVC = self.window.rootViewController;
        FCBNavigationController *nav = [[FCBNavigationController alloc] initWithRootViewController:privacyAgreementVC];
        nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        nav.definesPresentationContext = YES;
        [rootVC presentViewController:nav animated:NO completion:nil];
    }
}

@end
