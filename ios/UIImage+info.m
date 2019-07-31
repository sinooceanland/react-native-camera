//
//  UIImage+info.m
//  自定义相机
//
//  Created by macbook on 16/9/3.
//  Copyright © 2016年 QIYIKE. All rights reserved.
//

#import "UIImage+info.h"

@implementation UIImage (info)

/**
 * 将图片缩放到指定的CGSize大小
 * UIImage image 原始的图片
 * CGSize size 要缩放到的大小
 */
+ (UIImage*)image:(UIImage *)image scaleToSize:(CGSize)size{
    
    // 得到图片上下文，指定绘制范围
    UIGraphicsBeginImageContext(size);
    
    // 将图片按照指定大小绘制
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前图片上下文中导出图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 当前图片上下文出栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

/**
 * 将图片等比缩放缩放到指定的CGSize大小(通过计算得到缩放系数)
 * 按比例缩放,size 是你要把图显示到 多大区域
 * UIImage image 原始的图片
 * CGSize size 要缩放到的大小
 */
+ (UIImage*)image:(UIImage *)sourceImage scalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 * 将图片等比缩放缩放到指定的CGSize大小(通过计算得到缩放系数)
 * 按比例缩放,size 是你要把图显示到 多大区域
 * CGSize imageSize 原始的图片大小
 * CGSize targetSize 要缩放到的大小
 */
+ (CGRect)thumbnailRectFromSize:(CGSize)imageSize scalingToSize:(CGSize)targetSize
{
    CGFloat width = imageSize.width; // 源宽度
    CGFloat height = imageSize.height; // 源高度
    CGFloat targetWidth = targetSize.width; // 目标宽度
    CGFloat targetHeight = targetSize.height; // 目标高度
    CGFloat scaleFactor = 0.0; // 缩放系数
    CGFloat scaledWidth = targetWidth; // 缩放后的宽度（先初始化为目标宽度）
    CGFloat scaledHeight = targetHeight; // 缩放后的高度（先初始化为目标高度）
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0); // xx点
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) // 源宽高不等于目标宽高时
    {
        CGFloat widthFactor = targetWidth / width; // 目标宽度/源宽度（宽缩放系数）
        CGFloat heightFactor = targetHeight / height; // 目标高度度/源高度（高缩放系数）
        // 向目标宽高等比例缩放时，谁大用谁（保证原图等比例缩放后能完全覆盖目标区域大小）
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        
        // 等比例缩放
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            // 以目标宽为准，此时可能没有达到目标高的要求，会比目标的高大，调整目前区域居中
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; // 负值
        }
        else if (widthFactor < heightFactor)
        {
            // 以目标高为准，此时可能没有达到目标宽的要求，会比目标的宽大，调整目前区域居中
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5; // 负值
        }
    }
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    return thumbnailRect;
}

/**
 * 从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    //UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:image.scale orientation:image.imageOrientation];
    
    //返回剪裁后的图片
    return newImage;
}

+ (UIImage *)cropImage:(UIImage*)image toRect:(CGRect)rect {
    CGFloat (^rad)(CGFloat) = ^CGFloat(CGFloat deg) {
        return deg / 180.0f * (CGFloat) M_PI;
    };
    
    // determine the orientation of the image and apply a transformation to the crop rectangle to shift it to the correct position
    CGAffineTransform rectTransform;
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -image.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -image.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -image.size.width, -image.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    // adjust the transformation scale based on the image scale
    rectTransform = CGAffineTransformScale(rectTransform, image.scale, image.scale);
    
    // apply the transformation to the rect to create a new, shifted rect
    CGRect transformedCropSquare = CGRectApplyAffineTransform(rect, rectTransform);
    // use the rect to crop the image
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, transformedCropSquare);
    // create a new UIImage and set the scale and orientation appropriately
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    // memory cleanup
    CGImageRelease(imageRef);
    
    return result;
}

@end
