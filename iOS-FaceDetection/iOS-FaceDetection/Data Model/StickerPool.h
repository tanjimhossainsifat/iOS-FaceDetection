//
//  StickerPool.h
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 3/2/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sticker.h"

@interface StickerPool : NSObject

- (NSArray<Sticker *>*) getAllFaceStickers ;
- (NSArray<Sticker *>*) getAllEyeStickers ;
- (NSArray<Sticker *>*) getAllStickers;

@end
