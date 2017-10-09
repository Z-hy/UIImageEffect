//
//  ViewController.m
//  UIImageEffect
//
//  Created by user on 2017/9/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ViewController () {
    UIImageView *imageView;
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
    UIImageView *imageView4;
    UIImageView *imageView5;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadImage];
    [self converFormatTest];
    
    [self testImageGray];
    
    [self testImageReColor];
    
    [self testImageReColor2];
    
    [self testImageHighlight];
}

- (void)configImageController {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *mediaType = (__bridge NSString *)kUTTypeImage;
    
}

- (void)converFormatTest {
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    unsigned char *imageData = [self convertUIImageToData:image];
    
    UIImage *imageNew = [self converDataToUIImage:imageData image:image];
    imageView1.image = imageNew;
}

- (void)testImageGray {
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    unsigned char *imageData = [self convertUIImageToData:image];
    unsigned char *newImageData = [self imageGrayWithData:imageData width:image.size.width height:image.size.height];
    UIImage *imageNew = [self converDataToUIImage:newImageData image:image];
    imageView2.image = imageNew;
}

- (void)testImageReColor {
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    unsigned char *imageData = [self convertUIImageToData:image];
    unsigned char *newImageData = [self imageReColorWithData:imageData width:image.size.width height:image.size.height];
    UIImage *imageNew = [self converDataToUIImage:newImageData image:image];
    imageView3.image = imageNew;
}

- (void)testImageReColor2 {
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    unsigned char *imageData = [self convertUIImageToData:image];
    unsigned char *newImageData1 = [self imageGrayWithData:imageData width:image.size.width height:image.size.height];
    unsigned char *newImageData = [self imageReColorWithData:newImageData1 width:image.size.width height:image.size.height];
    UIImage *imageNew = [self converDataToUIImage:newImageData image:image];
    imageView4.image = imageNew;
}

- (void)testImageHighlight {
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    unsigned char *imageData = [self convertUIImageToData:image];
    unsigned char *newImageData = [self imageImageHighlightWithData:imageData width:image.size.width height:image.size.height];
    UIImage *imageNew = [self converDataToUIImage:newImageData image:image];
    imageView5.image = imageNew;
}

- (void)loadImage {
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 20, 180, 135)];
    [self.view addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"1.jpg"];
    
    imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(18+180+18, 20, 180, 135)];
    [self.view addSubview:imageView1];
    imageView1.image = [UIImage imageNamed:@"1.jpg"];
    
    imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(18, 20+135+20, 180, 135)];
    [self.view addSubview:imageView2];
    imageView2.image = [UIImage imageNamed:@"1.jpg"];
    
    imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(18+180+18, 20+135+20, 180, 135)];
    [self.view addSubview:imageView3];
    imageView3.image = [UIImage imageNamed:@"1.jpg"];
    
    imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(18, 20+135+20+135+20, 180, 135)];
    [self.view addSubview:imageView4];
    imageView4.image = [UIImage imageNamed:@"1.jpg"];
    
    imageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(18+180+18, 20+135+20+135+20, 180, 135)];
    [self.view addSubview:imageView5];
    imageView5.image = [UIImage imageNamed:@"1.jpg"];
}

// unsigned char*  指针
// 1.UIImage -> CGImage
// 2.CGColorSpace
// 3.分配bit级空间
// 4.CGBitmap
// 5.渲染
- (unsigned char*)convertUIImageToData:(UIImage *)image {
    // 1
    CGImageRef imageRef = [image CGImage];
    CGSize image_size = image.size;
    
    // 2
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 每个像素点 4个Byte R G B A 像素点的个数 = 宽 * 高
    // malloc 内存分配
    void *data = malloc(image_size.width * image_size.height * 4);
    
    // 4
    CGContextRef contextRef = CGBitmapContextCreate(data, image_size.width, image_size.height, 8, 4 * image_size.width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    // 5
    CGContextDrawImage(contextRef, CGRectMake(0, 0, image_size.width, image_size.height), imageRef);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(contextRef);
    
    return (unsigned char*)data;
}

- (UIImage *)converDataToUIImage:(unsigned char*)imageData image:(UIImage *)imageSource {
    CGFloat width = imageSource.size.width;
    CGFloat height = imageSource.size.height;
    
    NSInteger dataLen = width * height * 4;
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imageData, dataLen, NULL);
    
    int bitPerComponent = 8;
    int bitPerPixel = 32;
    int bytesPerRow = 4 * width;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    
    CGColorRenderingIntent renderIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageRef = CGImageCreate(width, height, bitPerComponent, bitPerPixel, bytesPerRow, colorSpace, bitmapInfo, provider, NULL, NULL, renderIntent);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
    
    return  image;
}

// 灰度特效图片
- (unsigned char *)imageGrayWithData:(unsigned char *)imageData width:(CGFloat)width height:(CGFloat)height {
    // 分配内存空间
    unsigned char *resultData = malloc(width * height * sizeof(unsigned char *)*4);
    // 将内存空间清0
    memset(resultData, 0, width * height * sizeof(unsigned char *)*4);
    //
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            unsigned int imageIndex = h * width + w;
            // 像素RGBA  == 4Byte
            
            unsigned char bitmapRed = *(imageData + imageIndex * 4);
            unsigned char bitmapGreen = *(imageData + imageIndex * 4 + 1);
            unsigned char bitmapBlue = *(imageData + imageIndex * 4 + 2);

            int bitmap = bitmapRed * 77/255 + bitmapGreen * 151/255 + bitmapBlue * 88/255;
            
            unsigned char newBitmap = (bitmap > 255) ? 255 : bitmap;
            
            memset(resultData + imageIndex * 4, newBitmap, 1);
            memset(resultData + imageIndex * 4 + 1, newBitmap, 1);
            memset(resultData + imageIndex * 4 + 2, newBitmap, 1);
        }
    }
    return resultData;
}

// 颜色反转
- (unsigned char *)imageReColorWithData:(unsigned char *)imageData width:(CGFloat)width height:(CGFloat)height {
    // 分配内存空间
    unsigned char *resultData = malloc(width * height * sizeof(unsigned char *)*4);
    // 将内存空间清0
    memset(resultData, 0, width * height * sizeof(unsigned char *)*4);
    //
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            unsigned int imageIndex = h * width + w;
            // 像素RGBA  == 4Byte
            
            unsigned char bitmapRed = *(imageData + imageIndex * 4);
            unsigned char bitmapGreen = *(imageData + imageIndex * 4 + 1);
            unsigned char bitmapBlue = *(imageData + imageIndex * 4 + 2);
            
            
            unsigned char bitmapRedNew = 255 - bitmapRed;
            unsigned char bitmapGreenNew = 255 - bitmapGreen;
            unsigned char bitmapBlueNew = 255 - bitmapBlue;

            
            memset(resultData + imageIndex * 4, bitmapRedNew, 1);
            memset(resultData + imageIndex * 4 + 1, bitmapGreenNew, 1);
            memset(resultData + imageIndex * 4 + 2, bitmapBlueNew, 1);
        }
    }
    return resultData;
}

// 图片美白
- (unsigned char *)imageImageHighlightWithData:(unsigned char *)imageData width:(CGFloat)width height:(CGFloat)height {
    // 分配内存空间
    unsigned char *resultData = malloc(width * height * sizeof(unsigned char *)*4);
    // 将内存空间清0
    memset(resultData, 0, width * height * sizeof(unsigned char *)*4);
    
    NSArray *colorArrayBase = @[@"55",@"110",@"155",@"185",@"220",@"240",@"250",@"255"];
    NSMutableArray *colorArray = [[NSMutableArray alloc] init];
    
    int beforNum = 0;
    for (int i = 0; i < colorArrayBase.count; i++) {
        NSString *numStr = colorArrayBase[i];
        int num = numStr.intValue;
        float step = 0;
        if (i == 0) {
            step = num/32.0;
            beforNum = num;
        } else {
            step = (num - beforNum)/32.0;
        }
        for (int j = 0; j < 32; j++) {
            int newNum = 0;
            if (i == 0) {
                newNum = j*step;
            } else {
                newNum = beforNum + j*step;
            }
            NSString *newNumStr = [NSString stringWithFormat:@"%d", newNum];
            [colorArray addObject:newNumStr];
        }
        beforNum = num;
    }
    
    //
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            unsigned int imageIndex = h * width + w;
            // 像素RGBA  == 4Byte
            
            unsigned char bitmapRed = *(imageData + imageIndex * 4);
            unsigned char bitmapGreen = *(imageData + imageIndex * 4 + 1);
            unsigned char bitmapBlue = *(imageData + imageIndex * 4 + 2);
            
            
            NSString *redStr = [colorArray objectAtIndex:bitmapRed];
            NSString *greenStr = [colorArray objectAtIndex:bitmapGreen];
            NSString *blueStr = [colorArray objectAtIndex:bitmapBlue];
            
            unsigned char bitmapRedNew = redStr.intValue;
            unsigned char bitmapGreenNew = greenStr.intValue;
            unsigned char bitmapBlueNew = blueStr.intValue;
            
            memset(resultData + imageIndex * 4, bitmapRedNew, 1);
            memset(resultData + imageIndex * 4 + 1, bitmapGreenNew, 1);
            memset(resultData + imageIndex * 4 + 2, bitmapBlueNew, 1);
        }
    }
    return resultData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
