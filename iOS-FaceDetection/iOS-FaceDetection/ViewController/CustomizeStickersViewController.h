//
//  CustomizeStickersViewController.h
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 3/2/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomizeStickersViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *captureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UIView *stickerView;
@property (weak, nonatomic) IBOutlet UIButton *rotateButton;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;

- (IBAction)onButtonRotate:(UIButton *)sender;
- (IBAction)onButtonCapture:(UIButton *)sender;

@end
