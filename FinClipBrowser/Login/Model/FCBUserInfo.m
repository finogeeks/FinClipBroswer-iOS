//
//  FCBUserInfo.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/7.
//

#import "FCBUserInfo.h"

@implementation FCBUserInfo


- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.jwtToken forKey:@"jwtToken"];
    [encoder encodeObject:self.refreshToken forKey:@"refreshToken"];
    [encoder encodeObject:self.env forKey:@"env"];
    [encoder encodeObject:self.role forKey:@"role"];
    [encoder encodeObject:self.accountTraceId forKey:@"accountTraceId"];
    [encoder encodeObject:self.organTraceId forKey:@"organTraceId"];
    [encoder encodeObject:self.phone forKey:@"phone"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if(self = [super init]) {
        self.jwtToken = [decoder decodeObjectForKey:@"jwtToken"];
        self.refreshToken = [decoder decodeObjectForKey:@"refreshToken"];
        self.env = [decoder decodeObjectForKey:@"env"];
        self.role = [decoder decodeObjectForKey:@"role"];
        self.accountTraceId = [decoder decodeObjectForKey:@"accountTraceId"];
        self.organTraceId = [decoder decodeObjectForKey:@"organTraceId"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
    }
    return self;
}

@end

