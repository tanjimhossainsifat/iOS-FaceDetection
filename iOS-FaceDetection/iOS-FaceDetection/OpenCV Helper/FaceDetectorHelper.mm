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
    
    //1. Compress Image
    cv::Mat compressedImage = [self compressImage:image];
    
    //2.Get Face Rects from the compressed image
    std::vector<cv::Rect>faceRects = [self getDetectedFaceRectsInImage:compressedImage];
   
    //3. Draw rectangle around image if necessary
//   [self drawRectengaleInImage:image forFaceRects:faceRects];
    
    //4. Call delegate method
    if(self.delegate && [self.delegate respondsToSelector:@selector(detectedFaceWithUnitCGRects:withUIImages:)]) {
        
        [self.delegate detectedFaceWithUnitCGRects:[self getUnitCGRectListForDetectedFaces:faceRects] withUIImages:[self getUIImageListForDetectedFaces:faceRects fromImage:image]];
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
        
        cv::rectangle(image, cv::Point(eachFaceRect.x*CompressionRatio,eachFaceRect.y*CompressionRatio), cv::Point((eachFaceRect.x+eachFaceRect.width)*CompressionRatio,(eachFaceRect.y+eachFaceRect.height)*CompressionRatio), cvScalar(1.0,1.0,1.0,0));
    }
}

-(NSArray *) getUnitCGRectListForDetectedFaces:(std::vector<cv::Rect>&)faceRects {
    
    NSMutableArray *faceUnitCGRects = [[NSMutableArray alloc] initWithCapacity:faceRects.size()];
    
    for (int i =0; i<faceRects.size(); i++) {
        
        cv::Rect eachFaceRect = faceRects[i];
        
        //In PotraitMode, Width = 480, Height = 640
        CGRect eachUnitCGRect = CGRectMake((eachFaceRect.x*CompressionRatio)/480, (eachFaceRect.y*CompressionRatio)/640, (eachFaceRect.width*CompressionRatio)/480, (eachFaceRect.height*CompressionRatio)/640);
        
        [faceUnitCGRects addObject:[NSValue valueWithCGRect:eachUnitCGRect]];
    }
    
    return faceUnitCGRects;
}

-(NSArray *) getUIImageListForDetectedFaces:(std::vector<cv::Rect>&)faceRects fromImage:(cv::Mat&)image{
    
    NSMutableArray *faceUIImages = [[NSMutableArray alloc] initWithCapacity:faceRects.size()];
    
    for (int i =0; i<faceRects.size(); i++) {
        
        cv::Rect eachFaceRect = faceRects[i];
        
        cv::Mat croppedImage(image,eachFaceRect);
        
        [faceUIImages addObject:[self UIImageFromCVMat:croppedImage]];
    }
    
    return faceUIImages;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}
@end
