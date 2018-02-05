//
//  ConfirmStickerViewController.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 4/2/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "ConfirmStickerViewController.h"

@interface ConfirmStickerViewController ()

@end

@implementation ConfirmStickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.imageView.image = self.image;
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
