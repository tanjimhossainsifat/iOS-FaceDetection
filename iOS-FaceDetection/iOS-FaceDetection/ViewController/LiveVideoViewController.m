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
#import "CaptureStickerViewController.h"

@interface LiveVideoViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) FaceDetectorHelper *faceDetectorHelper;
@property (nonatomic, strong) StickerPool *stickerPool;
@end

@implementation LiveVideoViewController {
    NSInteger selectedStickerIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faceDetectorHelper = [[FaceDetectorHelper alloc] initWithParentView:self.imageView];
    
    self.stickerPool = [[StickerPool alloc] init];
    selectedStickerIndex = -1;
    
    [self.stickerCollectionView registerNib:[UINib nibWithNibName:@"StickerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StickerCell"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.faceDetectorHelper startCapture];
    [self.stickerPool initStickers];
    [self.stickerCollectionView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.faceDetectorHelper stopCapture];
}

#pragma  mark - Button methods
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
    
    return [[self.stickerPool getAllStickers] count] + 1;
}

- (StickerCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *stickerCollectionViewCellIdentifier = @"StickerCell";
    StickerCollectionViewCell *cell = (StickerCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:stickerCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = (StickerCollectionViewCell *) [[StickerCollectionViewCell alloc] init];
    }
    
    if(indexPath.row == [[self.stickerPool getAllStickers] count]) { // Last Index
        cell.imageView.image = [UIImage imageNamed:@"add_new_up"];
    }
    else {
        Sticker * sticker = [[self.stickerPool getAllStickers] objectAtIndex:indexPath.row];
        if(sticker) {
            cell.imageView.image = sticker.image;
        }
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == [[self.stickerPool getAllStickers] count]) { //Last Index
        //Write method to add new sticker
        StickerCollectionViewCell *cell = (StickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(cell) {
            cell.imageView.image = [UIImage imageNamed:@"add_new_down"];
        }
        
        CaptureStickerViewController *captureStickerVC = [[CaptureStickerViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:captureStickerVC];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:navController animated:YES completion:^{
                
            }];
        });
    }
    else {
        
        NSMutableArray *imageList=[[NSMutableArray alloc] init];
        
        if(selectedStickerIndex != indexPath.row) {
            selectedStickerIndex = indexPath.row;
            
            Sticker *sticker = [[self.stickerPool getAllStickers] objectAtIndex:indexPath.row];
            if(sticker) {
                [imageList addObject:sticker.image];
            }
        }
        else {
            selectedStickerIndex = -1;
        }
        
        [self.faceDetectorHelper replaceDetectedFaceWithImageList:imageList];
        
    }
}
@end

