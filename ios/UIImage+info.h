//
//  UIImage+info.h
//  自定义相机
//
//  Created by macbook on 16/9/3.
//  Copyright © 2016年 QIYIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (info)

+ (UIImage*)image:(UIImage *)image scaleToSize:(CGSize)size;
+ (UIImage*)image:(UIImage *)sourceImage scalingAndCroppingForSize:(CGSize)targetSize;
+ (CGRect)thumbnailRectFromSize:(CGSize)imageSize scalingToSize:(CGSize)targetSize;
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
+ (UIImage *)cropImage:(UIImage*)image toRect:(CGRect)rect;

@end
