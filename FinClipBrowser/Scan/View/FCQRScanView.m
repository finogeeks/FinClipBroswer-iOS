//
//  FCQRScanView.m
//  FinClipBrowser
//
//  Created by vchan on 2023/2/28.
//

#import "FCQRScanView.h"

const CGFloat scannerBorderWidth = 2;
const CGFloat scannerCornerWidth = 3;
const CGFloat scannerCornerLength = 30;
const CGFloat scannerLineHeight = 3;

@interface FCQRScanView ()

@property (nonatomic, strong) UIColor *scannerBorderColor;
@property (nonatomic, strong) UIColor *scannerCornerColor;
@property (nonatomic, strong) UIImageView *scannerLine;

@property (nonatomic, assign) CGFloat scannerWidth;
@property (nonatomic, assign) CGFloat scannerX;
@property (nonatomic, assign) CGFloat scannerY;

@end

@implementation FCQRScanView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    self.backgroundColor = [UIColor clearColor];
    _scannerWidth = 250;
    _scannerX = (self.frame.size.width - _scannerWidth) / 2;
    _scannerY = (self.frame.size.height - _scannerWidth) / 2;;
    
    self.rectOfInterest = CGRectMake(_scannerY / self.frame.size.height, _scannerX / self.frame.size.width, _scannerWidth / self.frame.size.height, _scannerWidth / self.frame.size.width);
    
    self.scannerBorderColor = [UIColor clearColor];
    self.scannerCornerColor = [UIColor colorWithRed:66/255.0f green:134/255.0 blue:246/255.0 alpha:1.0];
    
    [self addSubview:self.scannerLine];
}

- (void)startAnimation {
    [self.scannerLine.layer removeAllAnimations];
    
    CABasicAnimation *lineAnimation = [CABasicAnimation  animationWithKeyPath:@"transform"];
    lineAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, _scannerWidth - scannerLineHeight, 1)];
    lineAnimation.duration = 4;
    lineAnimation.repeatCount = MAXFLOAT;
    [self.scannerLine.layer addAnimation:lineAnimation forKey:nil];
    self.scannerLine.layer.speed = 1.0;
}

- (void)pauseAnimation {
    CFTimeInterval pauseTime = [self.scannerLine.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.scannerLine.layer.timeOffset = pauseTime;
    self.scannerLine.layer.speed = 0;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    
    [[UIColor colorWithWhite:0 alpha:0.7] setFill];
    UIRectFill(rect);
    
    
    CGRect scannerRect = CGRectMake(_scannerX, _scannerY, _scannerWidth, _scannerWidth);
    [[UIColor clearColor] setFill];
    UIRectFill(scannerRect);
    
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:CGRectMake(_scannerX, _scannerY, _scannerWidth, _scannerWidth)];
    borderPath.lineCapStyle = kCGLineCapRound;
    borderPath.lineWidth = scannerBorderWidth;
    [_scannerBorderColor set];
    [borderPath stroke];
    
    for (int index = 0; index < 4; index++) {
        UIBezierPath *tempPath = [UIBezierPath bezierPath];
        tempPath.lineWidth = scannerCornerWidth;
        [_scannerCornerColor set];
        switch (index) {
            case 0:
                // Top Left Corner
                [tempPath moveToPoint:CGPointMake(_scannerX + scannerCornerLength, _scannerY)];
                [tempPath addLineToPoint:CGPointMake(_scannerX, _scannerY)];
                [tempPath addLineToPoint:CGPointMake(_scannerX, _scannerY + scannerCornerLength)];
                break;
            case 1:
                // Top Right Corner
                [tempPath moveToPoint:CGPointMake(_scannerX + _scannerWidth - scannerCornerLength, _scannerY)];
                [tempPath addLineToPoint:CGPointMake(_scannerX + _scannerWidth, _scannerY)];
                [tempPath addLineToPoint:CGPointMake(_scannerX + _scannerWidth, _scannerY + scannerCornerLength)];
                break;
            case 2:
                // Bottom Left Corner
                [tempPath moveToPoint:CGPointMake(_scannerX, _scannerY + _scannerWidth - scannerCornerLength)];
                [tempPath addLineToPoint:CGPointMake(_scannerX, _scannerY + _scannerWidth)];
                [tempPath addLineToPoint:CGPointMake(_scannerX + scannerCornerLength, _scannerY + _scannerWidth)];
                break;
            case 3:
                // Bottom Right Corner
                [tempPath moveToPoint:CGPointMake(_scannerX + _scannerWidth - scannerCornerLength, _scannerY + _scannerWidth)];
                [tempPath addLineToPoint:CGPointMake(_scannerX + _scannerWidth, _scannerY + _scannerWidth)];
                [tempPath addLineToPoint:CGPointMake(_scannerX + _scannerWidth, _scannerY + _scannerWidth - scannerCornerLength)];
                break;
        }
        [tempPath stroke];
    }
}

#pragma mark - setter && getter
- (UIImageView *)scannerLine {
    if (!_scannerLine) {
        _scannerLine = [[UIImageView alloc] initWithFrame:CGRectMake(_scannerX, _scannerY, _scannerWidth, scannerLineHeight)];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = _scannerLine.bounds;
        
        gradientLayer.colors = [NSArray arrayWithObjects:(__bridge id)UIColor.clearColor.CGColor, (__bridge id)UIColor.redColor.CGColor, (__bridge id)UIColor.clearColor.CGColor, nil];
        gradientLayer.locations = [NSArray arrayWithObjects:@0, @0.5, @1, nil];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        [_scannerLine.layer addSublayer:gradientLayer];
    }
    return _scannerLine;
}

@end
