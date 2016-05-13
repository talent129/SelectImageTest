//
//  PickImage.h
//  SelectTest
//
//  Created by xuzifu on 16/2/19.
//  Copyright © 2016年 xuzifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZoomImgDidDelegate <NSObject>

@optional

//图片已经放大
- (void)zoomImgDidIn;

//图片已经缩小
- (void)zoomImgDidOut;

@end

@interface PickImage : UIImageView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *fullImageView;
@property (nonatomic, strong) NSString *fullImageUrl;
@property (nonatomic, weak) id<ZoomImgDidDelegate>zoomDelegate;

- (void)pickImageWithViewController:(UIViewController *)controller isLeftPicture:(BOOL)isLeft;

@end
