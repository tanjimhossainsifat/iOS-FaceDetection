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
@property (weak, nonatomic) IBOutlet UIButton *rotateButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

- (IBAction)onRotateButton:(id)sender;
- (IBAction)onRecordButton:(id)sender;
- (IBAction)onEditButton:(id)sender;


@end
