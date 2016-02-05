//
//  ViewController.m
//  PhotoSeletced
//
//  Created by Zhiyun on 16/2/4.
//  Copyright © 2016年 Zhiyun. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"
#import <Photos/Photos.h>

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, strong) PHFetchResult *imageResult;
@property (nonatomic, strong) PHFetchOptions *options;
@property (nonatomic, strong) PHCachingImageManager *imageManger;
@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, assign)  CGSize assetGridThumnailSize;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.options = [[PHFetchOptions alloc] init];
    self.options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    self.imageResult = [PHAsset fetchAssetsWithOptions:self.options];
//    有参数，创建时间来显示
    
//    self.imageResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];//无参数
    self.imageManger = [[PHCachingImageManager alloc] init];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = [self calculateCellSize];
    self.assetGridThumnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    
    
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageResult.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCollectionViewCell description] forIndexPath:indexPath];
    PHAsset *asset = self.imageResult[indexPath.row];
    [self.imageManger requestImageForAsset:asset targetSize:self.assetGridThumnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.ablumImageView.image = result;
    }];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   return [self calculateCellSize];
}

#pragma mark - private
- (CGSize)calculateCellSize
{
    CGFloat width = self.view.frame.size.width;
    CGFloat itemWidth = (width - 8 * 2 - 5 * 3)/4;
    return CGSizeMake(itemWidth, itemWidth);

}


@end
