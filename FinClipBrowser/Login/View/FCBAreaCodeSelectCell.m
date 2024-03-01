//
//  FCBAreaCodeSelectCell.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/15.
//

#import "FCBAreaCodeSelectCell.h"
#import "FCBUITool.h"
#import <Masonry/Masonry.h>

@interface FCBAreaCodeSelectCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *areaCodeLabel;

@end

@implementation FCBAreaCodeSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self prepareUI];
        [self layoutUI];
    }
    return self;
}

- (void)prepareUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = kRegularFont(16);
    self.titleLabel.textColor = kRGB(0x333333);
    [self.contentView addSubview:self.titleLabel];
    
    self.areaCodeLabel = [[UILabel alloc] init];
    self.areaCodeLabel.font = kRegularFont(16);
    self.areaCodeLabel.textColor = kRGB(0x666666);
    [self.contentView addSubview:self.areaCodeLabel];
}

- (void)layoutUI {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.areaCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setTitle:(NSString *)title areaCode:(NSString *)areaCode isSelect:(BOOL)isSelect {
    self.titleLabel.text = title;
    self.areaCodeLabel.text = areaCode;
    
    if (isSelect) {
        self.contentView.backgroundColor = kRGB(0xDEDEDE);
    } else {
        self.contentView.backgroundColor = kRGB(0xFFFFFF);
    }
}

@end
