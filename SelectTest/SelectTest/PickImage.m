//
//  PickImage.m
//  SelectTest
//
//  Created by xuzifu on 16/2/19.
//  Copyright © 2016年 xuzifu. All rights reserved.
//

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#import "PickImage.h"

@interface PickImage ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *picker;

@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, assign) BOOL isLeft;


@end

@implementation PickImage

- (void)pickImageWithViewController:(UIViewController *)controller isLeftPicture:(BOOL)isLeft
{
    self.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickImage)];
    [self addGestureRecognizer:guesture];
    self.userInteractionEnabled = YES;
    _controller = controller;
    _isLeft = isLeft;
}

- (void)pickImage
{
    if (self.image == nil) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //取消...
            
        }];
        
        UIAlertAction *photo = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //拍照...
            
            //判断是否有摄像头
            BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
            
            if (!isCamera) {
                //提示用户没有摄像头
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
                [alertCtrl addAction:action];
                [self.controller presentViewController:alertCtrl animated:YES completion:nil];
                
                
                return;
            }
            
            _picker = [[UIImagePickerController alloc] init];
            
            //图像来源于相机
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            _picker.delegate = self;
            
            [self.controller presentViewController:_picker animated:YES completion:nil];
            
        }];
        
        UIAlertAction *xiangce = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //相册
            _picker = [[UIImagePickerController alloc] init];
            _picker.delegate = self;
            //图像来源于相册
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self.controller presentViewController:_picker animated:YES completion:nil];
        }];
        
        [alertCtrl addAction:photo];
        [alertCtrl addAction:xiangce];
        [alertCtrl addAction:cancle];
        
        [self.controller presentViewController:alertCtrl animated:YES completion:nil];
    }else {
        //初始化子视图
        [self _initViews];
        
        //给子视图_fullImageView一个frame
        //获取该子视图相对于另一个视图的frame
        CGRect rect = [self convertRect:self.bounds toView:self.window];
        NSLog(@"%@", NSStringFromCGRect(rect));
        _fullImageView.frame = rect;
        
        //实现放大的动画
        [UIView animateWithDuration:0.35
                         animations:^{
                             
                             if ([self.zoomDelegate respondsToSelector:@selector(zoomImgDidIn)]) {
                                 [self.zoomDelegate zoomImgDidIn];
                             }
                             
                             CGFloat height = kScreenWidth / (self.image.size.width / self.image.size.height);
                             
                             _fullImageView.frame = CGRectMake(0, 0, kScreenWidth, MAX(height, kScreenHeight));
                             _scrollView.contentSize = CGSizeMake(kScreenWidth, height);
                             
                         }
                         completion:^(BOOL finished) {
                             if (_fullImageUrl == nil) {
                                 //没有大图地址
                                 return;
                             }
                             
                         }];

    }
}

#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"imageView:%@", image);
    
    if (_isLeft) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectLeftPicture" object:image];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectRightPicture" object:image];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//初始化子视图
- (void)_initViews
{
    //创建滑动视图
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.backgroundColor = [UIColor redColor];
        
        //在滑动视图上添加缩小的手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutImageView:)];
        [_scrollView addGestureRecognizer:tap];
    }
    [self.window addSubview:_scrollView];
    
    //创建放大视图
    if (_fullImageView == nil) {
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.image = self.image;
        _fullImageView.contentMode = self.contentMode;
        [_scrollView addSubview:_fullImageView];
    }
    
}

//缩小
- (void)zoomOutImageView:(UITapGestureRecognizer *)tap
{
    //执行缩小的方法
    [UIView animateWithDuration:0.35
                     animations:^{
                         if ([self.zoomDelegate respondsToSelector:@selector(zoomImgDidOut)]) {
                             [self.zoomDelegate zoomImgDidOut];
                         }
                         _fullImageView.frame = [self convertRect:self.bounds toView:self.window];
                         _scrollView.backgroundColor = [UIColor clearColor];
                         
                     }
                     completion:^(BOOL finished) {
                         [_fullImageView removeFromSuperview];
                         _fullImageView = nil;
                         
                         [_scrollView removeFromSuperview];
                         _scrollView = nil;
                     }];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
