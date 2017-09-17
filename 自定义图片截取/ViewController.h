//
//  ViewController.h
//  自定义图片截取
//
//  Created by zx on 2017/9/13.
//  Copyright © 2017年 maple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropView.h"
@interface ViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate
                                             ,UINavigationControllerDelegate>
{
    CropView *_cropImageView;
    
    UIImageView *_imgView;
    
    UIImage *_img;
}

@property(nonatomic,strong)UIButton *btn;



@end

