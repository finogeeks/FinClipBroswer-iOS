//
//  NSString+FCBExtension.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/6.
//

#import "NSString+FCBExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (FCBExtension)

- (NSString *)fcb_md5 {
    const char *cStr = [self UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    uint32_t length = (uint32_t)self.length;
    CC_MD5(cStr, length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

- (NSString *)fcb_DESEncrypt {
    NSString *key = @"w$D5%8x@";
    
    char keyPtr[kCCKeySizeDES + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    size_t bufferSize = data.length + kCCKeySizeDES;
    char buffer[bufferSize];
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptorStatus = CCCrypt(kCCEncrypt,
                                            kCCAlgorithmDES,
                                            kCCOptionPKCS7Padding | kCCOptionECBMode,
                                            keyPtr,
                                            kCCKeySizeDES,
                                            NULL,
                                            data.bytes,
                                            data.length,
                                            buffer,
                                            bufferSize,
                                            &numBytesEncrypted);
    if (cryptorStatus == kCCSuccess) {
        NSString *cryptorText = @"";
        for (int i = 0; i < numBytesEncrypted; i++) {
            cryptorText = [cryptorText stringByAppendingFormat:@"%02x",(uint8_t)buffer[i]];
        }
        return cryptorText;
    }
    return @"";
}

- (NSString *)fcb_DESDecrypt {
    NSString *key = @"w$D5%8x@";
    
    char keyPtr[kCCKeySizeDES + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    for (int i = 0; i < self.length; i += 2) {
        NSString *subStr = [self substringWithRange:NSMakeRange(i, 2)];
        NSScanner *scanner = [NSScanner scannerWithString:subStr];
        unsigned int hexValue;
        [scanner scanHexInt:&hexValue];
        [data appendBytes:&hexValue length:sizeof(unsigned char)];
    }
    
    size_t bufferSize = data.length + kCCKeySizeDES;
    char buffer[bufferSize];
    bzero(buffer, sizeof(buffer));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptorStatus = CCCrypt(kCCDecrypt,
                                            kCCAlgorithmDES,
                                            kCCOptionPKCS7Padding | kCCOptionECBMode,
                                            keyPtr,
                                            kCCKeySizeDES,
                                            NULL,
                                            data.bytes,
                                            data.length,
                                            buffer,
                                            bufferSize,
                                            &numBytesEncrypted);
    if (cryptorStatus == kCCSuccess) {
        NSString *cryptorText = [NSString stringWithUTF8String:buffer];
        return cryptorText;
    }
    return @"";
}

- (NSString *)fcb_sha256 {
    const char *string = [self UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(string, (CC_LONG)strlen(string), result);
    
    NSMutableString *hashed = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hashed appendFormat:@"%02x", result[i]];
    }
    return hashed;
}

- (NSString *)fcb_passwordEncrypt {
    NSString *sha256 = self.fcb_sha256.fcb_sha256;
    NSString *md5_sha256 = self.fcb_md5.fcb_sha256.fcb_sha256;
    
    return [NSString stringWithFormat:@"%@_%@", sha256, md5_sha256];
}

- (NSString *)fcb_base64Encode {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)fcb_base64Decode {
    NSData *data = [self fcb_base64DecodeWithData];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSData *)fcb_base64DecodeWithData {
    return [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
}


@end
