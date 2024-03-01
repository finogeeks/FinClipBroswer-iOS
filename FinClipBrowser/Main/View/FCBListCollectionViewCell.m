//
//  FCBListCollectionViewCell.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/6.
//

#import "FCBListCollectionViewCell.h"
#import "FCBUITool.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "FCBUITool.h"

@interface FCBListCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FCBListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
        [self layoutUI];
    }
    return self;
}

- (void)prepareUI {
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_button_fc"]];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.backgroundColor = kRGB(0xF5F5F5);
    self.iconImageView.layer.cornerRadius = 8;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.borderWidth = .5;
    self.iconImageView.layer.borderColor = kRGBA(0x0000001A).CGColor;
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = NSLocalizedString(@"fpt_explore_with_mini_program", nil);
    self.titleLabel.font = kRegularFont(13);
    self.titleLabel.textColor = kRGB(0x333333);
}

- (void)layoutUI {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.contentView);
        make.size.equalTo(@(CGSizeMake(54, 54)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-2);
    }];
}

- (void)setIcon:(NSString *)icon name:(NSString *)name {
    NSString *url = [FCBUITool logoUrl:icon];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    self.titleLabel.text = name;
}

@end
