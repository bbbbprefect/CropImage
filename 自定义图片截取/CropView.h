//
//  CropView.h
//  自定义图片截取
//
//  Created by zx on 2017/9/15.
//  Copyright © 2017年 maple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropView : UIView<UIScrollViewDelegate>

@property(nonatomic,assign)CGSize _size;


- (void)loadImg:(UIImage *)img;
- (void)setSize:(CGSize)size;
-(void)initRec;

- (UIImage *)captureScreen;

@end
