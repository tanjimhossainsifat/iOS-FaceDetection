//
//  ConfirmStickerViewController.h
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 4/2/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmStickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) UIImage *image;

- (IBAction)onButtonSave:(UIButton *)sender;
@end
