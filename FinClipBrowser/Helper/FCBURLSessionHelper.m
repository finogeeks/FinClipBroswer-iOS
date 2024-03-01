//
//  FCBURLSessionHelper.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/2.
//

#import "FCBURLSessionHelper.h"
#import <AFNetworking/AFNetworking.h>
#import "FCBDefine.h"
#import "FCBAPP.h"

@implementation FCBURLSessionHelper

+ (NSString *)getMethodString:(FCBRequestMethod)method {
    switch (method) {
        case FCBRequestMethodGet:
            return @"GET";
            break;
        case FCBRequestMethodPost:
            return @"POST";
            break;
        case FCBRequestMethodPut:
            return @"PUT";
            break;
    }
    return @"";
}

+ (void)requestUrl:(NSString *)url
            method:(FCBRequestMethod)method
            params:(NSDictionary *)params
 completionHandler:(void (^)(NSDictionary *, NSString *))completionHandler {
    [self requestUrl:url
               queue:nil
              method:method
              params:params
   completionHandler:completionHandler];
}

+ (void)requestUrl:(NSString *)url
             queue:(dispatch_queue_t)queue
            method:(FCBRequestMethod)method
            params:(NSDictionary *)params
 completionHandler:(void (^)(NSDictionary *, NSString *))completionHandler {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:nil];
    manager.completionQueue = queue;
    
    if (![url hasPrefix:@"http"]) {
        url = [FCBAPP.shared.serverUrl stringByAppendingString:url];
    }
    
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = [self getMethodString:method];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //
    [request setValue:kAppKeyUrl forHTTPHeaderField:@"SDK-Key"];
    [request setValue:kAppKeyUrl forHTTPHeaderField:@"mop-sdk-key"];
    
    NSString *token = FCBAPP.shared.userInfo.jwtToken;
    if (token.length) {
        NSString *authorization = [@"Bearer " stringByAppendingString:token];
        [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    }
    
    if (method != FCBRequestMethodGet && params.allKeys.count) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
        [request setHTTPBody:jsonData];
        NSString *length = [NSString stringWithFormat:@"%lu", jsonData.length];
        [request setValue:length forHTTPHeaderField:@"Content-Length"];
    }
    
    //NSLog(@"requestUrl:%@\n%@", request.URL, params);
    
    [[manager dataTaskWithRequest:request
                   uploadProgress:nil
                 downloadProgress:nil
                completionHandler:^(NSURLResponse *response, NSDictionary *responseObject, NSError *error) {
        //NSLog(@"responseObject:%@", responseObject);
        
        if (![responseObject isKindOfClass:NSDictionary.class]) {
            completionHandler ? completionHandler(nil, error.localizedDescription ? : @"response data is abnormal") : nil;
            return;
        }
        
        if (error) {
            completionHandler ? completionHandler(responseObject, responseObject[@"error"] ? : error.localizedDescription) : nil;
            return;
        }
        
        NSString *errcode = responseObject[@"errcode"];
        if ([errcode isEqualToString:@"OK"]) {
            completionHandler ? completionHandler(responseObject, nil) : nil;
        } else {
            completionHandler ? completionHandler(responseObject, responseObject[@"error"]) : nil;
        }
    }] resume];
}

@end
