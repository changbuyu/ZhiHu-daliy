//
//  CBYImageView.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/23.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYImageView.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
static const CGFloat kDownloadButtonWH = 20.f;
static const CGFloat kInitScale = 0.7;
static const CGFloat kBottomMargin = 40;

@interface CBYImageView()<UITableViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *downloadButton;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIView *scaleView;
@end

@implementation CBYImageView

- (UIView *)scaleView{
    if (!_scaleView) {
        _scaleView = [[UIView alloc] initWithFrame:self.scrollView.bounds];
        _scaleView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:_scaleView];
        [_scaleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenImage)]];

    }
    return _scaleView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.f;
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.frame = frame;
        scrollView.maximumZoomScale = 2.0;
        scrollView.delegate = self;
        scrollView.alwaysBounceVertical = YES;
        scrollView.height = CBYSCREENH - kBottomMargin;
        self.scrollView = scrollView;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        [self.scaleView addSubview:imageView];
        
        UIButton *button = [[UIButton alloc] init];
        button.size = CGSizeMake(kDownloadButtonWH, kDownloadButtonWH);
        button.origin = CGPointMake(CBYSCREENW - kDownloadButtonWH * 2, CBYSCREENH - kDownloadButtonWH * 2);
        [button setImage:[UIImage imageNamed:@"News_Picture_Save"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.downloadButton = button;
        
        }
    return self;
}

- (void)setImgURL:(NSString *)imgURL{
    _imgURL = imgURL;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGFloat scaleX = self.width / image.size.width;
        CGFloat scaleY = self.height / image.size.height;
        if (scaleX < scaleY) {
            self.imageView.size = CGSizeMake(image.size.width * scaleX, image.size.height * scaleX);
        }else{
            self.imageView.size = CGSizeMake(image.size.width * scaleY, image.size.height * scaleY);
        }
        self.imageView.center = self.center;
//        self.imageView.origin = CGPointMake(0, (CBYSCREENH - self.imageView.size.height) * 0.5);
        self.image = image;
    }];
}

- (void)hiddenImage{
    [UIView animateWithDuration:CBYAnimationDuration animations:^{
        self.alpha = 0.0;
        self.imageView.transform = CGAffineTransformMakeScale(kInitScale, kInitScale);
    } completion:^(BOOL finished) {
        [self.scrollView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.scaleView;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hiddenImage];
}

#pragma mark ---- 响应事件
- (void)saveImage{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有相册的访问权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:cancel];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [controller addAction:sure];
        [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
    }else{
        UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(didFinishSaveImage: error: contextInfo:), NULL);
    }
}

- (void)didFinishSaveImage:(UIImage *)image error:(NSError *)error contextInfo:(void *)info{
    [MBProgressHUD showSuccess:@"保存成功!"];
}

#pragma mark ---- 外部调用
+ (CBYImageView *)showViewWith:(NSString *)imgURL view:(UIView *)superView{
    CBYImageView *imageView = [[CBYImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.imgURL = imgURL;
    [superView addSubview:imageView];
    [UIView animateWithDuration:CBYAnimationDuration animations:^{
        imageView.alpha = 0.8f;
    }];
    return imageView;
}

- (void)showImageWithView:(UIView *)superView{
    [superView addSubview:self.scrollView];
    self.imageView.transform = CGAffineTransformMakeScale(kInitScale, kInitScale);
    [UIView animateWithDuration:CBYAnimationDuration animations:^{
        self.imageView.transform = CGAffineTransformIdentity;
    }];
}
@end
