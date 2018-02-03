//
//  Sticker.h
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 3/2/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, StickerType) {
    StickerTypeFace,
    StickerTypeEye
};

@interface Sticker : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) StickerType type;

-(instancetype) initWithImage:(UIImage *) image withType:(StickerType) type;

@end
