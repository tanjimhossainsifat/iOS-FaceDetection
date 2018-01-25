//
//  FaceDetectorHelper.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 23/1/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//
#import <opencv2/videoio/cap_ios.h>
#import "FaceDetectorHelper.h"

#define CompressionRatio 2.0

@interface FaceDetectorHelper()<CvVideoCameraDelegate>

@end

@implementation FaceDetectorHelper
{
    CvVideoCamera *videoCamera;
    cv::CascadeClassifier faceDetector;
    
}

- (instancetype) initiWithParentView:(UIView *)parentView {
    
    videoCamera = [[CvVideoCamera alloc] initWithParentView:parentView];
    videoCamera.delegate = self;
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 24;
    videoCamera.grayscaleMode = NO;
    
    NSString *faceascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt2" ofType:@"xml"];
    CFIndex faceCascadeLength = 2048;
    char *faceCascadeName = (char *) malloc(faceCascadeLength *sizeof(char));
    CFStringGetFileSystemRepresentation((CFStringRef)faceascadePath, faceCascadeName, faceCascadeLength);
    
    bool isFaceDetectorLoaded = faceDetector.load(faceCascadeName);
    NSLog(@"Face Detector loaded successfully");
    
    free(faceCascadeName);
   
    return self;
}

- (void) startCapture {
    [videoCamera start];
}
- (void) stopCapture {
    [videoCamera stop];
}

- (void) rotateCamera {
    [videoCamera stop];
    if(videoCamera.defaultAVCaptureDevicePosition == AVCaptureDevicePositionFront) {
        videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    }
    else {
        videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    }
    [videoCamera start];
}

#pragma mark - CvVideoCameraDelegate method
- (void)processImage:(cv::Mat&)image {
    
    cv::Mat compressedImage = [self compressImage:image];
    std::vector<cv::Rect>faceRects = [self getDetectedFaceRectsInImage:compressedImage];
    if(faceRects.size()>0) {
        [self drawRectengaleInImage:image forFaceRects:faceRects];
    }
}

#pragma mark - Private methods

- (cv::Mat) compressImage: (cv::Mat&) image {
    
    cv::Mat grayImage;
    cv::cvtColor(image, grayImage, cv::COLOR_RGB2GRAY); //Converted color image to grayscale
    
    cv::Mat compressedImage(image.rows/CompressionRatio,image.cols/CompressionRatio,CV_8UC1);
    cv::resize(grayImage, compressedImage, compressedImage.size()); //compressed grayScale image
    cv::equalizeHist(compressedImage, compressedImage); //Equalized Histogram
    
    return compressedImage;
}

- (std::vector<cv::Rect>) getDetectedFaceRectsInImage:(cv::Mat&) image {
    
    std::vector<cv::Rect> faceRects;
    
    faceDetector.detectMultiScale(image, faceRects);
    
    return faceRects;
}

- (void) drawRectengaleInImage:(cv::Mat&) image forFaceRects:(std::vector<cv::Rect>)faceRects {
    
    for (int i = 0; i< faceRects.size(); i++) {
        cv::Rect eachFaceRect = faceRects[i];
        
        cv::rectangle(image, cv::Point(eachFaceRect.x*CompressionRatio,eachFaceRect.y*CompressionRatio), cv::Point((eachFaceRect.x+eachFaceRect.width)*CompressionRatio,(eachFaceRect.y+eachFaceRect.height)*CompressionRatio), cvScalar(rand()%256,rand()%256,rand()%256,0));
    }
}
@end
