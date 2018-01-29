//
//  FaceDetectorHelper.h
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 23/1/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

@interface FaceDetectorHelper : NSObject

- (instancetype) initWithParentView:(UIView *)parentView;
- (void) startCapture;
- (void) stopCapture;
- (void) rotateCamera;
- (void) startRecord;
- (void) stopRecord;

- (void) replaceDetectedFaceWithImageList:(NSArray<UIImage *> *) imageList;
@end
