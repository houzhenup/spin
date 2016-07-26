//
//  RootViewController.m
//  WheelDemo
//
//  Created by 车友物流 on 16/5/4.
//  Copyright © 2016年 GBQ_technology. All rights reserved.
//

#import "RootViewController.h"

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height

@interface RootViewController ()
{
    NSString *strPrise;
}

@property(nonatomic,retain)UIView *popView;
@property(nonatomic,retain)UILabel *labPrise;         //抽奖结果展示Label
@property(nonatomic,retain)UIButton *btn;
@property(nonatomic,retain)UIImageView *wheel;

@end

@implementation RootViewController

@synthesize btn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

#pragma mark  --创建视图
-(void)creatUI
{
      //背景
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgImgView.image=[UIImage imageNamed:@"bg.png"];
    [self.view addSubview:bgImgView];
    //转盘
    _wheel = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth-280)/2, 20, 280, 280)];
    _wheel.image = [UIImage imageNamed:@"zhuanpan.png"];
    [self.view addSubview:_wheel];
    //指针
    UIImageView *hander = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    hander.center = CGPointMake(_wheel.center.x, _wheel.center.y);
    hander.image = [UIImage imageNamed:@"hander.png"];
    [self.view addSubview:hander];
    
    //抽奖结果展示Label
    _labPrise = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_wheel.frame), CGRectGetMaxY(_wheel.frame)+50, CGRectGetWidth(_wheel.frame), 20)];
    _labPrise.backgroundColor = [UIColor greenColor];
    _labPrise.textColor = [UIColor orangeColor];
    _labPrise.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_labPrise];
    
    //抽奖按钮
    btn = [[UIButton alloc] initWithFrame:CGRectMake((kWidth-200)/2, CGRectGetMaxY(_labPrise.frame)+50, 200, 35)];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor yellowColor];
    btn.layer.borderColor = [UIColor orangeColor].CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.cornerRadius = 5.0f;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
}

#pragma mark   --抽奖按钮的点击事件
-(void)btnClick:(UIButton *)sender
{
    NSInteger angle;//角度
    NSInteger randomNum = arc4random()%100;//随机数
    if (randomNum>=91 && randomNum<=99) {
        
        angle = 300;
        strPrise = @"一等奖";
    }else if (randomNum>=76 && randomNum<=90)
    {
        angle = 60;
        strPrise = @"二等奖";
    }else if (randomNum>=51 && randomNum<=75)
    {
        angle = 180;
        strPrise = @"三等奖";
    }else
    {
        angle = 240;
        strPrise = @"再接再厉";
    }
    [btn setTitle:@"抽奖中" forState:UIControlStateNormal];
    _labPrise.text = [NSString stringWithFormat:@"中奖结果:等待开奖结果"];
    btn.enabled = NO;
    
    
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"]; // "z"还可以是“x”“y”，表示沿z轴旋转
    rotationAnimation.toValue = [NSNumber numberWithFloat:angle*M_PI/180];
    rotationAnimation.duration = 1.0f;
    rotationAnimation.cumulative = YES; //是否循环
    rotationAnimation.delegate = self;
    rotationAnimation.fillMode = kCAFillModeForwards; //当动画完成时，保留在动画结束的状态
    rotationAnimation.removedOnCompletion = NO;//完成后是否回到原来状态，如果为NO 就是停留在动画结束时的状态
    [_wheel.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
  
    

}

#pragma mark --动画结束
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
[UIView animateWithDuration:3.0 animations:^{
    
    _popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kWidth, kHeight)];
    _popView.backgroundColor = [UIColor clearColor];
    _popView.transform = CGAffineTransformMakeScale(2, 2);//缩放:设置缩放比例）仅通过设置缩放比例就可实现视图扑面而来和缩进频幕的效果。
    [self.view addSubview:_popView];
    
    UIImageView *popImgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 150, kWidth-200, kWidth-200)];
    popImgView.image = [UIImage imageNamed:@"prise.png"];
    [_popView addSubview:popImgView];
    
    
    
} completion:^(BOOL finished) {
    
    [_popView removeFromSuperview];
    _labPrise.text = [NSString stringWithFormat:@"中奖结果:%@",strPrise];
    [btn setTitle:@"开始抽奖" forState:UIControlStateNormal];
    btn.enabled = YES;
    
}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
