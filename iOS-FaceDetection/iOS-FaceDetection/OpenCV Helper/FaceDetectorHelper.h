//
//  FaceDetectorHelper.h
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 23/1/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

@protocol FaceDetectorDelegate <NSObject>
- (void) detectedFaceWithUnitCGRects:(NSArray *) unitRects withUIImages: (NSArray *) images;
@end


@interface FaceDetectorHelper : NSObject

@property (nonatomic, assign) id<FaceDetectorDelegate> delegate;

- (instancetype) initWithParentView:(UIView *)parentView;
- (void) startCapture;
- (void) stopCapture;
- (void) rotateCamera;
- (void) startRecord;
- (void) stopRecord;

@end
