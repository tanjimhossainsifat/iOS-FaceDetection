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
    
    self.faceDetectorHelper = [[FaceDetectorHelper alloc] initWithParentView:self.imageView];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.faceDetectorHelper startCapture];
}

- (IBAction)onRotateButton:(id)sender {
    [self.faceDetectorHelper rotateCamera];
}

- (IBAction)onRecordButton:(id)sender {
    if([self.recordButton isSelected]) {
        [self.recordButton setSelected:NO];
        [self.faceDetectorHelper stopRecord];
    }
    else {
        [self.recordButton setSelected:YES];
        [self.faceDetectorHelper startRecord];
    }
}

- (IBAction)onEditButton:(id)sender {
    NSMutableArray *imageList;
    imageList =  [[NSMutableArray alloc] init];
    
    if([self.editButton isSelected]) {
        [self.editButton setSelected:NO];
    }
    else {
        [self.editButton setSelected:YES];
        
        UIImage *cage = [UIImage imageNamed:@"cage.png"];
        UIImage *toby = [UIImage imageNamed:@"toby.png"];
        UIImage *will = [UIImage imageNamed:@"will.png"];
        int random = rand()%31;
        if(random%3==0) [imageList addObject:cage];
        else if(random%3==1) [imageList addObject:will];
        else [imageList addObject:toby];
    }
    
    [self.faceDetectorHelper replaceDetectedFaceWithImageList:imageList];
}
@end

