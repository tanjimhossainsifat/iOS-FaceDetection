//
//  ConfirmStickerViewController.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 4/2/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "ConfirmStickerViewController.h"
#import "UIImage+Utility.h"

@interface ConfirmStickerViewController ()

@end

@implementation ConfirmStickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(self.image) {
        CGFloat width = self.image.size.width;
        CGFloat height = self.image.size.height;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(width*0.1, height*.05, width-width*0.1*2, height-height*.05)];
//        [path moveToPoint:CGPointMake(width*0.16, 0)];
//        [path addLineToPoint:CGPointMake(width - width*0.16, 0)];
//        [path addQuadCurveToPoint:CGPointMake(width - width*0.16, height) controlPoint:CGPointMake(width, height/2)];
//        [path addLineToPoint:CGPointMake(width*0.16, height)];
//        [path addQuadCurveToPoint:CGPointMake(width*0.16, 0) controlPoint:CGPointMake(0, height/2)];
        
        self.image = [self.image maskedImagetoPath:path];
        
        self.imageView.image = self.image;
        
    }
}

- (IBAction)onButtonSave:(UIButton *)sender {
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterLongStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSString *fileName = [NSString stringWithFormat:@"%d-%@",rand()%100,dateString];
    
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [basePath stringByAppendingPathComponent:fileName];
    
    if(self.image) {
        
        UIGraphicsBeginImageContext(self.image.size);
        [self.image drawAtPoint:CGPointZero];
        UIImage *imageToSave = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImagePNGRepresentation(imageToSave);
        if(imageData) {
            [imageData writeToFile:filePath atomically:YES];
            
            NSArray *prevStickerList = [[NSUserDefaults standardUserDefaults] objectForKey:@"stickers"];
            NSMutableArray *stickerList = [[NSMutableArray alloc] initWithArray:prevStickerList copyItems:YES];
            [stickerList addObject:fileName];
            [[NSUserDefaults standardUserDefaults] setObject:stickerList forKey:@"stickers"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}
@end
