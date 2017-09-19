//
//  ViewController.m
//  自定义图片截取
//
//  Created by zx on 2017/9/13.
//  Copyright © 2017年 maple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIImagePickerController *imagePickerController;
    UIButton *btn;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [self.clickBtn setTitle:@"点击" forState:UIControlStateNormal];
    self.clickBtn.backgroundColor = [UIColor redColor];
    [self.clickBtn addTarget:self action:@selector(doSth) forControlEvents:UIControlEventTouchDown];
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(150, 250, 200, 200)];
    
    _img = [[UIImage alloc]init];
    
    [self.view addSubview:self.clickBtn];
    [self.view addSubview:_imgView];
    
    self.clickBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
}

-(void)doSth {
    NSLog(@"do something!");
    
    //处理点击从相册选取
    NSUInteger sourceType = 0;
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    //这里设置是是否进入系统的自定义裁剪
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = nil;
        
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _img = image;
    
    _cropImageView = [[CropView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [_cropImageView initRec];
    _cropImageView.backgroundColor = [UIColor blackColor];
    [_cropImageView loadImg:_img];
    [_cropImageView setSize:CGSizeMake(200, 200)];
    [self.view addSubview:_cropImageView];
    
    btn = [[UIButton alloc]init];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(100, 100, 100, 50)];
    [btn setTitle:@"点击截取" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(cropImg) forControlEvents:UIControlEventTouchUpInside];
    
//    [_imgView setImage:_img];;
    
}

-(void)cropImg{
    [_imgView setImage:[_cropImageView captureScreen]];
    [_cropImageView removeFromSuperview];
    [btn removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
