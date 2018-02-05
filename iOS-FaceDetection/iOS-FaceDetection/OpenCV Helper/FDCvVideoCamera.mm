//
//  FDCvVideoCamera.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 29/1/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "FDCvVideoCamera.h"

@implementation FDCvVideoCamera

- (void)layoutPreviewLayer
{
    if (self.parentView != nil)
    {
        CALayer* layer = self->customPreviewLayer;
        CGRect bounds = self->customPreviewLayer.bounds;
        
        float previewAspectRatio = bounds.size.height / bounds.size.width;
        
        layer.position = CGPointMake(self.parentView.frame.size.width/2., self.parentView.frame.size.height/2.);
        
        // Get video feed's resolutions
        NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        AVCaptureDevice* device = nil;
        for (AVCaptureDevice *d in devices) {
            // Get the default camera device - should be either front of back camera device
            if ([d position] == self.defaultAVCaptureDevicePosition) {
                device = d;
            }
        }
        
        // Set the default device if not found
        if (!device) {
            device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        }
        
        CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(device.activeFormat.formatDescription);
        CGSize resolution = CGSizeMake(dimensions.width, dimensions.height);
        if (self.defaultAVCaptureVideoOrientation == AVCaptureVideoOrientationPortrait || self.defaultAVCaptureVideoOrientation == AVCaptureVideoOrientationPortraitUpsideDown) {
            resolution = CGSizeMake(resolution.height, resolution.width);
        }
        
        float videoFeedAspectRatio = resolution.height / resolution.width;
        
        // Set layer bounds to ASPECT FILL by expanding either the width or the height
        if (previewAspectRatio > videoFeedAspectRatio) {
            float newWidth = bounds.size.height / videoFeedAspectRatio;
            layer.bounds = CGRectMake(0, 0, newWidth, bounds.size.height);
            self.imageWidth = newWidth;
            self.imageHeight = bounds.size.height;
        } else {
            float newHeight = bounds.size.width * videoFeedAspectRatio;
            layer.bounds = CGRectMake(0, 0, bounds.size.width, newHeight);
            self.imageWidth = bounds.size.width;
            self.imageHeight = newHeight;
        }
    }
}

@end
