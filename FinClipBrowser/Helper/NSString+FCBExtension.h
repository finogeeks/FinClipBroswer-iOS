//
//  NSString+FCBExtension.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FCBExtension)

- (NSString *)fcb_md5;
- (NSString *)fcb_DESEncrypt;
- (NSString *)fcb_DESDecrypt;
- (NSString *)fcb_sha256;
- (NSString *)fcb_passwordEncrypt;
- (NSString *)fcb_base64Encode;
- (NSString *)fcb_base64Decode;
- (NSData *)fcb_base64DecodeWithData;

@end

NS_ASSUME_NONNULL_END
