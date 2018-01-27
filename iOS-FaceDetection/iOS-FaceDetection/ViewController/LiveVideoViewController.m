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
    
    NSMutableArray *topImageViewList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faceDetectorHelper = [[FaceDetectorHelper alloc] initiWithParentView:self.imageView];
    self.faceDetectorHelper.delegate = self;
    
    topImageViewList = [[NSMutableArray alloc] init];
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
    
    for(UIImageView *topImageView in topImageViewList) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [topImageView removeFromSuperview];
        });
    }
    
    while(topImageViewList.count < unitRects.count) {
        UIImageView *topImageView = [[UIImageView alloc] init];
        topImageView.image = [UIImage imageNamed:@"anonymous"];
        [topImageViewList addObject:topImageView];
    }
    
    for(int i = 0; i<unitRects.count; i++) {
        
        NSValue *eachUnitRectValue = unitRects[i];
        CGRect eachUnitRect = [eachUnitRectValue CGRectValue];
        CGFloat verticalExpansion = eachUnitRect.size.height*self.imageView.frame.size.height*0.08;
        CGFloat horizontalCompression = eachUnitRect.size.width*self.imageView.frame.size.width*0.08;
        CGRect eachRect = CGRectMake(eachUnitRect.origin.x*self.imageView.frame.size.width + horizontalCompression, eachUnitRect.origin.y*self.imageView.frame.size.height - verticalExpansion, eachUnitRect.size.width*self.imageView.frame.size.width - horizontalCompression*2, eachUnitRect.size.height*self.imageView.frame.size.height + verticalExpansion*2);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *topImageView = [topImageViewList objectAtIndex:i];
            [topImageView setFrame:eachRect];
            [self.imageView addSubview:topImageView];
        });
        
    }
    
}
@end

