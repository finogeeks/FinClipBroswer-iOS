//
//  FCBQRCodeScanController.m
//  FinClipBrowser
//
//  Created by vchan on 2023/2/28.
//

#import "FCBQRCodeScanController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <Masonry/Masonry.h>
#import "FCQRScanView.h"

@interface FCBQRCodeScanController ()<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) FCQRScanView *scanView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *lightButton;
@property (nonatomic, strong) UIButton *albumButton;

@end

@implementation FCBQRCodeScanController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareUI];
    [self layoutUI];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    [self getCameraStatus:^(BOOL granted) {
        if (granted) {
            [self initCameraSession];
        } else {
            [self showAlert:NSLocalizedString(@"fpt_use_camera_tips", nil) btnTitle:NSLocalizedString(@"fpt_confirm", nil)];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resumeScanning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self pauseScanning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - private methods

- (void)prepareUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scanView = [[FCQRScanView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scanView];
    
    self.closeButton = [[UIButton alloc] init];
    [self.view addSubview:self.closeButton];
    [self.closeButton setImage:[UIImage imageNamed:@"scan_nav_close"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.lightButton = [[UIButton alloc] init];
    [self.view addSubview:self.lightButton];
    [self.lightButton setImage:[UIImage imageNamed:@"login_nav_light"] forState:UIControlStateNormal];
    [self.lightButton addTarget:self action:@selector(lightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.albumButton = [[UIButton alloc] init];
    [self.view addSubview:self.albumButton];
    [self.albumButton setImage:[UIImage imageNamed:@"login_nav_album"] forState:UIControlStateNormal];
    [self.albumButton addTarget:self action:@selector(albumButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutUI {
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.equalTo(@0);
        make.size.equalTo(@(CGSizeMake(57, 57)));
    }];
    
    [self.lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-57);
        make.left.equalTo(@82);
        make.size.equalTo(@(CGSizeMake(55, 55)));
    }];
    
    [self.albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lightButton);
        make.right.equalTo(@(-82));
        make.size.equalTo(@(CGSizeMake(55, 55)));
    }];
}

- (void)initCameraSession {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device) { return; }
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!deviceInput) { return; }
    
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    metadataOutput.rectOfInterest = self.scanView.rectOfInterest;
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session canSetSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:deviceInput]) {
        [self.session addInput:deviceInput];
    }
    
    if ([self.session canAddOutput:metadataOutput]) {
        [self.session addOutput:metadataOutput];
    }
    
    metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    videoPreviewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:videoPreviewLayer atIndex:0];
    
    [self.session startRunning];
}

- (void)showAlert:(NSString *)title btnTitle:(NSString *)btnTitle {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self closeButtonClick];
        }];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:NO completion:nil];
    });
}

- (void)getCameraStatus:(void (^)(BOOL granted))completion {
    AVAuthorizationStatus cameraStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (cameraStatus) {
        case AVAuthorizationStatusAuthorized: {
            completion ? completion(YES) : nil;
        } break;
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion ? completion(granted) : nil;
                });
            }];
        } break;
        default: {
            completion ? completion(NO) : nil;
        } break;
    }
}

- (void)resumeScanning {
    if (self.session) {
        [self.session startRunning];
        [self.scanView startAnimation];
    }
}

- (void)pauseScanning {
    [self.session stopRunning];
    [self.scanView pauseAnimation];
}

#pragma mark - Action

- (void)closeButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)lightButtonClick {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (device.torchMode == AVCaptureTorchModeOff) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

- (void)albumButtonClick {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [picker setDelegate:self];
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
        CGImageRef ref = image.CGImage;
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:ref]];
        NSString *qrString = nil;
        if (features.count) {
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            qrString = feature.messageString;
        }
        [self handleQrCode:qrString];
    });
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (!self.session.isRunning) { return; }
    
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [self pauseScanning];
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        [self handleQrCode:[obj stringValue]];
    }
}

#pragma mark - QRCode handler

- (void)handleQrCode:(NSString *)qrCode {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.callback ? self.callback(qrCode) : nil;
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - NSNotification

- (void)appDidBecomeActive {
    [self resumeScanning];
}

- (void)appWillResignActive {
    [self pauseScanning];
}

@end
