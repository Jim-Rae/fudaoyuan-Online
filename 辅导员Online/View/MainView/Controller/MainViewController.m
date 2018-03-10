//
//  MainViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/5.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "MainViewController.h"
#import "XYSideViewController.h"
#import "UIViewController+XYSideCategory.h"
#import "MyLayout.h"
#import "MyCollectionViewCell.h"
#import "ListViewController.h"
#import "ViewModel.h"
#import "PassageViewController.h"
#import "ProgressHUD.h"
#import "AppDelegate.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *iconImgArray;
@property (nonatomic, strong) NSArray *iconTitleArray;
@property (nonatomic, strong) NSArray *topImgArray;
@property (nonatomic, strong) NSArray *topTitleArray;
@property (nonatomic, strong) NSArray<PassageListModel *> *listArr;

@property (nonatomic, strong) MyLayout * layout;
@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) UIVisualEffectView * effectView; //毛玻璃视觉管理类
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture0;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture1;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture2;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture3;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture4;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture5;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture6;

@property (nonatomic, assign) BOOL flag;

@end

@implementation MainViewController

//添加观察者
-(void)addObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hadNetwork) name:@"hadNetwork" object:nil];
}

//移除观察者
-(void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hadNetwork" object:nil];
}

-(void)hadNetwork{
    if (_flag) {
        [ProgressHUD showProgressHUD:@"获取数据中..."];
        [ViewModel getPassageListWithSid:@"10" pageNo:@"0" pageSize:@"5" finish:^(BOOL success, NSArray<PassageListModel *> *listArr) {
            if (success) {
                _listArr = listArr;
                _topTitleArray = @[_listArr[0].title, _listArr[1].title, _listArr[2].title, _listArr[3].title, _listArr[4].title];
                [ProgressHUD hideAllHUDAnimated:YES];
            } else {
                if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                    [self showAlertControllerWithTitle:@"获取数据失败" message:@"服务器内部错误" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                } else {
                    [self showAlertControllerWithTitle:@"获取数据失败" message:@"请检查网络连接情况" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                }
            }
        }];
    }
}

-(void)dealloc{
    [self removeObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"基地推荐";
    _flag = NO;
    [self addObserver];
    //修改back按钮
    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    backIetm.title = @"返回";
    self.navigationItem.backBarButtonItem = backIetm;
    
    UIBarButtonItem * menuItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_menu_white"] style:UIBarButtonItemStylePlain target:self action:@selector(menu)];
    self.navigationItem.leftBarButtonItem = menuItem;
    
    _iconImgArray = @[@"main_receipt", @"main_home", @"main_paint", @"main_people", @"main_school", @"main_entrepreneurship", @"main_flea", @"main_forum", @"main_videocam"];
    _iconTitleArray = @[@"公告咨询", @"心灵驿站", @"名工作室", @"榜样人物", @"校园文化", @"创业就业", @"跳蚤市场", @"学术论坛", @"先锋视频"];
    _topImgArray = @[@"topPic1",@"topPic2",@"topPic3",@"topPic4",@"topPic5"];
    _topTitleArray = @[@"",@"",@"",@"",@""];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.effectView];
    [self.view addSubview:self.myView];
    [self.myView addSubview:self.pageControl];
    [self.myView addSubview:self.collectionView];
    [self.view addSubview:self.topLabel];
    
    [self.timer fire];
    //设置自动滚动定时任务
    [self initTimerFunction];

    [ProgressHUD showProgressHUD:@"获取数据中..."];
    [ViewModel getPassageListWithSid:@"10" pageNo:@"0" pageSize:@"5" finish:^(BOOL success, NSArray<PassageListModel *> *listArr) {
        if (success) {
            _listArr = listArr;
            _topTitleArray = @[_listArr[0].title, _listArr[1].title, _listArr[2].title, _listArr[3].title, _listArr[4].title];
            [ProgressHUD hideAllHUDAnimated:YES];
        } else {
            if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                [self showAlertControllerWithTitle:@"获取数据失败" message:@"服务器内部错误" handler:nil];
                [ProgressHUD hideAllHUDAnimated:NO];
            } else {
                [self showAlertControllerWithTitle:@"获取数据失败" message:@"请检查网络连接情况" handler:nil];
                [ProgressHUD hideAllHUDAnimated:NO];
                _flag = YES;
            }
        }
    }];
}

-(void)menu{
    [self XYSideOpenVC];
}

-(void)initTimerFunction{
    //创建计时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoSelectPage) userInfo:nil repeats:YES];
    NSRunLoop *mainLoop = [NSRunLoop mainRunLoop];
    
    [mainLoop addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

-(void)autoSelectPage{
    //通过改变contentOffset来切换滚动视图的子界面
    float offset_X = _scrollView.contentOffset.x;
    //每次切换一个屏幕
    offset_X += SCREEN_WIDTH;
    
    //说明要从最右边的多余视图开始滚动了，最右边的多余视图实际上就是第一个视图。所以偏移量需要更改为第一个视图的偏移量。
    if (offset_X > SCREEN_WIDTH*6) {
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        
    }
    //说明正在显示的就是最右边的多余视图，最右边的多余视图实际上就是第一个视图。所以pageControl的小白点需要在第一个视图的位置。
    if (offset_X == SCREEN_WIDTH*6) {
        self.pageControl.currentPage = 0;
        [UIView transitionWithView:_imageView duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _topLabel.text = _topTitleArray[self.pageControl.currentPage];
            _imageView.image = [UIImage imageNamed:_topImgArray[self.pageControl.currentPage]];
        } completion:nil];
    }
    else if(offset_X > SCREEN_WIDTH*6){
        self.pageControl.currentPage = 1;
        [UIView transitionWithView:_imageView duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _topLabel.text = _topTitleArray[self.pageControl.currentPage];
            _imageView.image = [UIImage imageNamed:_topImgArray[self.pageControl.currentPage]];
        } completion:nil];
    }
    else{
        self.pageControl.currentPage = offset_X/SCREEN_WIDTH-1;
        [UIView transitionWithView:_imageView duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _topLabel.text = _topTitleArray[self.pageControl.currentPage];
            _imageView.image = [UIImage imageNamed:_topImgArray[self.pageControl.currentPage]];
        } completion:nil];
    }
    
    //得到最终的偏移量
    CGPoint resultPoint = CGPointMake(offset_X, 0);
    //切换视图时带动画效果
    //最右边的多余视图实际上就是第一个视图，现在是要从第一个视图向第二个视图偏移，所以偏移量为一个屏幕宽度
    if (offset_X >SCREEN_WIDTH*6) {
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
    }else{
        [_scrollView setContentOffset:resultPoint animated:YES];
    }
    
}

- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT*0.4f, SCREEN_WIDTH-40, SCREEN_HEIGHT*0.1f)];
        _topLabel.font = [UIFont systemFontOfSize:22];
        _topLabel.adjustsFontSizeToFitWidth = YES;
        _topLabel.minimumScaleFactor = 0.5f;
        _topLabel.textColor = [UIColor whiteColor];
        _topLabel.text = _topTitleArray[0];
        _topLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topLabel;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        //设置frame
        _scrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT*0.5f-64);
        //设置滑动范围
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*7, SCREEN_HEIGHT*0.5f-64);
        //设置水平指示器
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        //设置分页效果
        _scrollView.pagingEnabled = YES;
        //设置代理
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        _tapGesture0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesure5)];
        _tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesure1)];
        _tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesure2)];
        _tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesure3)];
        _tapGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesure4)];
        _tapGesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesure5)];
        _tapGesture6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesure1)];
        
        UIImageView *imageViewHead = [[UIImageView alloc]init];
        //设置frame
        imageViewHead.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.5f-64);
        //设置显示 图片
        imageViewHead.image = [UIImage imageNamed:_topImgArray[4]];
        imageViewHead.userInteractionEnabled = YES;
        [imageViewHead addGestureRecognizer:_tapGesture0];
        //添加到sctollview
        [_scrollView addSubview:imageViewHead];
        
        for (int i =1; i<6; i++) {
            //计算每个 UIImageView 的 X 轴坐标
            CGFloat imagex= i*SCREEN_WIDTH;
            //创建初始化Imageview
            UIImageView *imageView = [[UIImageView alloc]init];
            //设置frame
            imageView.frame = CGRectMake(imagex, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.5f-64);
            //设置显示 图片
            imageView.image = [UIImage imageNamed:_topImgArray[i-1]];
            imageView.userInteractionEnabled = YES;
            
            switch (i) {
                case 1:
                    [imageView addGestureRecognizer:_tapGesture1];
                    break;
                case 2:
                    [imageView addGestureRecognizer:_tapGesture2];
                    break;
                case 3:
                    [imageView addGestureRecognizer:_tapGesture3];
                    break;
                case 4:
                    [imageView addGestureRecognizer:_tapGesture4];
                    break;
                case 5:
                    [imageView addGestureRecognizer:_tapGesture5];
                    break;
                default:
                    break;
            }
            //添加到sctollview
            [_scrollView addSubview:imageView];
        }
        
        UIImageView *imageViewFooter = [[UIImageView alloc]init];
        //设置frame
        imageViewFooter.frame = CGRectMake(SCREEN_WIDTH*6, 0, self.view.bounds.size.width, SCREEN_HEIGHT*0.5f-64);
        //设置显示 图片
        imageViewFooter.image = [UIImage imageNamed:_topImgArray[0]];
        imageViewFooter.userInteractionEnabled = YES;
        [imageViewFooter addGestureRecognizer:_tapGesture6];
        //添加到sctollview
        [_scrollView addSubview:imageViewFooter];
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.5f, SCREEN_WIDTH, SCREEN_HEIGHT*0.5f)];
        _imageView.image = [UIImage imageNamed:_topImgArray[0]];
    }
    return _imageView;
}

- (UIVisualEffectView *)effectView{
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _effectView.frame = CGRectMake(0, SCREEN_HEIGHT*0.5f, SCREEN_WIDTH, SCREEN_HEIGHT*0.5f);
        _effectView.alpha = 0.8f;
    }
    return _effectView;
}

- (UIView *)myView{
    if (!_myView) {
        _myView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.5f, SCREEN_WIDTH, SCREEN_HEIGHT*0.5f)];
        _myView.backgroundColor = [UIColor whiteColor];
        _myView.alpha = 0.5f;
    }
    return _myView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        //初始化 一个分页控制器
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 00, 100, 30)];
        //设置分页控制器页数
        _pageControl.numberOfPages = 5;
        //设置选中业的索引
        _pageControl.currentPage=0;
        //设置当只有一页时 控制器是否隐藏
        _pageControl.hidesForSinglePage = YES;
        //是否手动调用代码更新UI
        _pageControl.defersCurrentPageDisplay=NO;
        //设置pageControl 分页点的颜色
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
        //设置pageControll当前页的颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1];
    }
    return _pageControl;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _layout = [[MyLayout alloc]init];
        _layout.itemCount = 9;
        _layout.InteritemCount = 4;
        _layout.cellHight = SCREEN_HEIGHT*0.15f;
        //设置行列间距
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.05f, self.view.frame.size.width, _layout.cellHight*3+_layout.minimumLineSpacing*2) collectionViewLayout:_layout];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

#pragma mark - tap 手势
- (void)tapGesure1{
    NSLog(@"点击了第一张图片");
    PassageViewController *passageViewController = [[PassageViewController alloc]initWithURL:[NSString stringWithFormat:@"https://fx.scnu.edu.cn/FXonline/pages/article/showarticle_android.html?sid=10&thumb=0&id=%@" ,_listArr[0].id] isNotice:NO];
    [self.navigationController pushViewController:passageViewController animated:YES];
}

- (void)tapGesure2{
    NSLog(@"点击了第二张图片");
    PassageViewController *passageViewController = [[PassageViewController alloc]initWithURL:[NSString stringWithFormat:@"https://fx.scnu.edu.cn/FXonline/pages/article/showarticle_android.html?sid=10&thumb=1&id=%@" ,_listArr[1].id] isNotice:NO];
    [self.navigationController pushViewController:passageViewController animated:YES];
}

- (void)tapGesure3{
    NSLog(@"点击了第三张图片");
    PassageViewController *passageViewController = [[PassageViewController alloc]initWithURL:[NSString stringWithFormat:@"https://fx.scnu.edu.cn/FXonline/pages/article/showarticle_android.html?sid=10&thumb=2&id=%@" ,_listArr[2].id] isNotice:NO];
    [self.navigationController pushViewController:passageViewController animated:YES];
}

- (void)tapGesure4{
    NSLog(@"点击了第四张图片");
    PassageViewController *passageViewController = [[PassageViewController alloc]initWithURL:[NSString stringWithFormat:@"https://fx.scnu.edu.cn/FXonline/pages/article/showarticle_android.html?sid=10&thumb=3&id=%@" ,_listArr[3].id] isNotice:NO];
    [self.navigationController pushViewController:passageViewController animated:YES];
}

- (void)tapGesure5{
    NSLog(@"点击了第五张图片");
    PassageViewController *passageViewController = [[PassageViewController alloc]initWithURL:[NSString stringWithFormat:@"https://fx.scnu.edu.cn/FXonline/pages/article/showarticle_android.html?sid=10&thumb=4&id=%@" ,_listArr[4].id] isNotice:NO];
    [self.navigationController pushViewController:passageViewController animated:YES];
}

#pragma mark - UICollectionViewDataSource
//设置分区数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//设置item数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _layout.itemCount;
}
//设置item属性
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    MyCollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.iconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _iconImgArray[indexPath.row]]];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", _iconTitleArray[indexPath.row]];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UICollectionViewDelegate
// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了%zd",indexPath.row);
    if (indexPath.row==6||indexPath.row==8) {
        [self showAlertControllerWithTitle:@"温馨提示" message:@"该功能暂未开放，敬请期待！" handler:nil];
    }else {
        ListViewController *tableViewController = [[ListViewController alloc]initWithTag:indexPath.row];
        tableViewController.title = _iconTitleArray[indexPath.row];
        [self.navigationController pushViewController:tableViewController animated:YES];
    }
    
}

#pragma mark - UIScrollViewDelegate
//设置pageControl 的显示
//当滑动快结束的时候
//缓慢结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取当前scrollview 的X轴方向的 偏移量
    CGFloat offset_X = self.scrollView.contentOffset.x;
    //设置当前的显示位置
    if (offset_X > SCREEN_WIDTH*5){
        self.pageControl.currentPage = 0;
        [UIView transitionWithView:_imageView duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _topLabel.text = _topTitleArray[self.pageControl.currentPage];
            _imageView.image = [UIImage imageNamed:_topImgArray[self.pageControl.currentPage]];
        } completion:nil];
    }
    else if (offset_X < SCREEN_WIDTH){
        self.pageControl.currentPage = 4;
        [UIView transitionWithView:_imageView duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _topLabel.text = _topTitleArray[self.pageControl.currentPage];
            _imageView.image = [UIImage imageNamed:_topImgArray[self.pageControl.currentPage]];
        } completion:nil];
    }
    else{
        self.pageControl.currentPage = offset_X/SCREEN_WIDTH-1;
        [UIView transitionWithView:_imageView duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _topLabel.text = _topTitleArray[self.pageControl.currentPage];
            _imageView.image = [UIImage imageNamed:_topImgArray[self.pageControl.currentPage]];
        } completion:nil];
    }
}

//当滑动开始的时候 ，停止计数器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //取消定时器任务
    [self.timer invalidate];
    
    //通过改变contentOffset来切换滚动视图的子界面
    float offset_X = _scrollView.contentOffset.x;
    
    //说明要从最右边的多余视图开始滚动了，最右边的多余视图实际上就是第一个视图。所以偏移量需要更改为第一个视图的偏移量。
    if (offset_X > SCREEN_WIDTH*5) {
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }
    else if (offset_X < SCREEN_WIDTH){
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*5, 0);
    }
}

//当滑动停止时启动定时器任务
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.timer fire];
    //设置自动滚动定时任务
    [self initTimerFunction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
