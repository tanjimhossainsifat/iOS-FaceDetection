//
//  FDCvPhotoCamera.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 5/2/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "FDCvPhotoCamera.h"

@implementation FDCvPhotoCamera

- (void)createCustomVideoPreview;
{
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
    if ([captureVideoPreviewLayer respondsToSelector:@selector(connection)])
    {
        if ([captureVideoPreviewLayer.connection isVideoOrientationSupported])
        {
            [captureVideoPreviewLayer.connection setVideoOrientation:self.defaultAVCaptureVideoOrientation];
        }
    }
    else
    {
        // Deprecated in 6.0; here for backward compatibility
        if ([captureVideoPreviewLayer isOrientationSupported])
        {
            [captureVideoPreviewLayer setOrientation:self.defaultAVCaptureVideoOrientation];
        }
    }
    
    if (self.parentView != nil) {
        captureVideoPreviewLayer.frame = self.parentView.bounds;
        captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.parentView.layer addSublayer:captureVideoPreviewLayer];
    }
    NSLog(@"[Camera] created Custom AVCaptureVideoPreviewLayer");
}


@end
