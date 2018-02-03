//
//  Sticker.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 3/2/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "Sticker.h"

@implementation Sticker

-(instancetype) initWithImage:(UIImage *) image withType:(StickerType) type {
    self = [self init];
    
    if(self) {
        self.image = image;
        self.type = type;
        
        return self;
    }
    return nil;
}

@end
