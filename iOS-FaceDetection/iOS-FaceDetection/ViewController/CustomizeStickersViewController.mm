//
//  CustomizeStickersViewController.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 3/2/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "CustomizeStickersViewController.h"
#import "FDCvPhotoCamera.h"
#import "ConfirmStickerViewController.h"
#import "UIImage+Utility.h"

@interface CustomizeStickersViewController ()<CvPhotoCameraDelegate>

@end

@implementation CustomizeStickersViewController {
    
    FDCvPhotoCamera *photoCamera;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissSelf)];
    [self.navigationItem setRightBarButtonItem:cancelButton];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initPhotoCameraCapturingFeedFromBackCamera:NO];
    [photoCamera start];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [photoCamera stop];
}

- (void) initPhotoCameraCapturingFeedFromBackCamera:(BOOL) shouldUseBackCamera{
    
    photoCamera = [[FDCvPhotoCamera alloc] initWithParentView:self.captureImageView];
    photoCamera.delegate = self;
    if(shouldUseBackCamera) {
        photoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    }
    else {
        
        photoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    }
    photoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    photoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetPhoto;
    photoCamera.useAVCaptureVideoPreviewLayer = NO;
}

- (void) dismissSelf {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - CvPhotoCameraDelegate

- (void)photoCamera:(CvPhotoCamera*)photoCamera capturedImage:(UIImage *)image {
    
    if(image) {
        
        UIImage *rotatedImage = [self rotateImage:image byDegrees:90];
        UIImage *resizedImage = [rotatedImage resize:self.captureImageView.frame.size];
        
        CGRect roiRect = self.faceImageView.frame;
        roiRect.origin.x = roiRect.origin.x + 10;
        roiRect.size.width = roiRect.size.width - 20;
        roiRect.origin.y = roiRect.origin.y + 10;
        roiRect.size.height = roiRect.size.height - 20;
        UIImage *roiImage = [resizedImage crop:roiRect];
        
        UIImage *maskImage = [UIImage imageNamed:@"face_mask"];
        UIImage *maskedImage = [roiImage maskedImage:maskImage];
        if(photoCamera.defaultAVCaptureDevicePosition == AVCaptureDevicePositionFront) {
            maskedImage = [UIImage imageWithCGImage:maskedImage.CGImage
                                              scale:maskedImage.scale
                                        orientation:UIImageOrientationUpMirrored];
        }
        
        ConfirmStickerViewController *confirmStickerVC = [[ConfirmStickerViewController alloc] init];
        confirmStickerVC.image = maskedImage;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:confirmStickerVC animated:YES];
        });
    }
}
- (void)photoCameraCancel:(CvPhotoCamera*)photoCamera {
    
}

#pragma mark - Button actions
- (IBAction)onButtonRotate:(UIButton *)sender {
    [photoCamera stop];
    if(photoCamera.defaultAVCaptureDevicePosition == AVCaptureDevicePositionBack) {
        [self initPhotoCameraCapturingFeedFromBackCamera:NO];
    }
    else {
        [self initPhotoCameraCapturingFeedFromBackCamera:YES];
    }
    [photoCamera start];
}

- (IBAction)onButtonCapture:(UIButton *)sender {
    [photoCamera takePicture];
}

#pragma mark - Image customization related methods
- (UIImage *)rotateImage:(UIImage *)image byDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees*M_PI/180.0);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, degrees*M_PI/180.0);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
@end
