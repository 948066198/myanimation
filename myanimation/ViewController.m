//
//  ViewController.m
//  myanimation
//
//  Created by spp on 16/12/6.
//  Copyright © 2016年 spp. All rights reserved.
//

#import "ViewController.h"

#define kWidth [UIScreen mainScreen].bounds.size.width

#define kHeight [UIScreen mainScreen].bounds.size.height

#define AHeight 350 //动画路径高度

@interface ViewController ()

@property(nonatomic,strong)UIButton *Btn;

@property(nonatomic,strong)UILabel *NumLab;

@property(nonatomic,assign)NSInteger Num;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

-(void)createUI{
    
    //点赞按钮
    self.Btn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-30, kHeight/2-30, 60, 60)];
    
    [self.Btn setImage:[UIImage imageNamed:@"0"] forState:UIControlStateNormal];
    
    [self.Btn setImage:[UIImage imageNamed:@"0"] forState:UIControlStateHighlighted];
    
    self.Btn.contentMode = UIViewContentModeScaleToFill;
    
    [self.Btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.Btn];
    
    //点赞次数
    self.NumLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 44, 50, 12)];
    
    self.NumLab.text = @"0";
    
    self.NumLab.textColor = [UIColor whiteColor];
    
    self.NumLab.font = [UIFont systemFontOfSize:12];
    
    self.NumLab.textAlignment = NSTextAlignmentCenter;
    
    [self.Btn addSubview:self.NumLab];
    
    //初始化数据
    self.Num = 0;
    
}

//点击事件
-(void)btnClick{
    
    self.Num++;
    
    self.NumLab.text = [NSString stringWithFormat:@"%ld",self.Num];
    
    //设置动画
    [self setAnimation];
}

//点赞动画
-(void)setAnimation{
    
    NSInteger index = arc4random_uniform(7)+1;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-20, kHeight/2-20, 40, 40)];
    
    [self.view insertSubview:imgView belowSubview:self.Btn];
    
    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",index]];
    
    //弹出动画
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        imgView.transform = CGAffineTransformIdentity;
        
        imgView.alpha = 0.9;
        
    } completion:nil];
    
    //随机偏转角度
    NSInteger i = arc4random_uniform(2);
    NSInteger rotationDirection = 1-(2*i); //向左或向右
    NSInteger rotationFraction = arc4random_uniform(10); //随机角度
    //上升中的旋转动画
    [UIView animateWithDuration:4 animations:^{
        
        imgView.transform = CGAffineTransformMakeRotation(rotationDirection*M_PI/(4+rotationFraction*0.3));
    }];
    
    //动画路径
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    //起点
    [bezier moveToPoint:imgView.center];
    
    //随机终点
    CGFloat ViewX = imgView.center.x;
    CGFloat ViewY = imgView.center.y;
    CGPoint endPoint = CGPointMake(ViewX+rotationDirection*10, ViewY-AHeight);
    
    //设置折返点
    NSInteger j = arc4random_uniform(2);
    NSInteger travelDirection = 1- (2*j);//向左或向右
    
    NSInteger m1 = ViewX+travelDirection*(arc4random_uniform(20)+50);
    NSInteger n1 = ViewY - 60 + travelDirection*arc4random_uniform(20);
    NSInteger m2 = ViewX - travelDirection*(arc4random_uniform(20) + 50);
    NSInteger n2 = ViewY - 90 + travelDirection*arc4random_uniform(20);
    
    CGPoint point1 = CGPointMake(m1, n1);
    CGPoint point2 = CGPointMake(m2, n2);
    
    //根据贝塞尔曲线添加动画
    [bezier addCurveToPoint:endPoint controlPoint1:point1 controlPoint2:point2];
    
    //关键帧动画，实现整体图片位移
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyframeAnimation.path = bezier.CGPath;
    keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    keyframeAnimation.duration = 3;
    [imgView.layer addAnimation:keyframeAnimation forKey:@"positionOnPath"];
    
    //消失动画
    [UIView animateWithDuration:3 animations:^{
        imgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [imgView removeFromSuperview];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
