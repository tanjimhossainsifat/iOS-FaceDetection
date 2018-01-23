//
//  LiveVideoViewController.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 23/1/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "LiveVideoViewController.h"
#import "FaceDetectorHelper.h"

@interface LiveVideoViewController ()

@property (nonatomic, strong) FaceDetectorHelper *faceDetectorHelper;
@end

@implementation LiveVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faceDetectorHelper = [[FaceDetectorHelper alloc] initiWithParentView:self.imageView];
    
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
@end
