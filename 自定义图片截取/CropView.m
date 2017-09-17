//
//  CropView.m
//  自定义图片截取
//
//  Created by zx on 2017/9/15.
//  Copyright © 2017年 maple. All rights reserved.
//

#import "CropView.h"

@implementation CropView
{
    CGRect frame;
    BOOL isBig;
    //   UIImage *_img;
    
    UIButton *_btn;
    UIImageView *_imageView;
    UIImage *_img;
    UIScrollView *_scrollView;
    UIEdgeInsets  _imageInset;
}


//自定义初始化
-(void)initRec{
    isBig = true;
    frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _scrollView.delegate = self;
    _scrollView.clipsToBounds = NO;
    _scrollView.showsHorizontalScrollIndicator = YES;//是否显示侧边的滚动栏
    _scrollView.showsVerticalScrollIndicator = NO;
    
     [self addSubview:_scrollView];
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [_scrollView addGestureRecognizer:doubleTapGesture];
    [_scrollView setMinimumZoomScale:0.8f];
    [_scrollView setMaximumZoomScale:1.2f];
    [_scrollView setZoomScale:0.5f animated:NO];
    
    
    
}

- (void)loadImg:(UIImage *)img {
    float width;
    float height;
    //判断图片是否超出屏幕大小
    if(img.size.width > self.bounds.size.width)
    {
        width =self.bounds.size.width;
    }
    else
    {
        width =img.size.width;
    }
    if(img.size.height > self.bounds.size.height)
    {
        height =self.bounds.size.height;
    }
    else
    {
        height =img.size.height;
    }
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
//    _imageView.center = _scrollView.center;
    [_scrollView addSubview:_imageView];
    
    _img = img;
    [_imageView setImage:_img];
    
}

- (void)setSize:(CGSize)cropSize {
    self._size = cropSize;
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self._size.height, self._size.width)];
    maskView.center = self.center;
    maskView.backgroundColor = [UIColor clearColor];
    maskView.layer.borderWidth = 0.5;
    maskView.layer.borderColor = [UIColor whiteColor].CGColor;
    maskView.userInteractionEnabled = NO;
    [self addSubview:maskView];
    
    _scrollView.contentSize = CGSizeMake(_img.size.height,_img.size.width);
    
    CGFloat width = cropSize.width;
    CGFloat height = cropSize.height;
    CGFloat x = (CGRectGetWidth(self.bounds) - width) / 2;
    CGFloat y = (CGRectGetHeight(self.bounds) - height) / 2;
    
    CGFloat top = y;
    CGFloat left = x;
    CGFloat right = CGRectGetWidth(self.bounds)- width - x;
    CGFloat bottom = CGRectGetHeight(self.bounds)- height - y;
    _imageInset = UIEdgeInsetsMake(top, left, bottom, right);
    [_scrollView setContentInset:_imageInset];
    
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    
    
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    CGFloat scale = recognizer.scale;
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, scale, scale); //在已缩放大小基础下进行累加变化；区别于：使用 CGAffineTransformMakeScale 方法就是在原大小基础下进行变化
    recognizer.scale = 1.0;
}
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateEnded && recognizer.state != UIGestureRecognizerStateFailed){
        CGPoint translation = [recognizer translationInView:self];
        CGPoint center = _imageView.center;
        _imageView.center = CGPointMake(center.x + translation.x, center.y + translation.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    }
}

- (UIImage *)captureScreen {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //CGImageCreateWithImageInRect用的是c的方法，使用的rect是像素点
    //而ios使用的是点坐标，所以想乘[UIScreen mainScreen].scale进行转换
    img = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake((self.center.x-self._size.width/2)*[UIScreen mainScreen].scale, (self.center.y-self._size.height/2)*[UIScreen mainScreen].scale, self._size.height*[UIScreen mainScreen].scale, self._size.width*[UIScreen mainScreen].scale))];
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"height:%f,width:%f",_scrollView.contentSize.height,_scrollView.contentSize.width);
}
//
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
//    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width-scrollView.contentSize.width)/2:0.0;
//    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height-scrollView.contentSize.height)/2:0.0;
//    _imageView.center = CGPointMake(offsetX, offsetY);
//}

#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    float newScale;
    if(isBig){
        isBig = false;
        newScale = _scrollView.zoomScale * 1.5;
    }else{
        isBig = true;
        newScale = _scrollView.zoomScale / 1.5;
    }
    NSLog(@"handleDoubleTap");
    //zoomScale这个值决定了contents当前扩展的比例
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [_scrollView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = _scrollView.frame.size.height / scale;
    zoomRect.size.width  = _scrollView.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
