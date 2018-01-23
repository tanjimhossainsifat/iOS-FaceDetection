//
//  LiveVideoViewController.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 23/1/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "LiveVideoViewController.h"

@interface LiveVideoViewController ()

@end

@implementation LiveVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onCaptureButton:(UIButton *)sender {
    
    if([self.captureButton isSelected]) {
        [self.captureButton setSelected:NO];
    }
    else {
        [self.captureButton setSelected:YES];
    }
}
@end
