//
//  CaptureStickerViewController.h
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 3/2/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaptureStickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *captureImageView;
@property (weak, nonatomic) IBOutlet UIView *stickerView;
@property (weak, nonatomic) IBOutlet UIButton *rotateButton;

- (IBAction)onButtonRotate:(UIButton *)sender;

@end
