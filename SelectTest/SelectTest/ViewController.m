//
//  ViewController.m
//  SelectTest
//
//  Created by xuzifu on 16/2/19.
//  Copyright © 2016年 xuzifu. All rights reserved.
//

#import "ViewController.h"

#import "PickImage.h"

@interface ViewController ()

@property (nonatomic, strong) PickImage *leftPick;
@property (nonatomic, strong) PickImage *rightPick;

@property (nonatomic, strong) UIButton *deleteLeftButton;
@property (nonatomic, strong) UIButton *deleteRightButton;

@property (nonatomic, strong) UIButton *sureButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLeftPic:) name:@"selectLeftPicture" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRightPic:) name:@"selectRightPicture" object:nil];
}

- (void)createUI
{
    _leftPick = [[PickImage alloc] init];
    _leftPick.frame = CGRectMake(50, 200, 80, 80);
    _leftPick.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"my__picture"]];
    [_leftPick pickImageWithViewController:self isLeftPicture:YES];
    [self.view addSubview:_leftPick];
    
    _rightPick = [[PickImage alloc] init];
    _rightPick.frame = CGRectMake(200, 200, 80, 80);
    _rightPick.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"my__picture"]];
    [_rightPick pickImageWithViewController:self isLeftPicture:NO];
    [self.view addSubview:_rightPick];
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.backgroundColor = [UIColor blueColor];
    _sureButton.frame = CGRectMake(300, 500, 100, 50);
    [_sureButton addTarget:self action:@selector(sureButtonA) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sureButton];
    
}

- (void)getLeftPic:(NSNotification *)noti
{
    UIImage *img = noti.object;
    NSLog(@"leftImg:%@", img);
    
    _deleteLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteLeftButton.backgroundColor = [UIColor redColor];
    _deleteLeftButton.frame = CGRectMake(120, 190, 20, 20);
    [_deleteLeftButton addTarget:self action:@selector(deleteLeftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteLeftButton];
    
}

- (void)getRightPic:(NSNotification *)noti
{
    UIImage *img = noti.object;
    NSLog(@"rightImg:%@", img);
    
    _deleteRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteRightButton.backgroundColor = [UIColor redColor];
    _deleteRightButton.frame = CGRectMake(270, 180, 20, 20);
    [_deleteRightButton addTarget:self action:@selector(deleteRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteRightButton];
}

- (void)deleteLeftButtonAction
{
//    [_onePick removeFromSuperview];
    _leftPick.image = nil;
    [_deleteLeftButton removeFromSuperview];
    _deleteLeftButton = nil;
}

- (void)deleteRightButtonAction
{
    _rightPick.image = nil;
    [_deleteRightButton removeFromSuperview];
    _deleteRightButton = nil;
}

- (void)sureButtonA
{
    NSLog(@"leftImg:%@------rightImg:%@", _leftPick.image, _rightPick.image);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
