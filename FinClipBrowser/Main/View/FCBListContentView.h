//
//  FCBListContentView.h
//  FinClipBrowser
//
//  Created by vchan on 2023/3/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FCBMiniProgramModel;

@protocol FCBListCollectionViewCellDelegate <NSObject>

- (void)didSelectItemAtIndex:(NSInteger)index;

@end

@interface FCBListContentView : UIView

- (void)setListModel:(NSArray<FCBMiniProgramModel *> *)list;

@property (nonatomic, weak) id<FCBListCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
