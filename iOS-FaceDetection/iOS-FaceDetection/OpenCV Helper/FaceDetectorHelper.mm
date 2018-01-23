//
//  FaceDetectorHelper.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 23/1/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//
#import <opencv2/videoio/cap_ios.h>
#import "FaceDetectorHelper.h"

#define CompressionScale 2

@interface FaceDetectorHelper()<CvVideoCameraDelegate>

@end

@implementation FaceDetectorHelper
{
    CvVideoCamera *videoCamera;
}

- (instancetype) initiWithParentView:(UIView *)parentView {
    
    videoCamera = [[CvVideoCamera alloc] initWithParentView:parentView];
    videoCamera.delegate = self;
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
   
    return self;
}

- (void) startCapture {
    [videoCamera start];
}
- (void) stopCapture {
    [videoCamera stop];
}

- (void) rotateCamera {
    if(videoCamera.defaultAVCaptureDevicePosition == AVCaptureDevicePositionFront) {
        videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    }
    else {
        videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    }
}

#pragma mark - CvVideoCameraDelegate method
- (void)processImage:(cv::Mat&)image {
    
    NSLog(@"Process Image called");
    
}

@end
