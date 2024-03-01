//
//  FCBAreaCodeSelectCell.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCBAreaCodeSelectCell : UITableViewCell

- (void)setTitle:(NSString *)title areaCode:(NSString *)areaCode isSelect:(BOOL)isSelect;

@end

NS_ASSUME_NONNULL_END
