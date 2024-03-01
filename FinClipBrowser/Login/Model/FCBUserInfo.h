//
//  FCBUserInfo.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCBUserInfo : NSObject <NSCoding>

@property (nonatomic, copy) NSString *accountTraceId;
@property (nonatomic, copy) NSString *organTraceId;//Enterprise Login
@property (nonatomic, copy) NSString *traceId;//Operator Login

@property (nonatomic, copy) NSString *jwtToken;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) NSInteger jwtTokenExpireTime;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *env;//mop-uat
@property (nonatomic, copy) NSString *role;//person
@property (nonatomic, assign) NSInteger organExpireTime;

@end

NS_ASSUME_NONNULL_END
