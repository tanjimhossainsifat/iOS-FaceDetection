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

@implementation LiveVideoViewController {
    UIImageView *topImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faceDetectorHelper = [[FaceDetectorHelper alloc] initiWithParentView:self.imageView];
    self.faceDetectorHelper.delegate = self;
    
    topImageView = [[UIImageView alloc] init];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.faceDetectorHelper startCapture];
}

- (IBAction)onRotateButton:(id)sender {
    [self.faceDetectorHelper rotateCamera];
}

#pragma mark - FaceDetectorDelegate methods

- (void) detectedFaceWithUnitCGRects:(NSArray *) unitRects withUIImages: (NSArray *) images {
    
    if(unitRects.count > 0) {
        
        for(NSValue *eachUnitRectValue in unitRects) {
            
            CGRect eachUnitRect = [eachUnitRectValue CGRectValue];
            CGRect eachRect = CGRectMake(eachUnitRect.origin.x*self.imageView.frame.size.width, eachUnitRect.origin.y*self.imageView.frame.size.height, eachUnitRect.size.width*self.imageView.frame.size.width, eachUnitRect.size.height*self.imageView.frame.size.height);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                topImageView.image = [UIImage imageNamed:@"anonymous"];
                [topImageView setFrame:eachRect];
                [self.imageView insertSubview:topImageView atIndex:self.imageView.subviews.count];
            });
            
        }
    }
    else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [topImageView removeFromSuperview];
        });
    }
    
}
@end
