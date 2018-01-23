//
//  LiveVideoViewController.h
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 23/1/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveVideoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIButton *rotateButton;

- (IBAction)onCaptureButton:(UIButton *)sender;
- (IBAction)onRotateButton:(id)sender;

@end
