//
//  FCBMiniProgramModel.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCBMiniProgramModel : NSObject

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *summary;

@end

NS_ASSUME_NONNULL_END
