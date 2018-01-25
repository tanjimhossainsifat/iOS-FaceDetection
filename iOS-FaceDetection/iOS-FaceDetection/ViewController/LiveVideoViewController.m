//
//  LiveVideoViewController.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 23/1/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "LiveVideoViewController.h"
#import "FaceDetectorHelper.h"

@interface LiveVideoViewController ()<FaceDetectorDelegate>

@property (nonatomic, strong) FaceDetectorHelper *faceDetectorHelper;
@end

@implementation LiveVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faceDetectorHelper = [[FaceDetectorHelper alloc] initiWithParentView:self.imageView];
    self.faceDetectorHelper.delegate = self;
    
    self.rotateButton.hidden = YES;
}

- (IBAction)onCaptureButton:(UIButton *)sender {
    
    if([self.captureButton isSelected]) {
        [self.captureButton setSelected:NO];
        [self.faceDetectorHelper stopCapture];
        self.rotateButton.hidden = YES;
    }
    else {
        [self.captureButton setSelected:YES];
        [self.faceDetectorHelper startCapture];
        self.rotateButton.hidden = NO;
    }
}

- (IBAction)onRotateButton:(id)sender {
    [self.faceDetectorHelper rotateCamera];
}

#pragma mark - FaceDetectorDelegate methods

- (void) detectedFaceWithUnitCGRects:(NSArray *) unitRects withUIImages: (NSArray *) images {
    
    for(NSValue *eachUnitRectValue in unitRects) {
        
        CGRect eachUnitRect = [eachUnitRectValue CGRectValue];
        CGRect eachRect = CGRectMake(eachUnitRect.origin.x*self.imageView.frame.size.width, eachUnitRect.origin.y*self.imageView.frame.size.height, eachUnitRect.size.width*self.imageView.frame.size.width, eachUnitRect.size.height*self.imageView.frame.size.height);
        
    }
}
@end
