//
//  FCBListContentView.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/6.
//

#import "FCBListContentView.h"
#import "FCBListCollectionViewCell.h"
#import "FCBUITool.h"
#import <Masonry/Masonry.h>
#import "FCBMiniProgramModel.h"

@interface FCBListContentView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic, strong) UILabel *emptyLabel;

@property (nonatomic, strong) NSArray<FCBMiniProgramModel *> *list;

@end

@implementation FCBListContentView

- (instancetype)init {
    if (self = [super init]) {
        [self prepareUI];
        [self layoutUI];
    }
    return self;
}

- (void)prepareUI {
    self.emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_blank"]];
    [self addSubview:self.emptyImageView];
    
    self.emptyLabel = [[UILabel alloc] init];
    [self addSubview:self.emptyLabel];
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyLabel.text = NSLocalizedString(@"fpt_no_published_content", nil);
    self.emptyLabel.font = kRegularFont(14);
    self.emptyLabel.textColor = kRGB(0xB8B8B8);
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 16;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(25, 20, 25, 20);
    self.layout = layout;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.layer.cornerRadius = 8;
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self.collectionView registerClass:FCBListCollectionViewCell.class forCellWithReuseIdentifier:FCBListCollectionViewCell.description];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    
}

- (void)layoutUI {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-15);
    }];
    
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.emptyImageView.mas_bottom).offset(10);
    }];
}

- (void)setListModel:(NSArray<FCBMiniProgramModel *> *)list {
    self.list = list;
    [self.collectionView reloadData];
    
    if (self.list.count) {
        self.emptyImageView.hidden = YES;
        self.emptyLabel.hidden = YES;
        self.collectionView.hidden = NO;
    } else {
        self.emptyImageView.hidden = NO;
        self.emptyLabel.hidden = NO;
        self.collectionView.hidden = YES;
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.list.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FCBListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FCBListCollectionViewCell.description
                                                                                forIndexPath:indexPath];
    
    FCBMiniProgramModel *model = self.list[indexPath.row];
    [cell setIcon:model.logo name:model.name];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [self.delegate didSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat space = self.layout.sectionInset.left + self.layout.sectionInset.right + self.layout.minimumInteritemSpacing * 3;
    CGFloat width = (self.frame.size.width - space) / 4;
    
    return CGSizeMake(width, 84);;
}

@end
