//
//  Sticker.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 3/2/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "StickerPool.h"

@implementation StickerPool {
    
    NSMutableArray *faceStickerList;
    NSMutableArray *eyeStickerList;
    NSMutableArray *allStickerList;
    
}

#pragma mark - Private methods
-(instancetype) init {
    
    self = [super init];
    if(self) {
        
        [self initStickers];
        return self;
    }
    
    return nil;
}

- (void) initStickers {
    
    //Images are now static.
    NSArray *faceStickerImages = @[@"cage.png",@"toby.png",@"will.png"];
    NSArray *eyeStickerIamges = @[];
    
    //Initialize all stickerLists
    faceStickerList = [[NSMutableArray alloc] init];
    eyeStickerList = [[NSMutableArray alloc] init];
    allStickerList = [[NSMutableArray alloc] init];
    
    //Enter all faceSticker in faceStickerList and allStickerList
    for(NSString *faceStickerImage in faceStickerImages) {
        UIImage *image = [UIImage imageNamed:faceStickerImage];
        if(image) {
            Sticker *faceSticker = [[Sticker alloc] initWithImage:image withType:StickerTypeFace];
            if(faceSticker) {
                [faceStickerList addObject:faceSticker];
                [allStickerList addObject:faceSticker];
            }
        }
    }
    
    //Enter all eyeSticker in eyeStickerList and allStickerList
    for(NSString *eyeStickerImage in eyeStickerIamges) {
        UIImage *image = [UIImage imageNamed:eyeStickerImage];
        if(image) {
            Sticker *eyeSticker = [[Sticker alloc] initWithImage:image withType:StickerTypeEye];
            if(eyeSticker) {
                [faceStickerList addObject:eyeSticker];
                [allStickerList addObject:eyeSticker];
            }
        }
    }
}

#pragma mark - Public methods

- (NSArray<Sticker *>*) getAllFaceStickers {
    
    return faceStickerList;
}

- (NSArray<Sticker *>*) getAllEyeStickers {
    
    return eyeStickerList;
}

- (NSArray<Sticker *>*) getAllStickers {
    
    return allStickerList;
}

@end

