//
//  LiveVideoViewController.m
//  iOS-FaceDetection
//
//  Created by Tanjim Hossain on 23/1/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "LiveVideoViewController.h"
#import "FaceDetectorHelper.h"
#import "StickerPool.h"
#import "StickerCollectionViewCell.h"

@interface LiveVideoViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) FaceDetectorHelper *faceDetectorHelper;
@property (nonatomic, strong) StickerPool *stickerPool;
@end

@implementation LiveVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faceDetectorHelper = [[FaceDetectorHelper alloc] initWithParentView:self.imageView];
    self.stickerPool = [[StickerPool alloc] init];
    
    [self.stickerCollectionView registerNib:[UINib nibWithNibName:@"StickerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StickerCell"];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.faceDetectorHelper startCapture];
}

- (IBAction)onRotateButton:(id)sender {
    [self.faceDetectorHelper rotateCamera];
}

- (IBAction)onRecordButton:(id)sender {
    if([self.recordButton isSelected]) {
        [self.recordButton setSelected:NO];
        [self.faceDetectorHelper stopRecord];
    }
    else {
        [self.recordButton setSelected:YES];
        [self.faceDetectorHelper startRecord];
    }
}

- (IBAction)onEditButton:(id)sender {
    
    if([self.editButton isSelected]) {
        [self.editButton setSelected:NO];
        [self.stickerView setHidden:YES];
    }
    else {
        [self.editButton setSelected:YES];
        [self.stickerView setHidden:NO];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[self.stickerPool getAllStickers] count];
}

- (StickerCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *stickerCollectionViewCellIdentifier = @"StickerCell";
    StickerCollectionViewCell *cell = (StickerCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:stickerCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = (StickerCollectionViewCell *) [[StickerCollectionViewCell alloc] init];
    }
    
    Sticker * sticker = [[self.stickerPool getAllStickers] objectAtIndex:indexPath.row];
    if(sticker) {
        cell.imageView.image = sticker.image;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *imageList=[[NSMutableArray alloc] init];
    
    Sticker *sticker = [[self.stickerPool getAllStickers] objectAtIndex:indexPath.row];
    if(sticker) {
        [imageList addObject:sticker.image];
    }
    
    [self.faceDetectorHelper replaceDetectedFaceWithImageList:imageList];
}
@end

