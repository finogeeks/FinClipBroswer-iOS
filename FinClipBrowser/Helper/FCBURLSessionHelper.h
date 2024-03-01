//
//  FCBURLSessionHelper.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_OPTIONS(NSUInteger, FCBRequestMethod) {
    FCBRequestMethodGet,
    FCBRequestMethodPost,
    FCBRequestMethodPut
};


@interface FCBURLSessionHelper : NSObject

+ (void)requestUrl:(NSString *)url
            method:(FCBRequestMethod)method
            params:( NSDictionary * _Nullable )params
 completionHandler:(void (^)( NSDictionary * _Nullable responseObject,   NSString * _Nullable error))completionHandler;

+ (void)requestUrl:(NSString *)url
             queue:(dispatch_queue_t _Nullable)queue
            method:(FCBRequestMethod)method
            params:( NSDictionary * _Nullable )params
 completionHandler:(void (^)( NSDictionary * _Nullable responseObject,   NSString * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
