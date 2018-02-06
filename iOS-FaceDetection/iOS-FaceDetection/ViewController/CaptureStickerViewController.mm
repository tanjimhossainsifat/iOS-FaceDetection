//
//  CaptureStickerViewController.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 3/2/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "CaptureStickerViewController.h"
#import "FaceDetectorHelper.h"
#import "ConfirmStickerViewController.h"
#import "UIImage+Utility.h"

@interface CaptureStickerViewController ()<FaceDetectorDelegate>

@property (nonatomic, strong) FaceDetectorHelper *faceDetectorHelper;

@end

@implementation CaptureStickerViewController {
    NSArray *unitFaceRects;
    NSArray *detectedFaceImages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissSelf)];
    [self.navigationItem setRightBarButtonItem:cancelButton];
    
    self.faceDetectorHelper = [[FaceDetectorHelper alloc] initWithParentView:self.captureImageView];
    self.faceDetectorHelper.shouldDrawRectangle = YES;
    self.faceDetectorHelper.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:) ];
    [self.captureImageView addGestureRecognizer:tapGestureRecongnizer];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.faceDetectorHelper startCapture];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.faceDetectorHelper stopCapture];
}

- (void) dismissSelf {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Button actions
- (IBAction)onButtonRotate:(UIButton *)sender {
    
    [self.faceDetectorHelper rotateCamera];
    
}

#pragma mark - Gesture method
- (void) handleTapGesture:(UITapGestureRecognizer *) tapGestureRecognizer {
    
    CGPoint touchPoint = [tapGestureRecognizer locationInView:nil];
    CGPoint unitTouchPoint = CGPointMake(touchPoint.x/self.captureImageView.frame.size.width, touchPoint.y/self.captureImageView.frame.size.height);
    
    for( int i=0; i< [unitFaceRects count]; i++ ) {
        
        CGRect unitFaceRect = [unitFaceRects[i] CGRectValue];
        if(CGRectContainsPoint(unitFaceRect, unitTouchPoint)) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ConfirmStickerViewController *confirmStickerVC = [[ConfirmStickerViewController alloc] init];
                confirmStickerVC.image = detectedFaceImages[i];
                [self.navigationController pushViewController:confirmStickerVC animated:YES];
            });
        }
    }
    
}
#pragma mark- FaceDectectorDelegate

- (void) detectedFaceWithUnitCGRects:(NSArray *) unitRects withUIImages: (NSArray *) images {
    
    unitFaceRects = [unitRects copy];
    detectedFaceImages = [images copy];
}

@end
