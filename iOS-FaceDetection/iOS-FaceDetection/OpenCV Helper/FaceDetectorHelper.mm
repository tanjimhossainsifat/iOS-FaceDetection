//
//  FaceDetectorHelper.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 23/1/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//
#import "FaceDetectorHelper.h"
#import "FDCvVideoCamera.h"

#define CompressionRatio 2.0

@interface FaceDetectorHelper()<CvVideoCameraDelegate>

@end

@implementation FaceDetectorHelper
{
    FDCvVideoCamera *videoCamera;
    cv::CascadeClassifier faceDetector;
    
    std::vector<cv::Mat> replacedFaceImages;
    
}

#pragma mark - Video Recorder methods
- (instancetype) initWithParentView:(UIView *)parentView {
    
    [self initCameraWithParentView:parentView capturingFeedFromBackCamera:YES];
    
    NSString *faceascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt2" ofType:@"xml"];
    bool isFaceDetectorLoaded = faceDetector.load([faceascadePath UTF8String]);
    NSLog(@"Face Detector loaded successfully");
   
    return self;
}

- (void) initCameraWithParentView:(UIView *)parentView capturingFeedFromBackCamera:(BOOL) shouldUseBackCamera{
    
    videoCamera = [[FDCvVideoCamera alloc] initWithParentView:parentView];
    videoCamera.delegate = self;
    if(shouldUseBackCamera)
        videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    else
        videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
}

- (void) startCapture {
    
    [videoCamera start];
    
}
- (void) stopCapture {
    
    [videoCamera stop];
}

- (void) rotateCamera {
   
    if(videoCamera.recordVideo == NO)
        [videoCamera switchCameras];
}

- (void) startRecord {
    
    [videoCamera stop];
    
    if(videoCamera.defaultAVCaptureDevicePosition == AVCaptureDevicePositionBack) {
        [self initCameraWithParentView:videoCamera.parentView capturingFeedFromBackCamera:YES];
    }
    else {
        [self initCameraWithParentView:videoCamera.parentView capturingFeedFromBackCamera:NO];
        
    }
    videoCamera.recordVideo = YES;
    [videoCamera start];
    
}

- (void) stopRecord {

    [videoCamera stop];
    [videoCamera saveVideo];
    videoCamera.recordVideo = NO;
    [videoCamera start];
    
}

#pragma mark - Extra operations on detected faces

- (void) replaceDetectedFaceWithImageList:(NSArray<UIImage *> *) imageList {
    
    std::vector<cv::Mat> tempReplacedFaceImage;
    for(UIImage *eachUIImage in imageList) {
        cv::Mat img;
        UIImageToMat(eachUIImage, img,true);
        cv::cvtColor(img, img, cv::COLOR_BGRA2RGBA);
        tempReplacedFaceImage.push_back(img);
    }
    
    replacedFaceImages = tempReplacedFaceImage;
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
//    if(self.delegate && [self.delegate respondsToSelector:@selector(detectedFaceWithUnitCGRects:withUIImages:)]) {
//
//        [self.delegate detectedFaceWithUnitCGRects:[self getUnitCGRectListForDetectedFaces:faceRects] withUIImages:[self getUIImageListForDetectedFaces:faceRects fromImage:image]];
//    }
    
    //5. Draw replaced images for detected images
    [self drawReplacedImagesInImage:image forFaceRects:faceRects];
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

- (void) drawReplacedImagesInImage:(cv::Mat&) image forFaceRects:(std::vector<cv::Rect>)faceRects {
    
    if(replacedFaceImages.size() == 0)
        return;
    
    for (int i = 0; i< faceRects.size(); i++) {
        cv::Rect eachFaceRect = faceRects[i];
        cv::Rect roi( cv::Point(eachFaceRect.x*CompressionRatio - eachFaceRect.width*CompressionRatio*0.25,eachFaceRect.y*CompressionRatio - eachFaceRect.height*CompressionRatio*0.5), cv::Size(eachFaceRect.width*CompressionRatio*1.5,eachFaceRect.height*CompressionRatio*2) );
        cv::Mat replacedImage = replacedFaceImages[i%replacedFaceImages.size()];
        overlayImage(image, replacedImage, image, roi);
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
        
        [faceUIImages addObject:MatToUIImage(croppedImage)];
    }
    
    return faceUIImages;
}

void overlayImage(const cv::Mat &background, const cv::Mat &overlayImage,
                  cv::Mat &output, cv::Rect roi)
{
    background.copyTo(output);
    
    cv::Point2i location = cv::Point(roi.x,roi.y);
    
    cv::Mat foreground;
    cv::resize(overlayImage, foreground, roi.size());
    // start at the row indicated by location, or at row 0 if location.y is negative.
    for(int y = std::max(location.y , 0); y < background.rows; ++y)
    {
        int fY = y - location.y; // because of the translation
        
        // we are done of we have processed all rows of the foreground image.
        if(fY >= foreground.rows)
            break;
        
        // start at the column indicated by location,
        
        // or at column 0 if location.x is negative.
        for(int x = std::max(location.x, 0); x < background.cols; ++x)
        {
            int fX = x - location.x; // because of the translation.
            
            // we are done with this row if the column is outside of the foreground image.
            if(fX >= foreground.cols)
                break;
            
            // determine the opacity of the foregrond pixel, using its fourth (alpha) channel.
            double opacity =
            ((double)foreground.data[fY * foreground.step + fX * foreground.channels() + 3])
            
            / 255.;
            
            
            // and now combine the background and foreground pixel, using the opacity,
            
            // but only if opacity > 0.
            for(int c = 0; opacity > 0 && c < output.channels(); ++c)
            {
                unsigned char foregroundPx =
                foreground.data[fY * foreground.step + fX * foreground.channels() + c];
                unsigned char backgroundPx =
                background.data[y * background.step + x * background.channels() + c];
                output.data[y*output.step + output.channels()*x + c] =
                backgroundPx * (1.-opacity) + foregroundPx * opacity;
            }
        }
    }
}
@end
