//
//  ViewController.m
//  ZJScrollViewDemo
//
//  Created by 尾灯 on 2019/9/1.
//  Copyright © 2019 尾灯. All rights reserved.
//

#import "ViewController.h"
#import "ZJTopView.h"
#import "ZJBottomView.h"

@interface ViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ZJTopView *topView;
@property (nonatomic, strong) ZJBottomView *bottomView;
@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPoint = CGPointZero;
    [self.view addSubview:self.topView];
    [self dragView];
    [self.bgView addSubview: self.tableView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        if (self.bottomView.frame.origin.y == 30) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

- (void)panEvent:(UIPanGestureRecognizer *)panGes
{
    CGPoint pointOffset = [panGes locationInView:self.view];
    CGPoint pointVelocity = [panGes velocityInView:self.bottomView];
    CGFloat distance = pointOffset.y - self.currentPoint.y;
    CGFloat afterY = self.bottomView.frame.origin.y + distance;
    if (panGes.state == UIGestureRecognizerStateBegan) {
        self.currentPoint = pointOffset;
    }else if (panGes.state == UIGestureRecognizerStateChanged) {
        if (afterY <= 30) {
            //滑动上界
            afterY = 30;
        }else if (afterY >= 300){
            //滑动下界
            afterY = 300;
        }
        self.bottomView.frame = CGRectMake(0, afterY, 375, 647);
        self.currentPoint = pointOffset;
    }else if (panGes.state == UIGestureRecognizerStateEnded){
        self.tableView.scrollEnabled = YES;
        if (pointVelocity.y <= 0) {
            //向上拖动
            if (afterY < 300 - 20) {
                [UIView animateWithDuration:0.25 animations:^{
                     self.bottomView.frame = CGRectMake(0, 30, 375, 647);
                }];
            }else{
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomView.frame = CGRectMake(0, 300, 375, 647);
                }];
            }
        }else{
            //向下拖动
            if (afterY > 30 + 20) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomView.frame = CGRectMake(0, 300, 375, 647);
                }];
            }else{
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomView.frame = CGRectMake(0, 30, 375, 647);
                }];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:self.bottomView];
    if (self.bottomView.frame.origin.y == 30) {
        //上界
        scrollView.scrollEnabled = YES;
    }else if(self.bottomView.frame.origin.y == 300){
        //下界
        if (velocity.y < 0) {
            //上滑
            scrollView.scrollEnabled = NO;
        }else{
            //下滑
            scrollView.scrollEnabled = YES;
        }
    }else{
        //中间
        scrollView.scrollEnabled = NO;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    return cell;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.bottomView.frame.size.width, self.bgView.frame.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (ZJTopView *)topView
{
    if (!_topView) {
        _topView = [[ZJTopView alloc] initWithFrame:CGRectMake(0, 0, 375, 300)];
        _topView.backgroundColor = [UIColor purpleColor];

    }
    return _topView;
}
- (ZJBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[ZJBottomView alloc] initWithFrame:CGRectMake(0, 300, 375, 647)];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}
- (UIView *)dragView
{
    if (!_dragView) {
        _dragView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 40)];
        _dragView.backgroundColor = [UIColor redColor];
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
        panGes.delegate = self;
        [_dragView addGestureRecognizer:panGes];
        [self.bottomView addSubview:_dragView];
    }
    return _dragView;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 375, 607)];
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
        panGes.delegate = self;
        _bgView.tag = 200;
        [_bgView addGestureRecognizer:panGes];
        [self.bottomView addSubview:_bgView];
    }
    return _bgView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
