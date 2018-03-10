//
//  ShowImageViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/12.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "ShowImageViewController.h"

//回弹时间
#define BOUNDCE_DURATION 0.3f

@interface ShowImageViewController ()

@property(nonatomic, assign) int flag;
@property(nonatomic, assign) CGRect convertFrame;
@property(nonatomic, assign) CGRect oldFrame;
@property(nonatomic, assign) CGRect latestFrame;
@property(nonatomic, assign) CGRect largeFrame;
@property(nonatomic, assign) CGRect screenFrame;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIAlertController * alertController;

@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _flag = 0;
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = 0;
    _imageView = [[UIImageView alloc]initWithFrame:_convertFrame];
    _imageView.image = _image;
    [self.view addSubview:_imageView];
    
    [self addGestureRecognizer];
}

-(void)viewDidAppear:(BOOL)animated{
    //动画放大所展示的ImageView
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = (self.view.frame.size.height - _image.size.height * self.view.frame.size.width / _image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = self.view.frame.size.width;
        //高度 根据图片宽高比设置
        height = _image.size.height * self.view.frame.size.width / _image.size.width;
        _imageView.frame = CGRectMake(0, y, width, height);
        //将视图显示出来
        self.view.alpha = 1;
        self.view.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        _oldFrame = _imageView.frame;
        _latestFrame = _oldFrame;
        _largeFrame = CGRectMake(0, 0, 3 * _oldFrame.size.width, 3 * _oldFrame.size.height);
        _screenFrame = self.view.frame;
    }];
}

-(instancetype)initWithImageView:(UIImageView *)imageView{
    self = [super init];
    if(self){
        _image = imageView.image;
        _convertFrame = [imageView convertRect:imageView.bounds toView:self.view];
    }
    return self;
}

#pragma mark - 手势

-(void)addGestureRecognizer{
    //添加单击手势
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    //添加双击手势
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargeImageView:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    doubleTapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:doubleTapGestureRecognizer];
    
    //只有当doubleTapGestureRecognizer识别失败的时候(即识别出这不是双击操作)，singleTapGestureRecognizer才能开始识别
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    
    //添加长按手势
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImage:)];
    //判定为长按手势 需要的时间
    longPressGestureRecognizer.minimumPressDuration = 1;
    //判定时间,允许用户移动的距离
    longPressGestureRecognizer.allowableMovement = 100;
    [self.view addGestureRecognizer:longPressGestureRecognizer];
    
    // 添加pinch捏合手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    // 添加pan平移手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

//单击手势
-(void)hideImageView:(UITapGestureRecognizer *)singleTapGestureRecognizer{
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        _imageView.frame = _convertFrame;
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

//双击手势
-(void)enlargeImageView:(UITapGestureRecognizer *)doubleTapGestureRecognizer{
    if (_flag==0) {
        [UIView animateWithDuration:0.4 animations:^{
            _imageView.frame = CGRectMake((_screenFrame.size.width-_largeFrame.size.width)/2, (_screenFrame.size.height-_largeFrame.size.height)/2., _largeFrame.size.width, _largeFrame.size.height);
        }completion:^(BOOL finished) {
            _latestFrame = _imageView.frame;
            _flag = 1;
        }];
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            _imageView.frame = _oldFrame;
        }completion:^(BOOL finished) {
            _latestFrame = _imageView.frame;
            _flag = 0;
        }];
    }
}

//长按手势
-(void)saveImage:(UILongPressGestureRecognizer *)longPressGestureRecognizer{
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIAlertController * sheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [sheetController addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(_image, self, @selector(image:didFinshSavingWithError:contextInfo:), nil);
        }]];
        [sheetController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }]];

        [self presentViewController:sheetController animated:YES completion:nil];
    }
}

// pinch捏合手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        _imageView.transform = CGAffineTransformScale(_imageView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        CGRect newFrame = _imageView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            _imageView.frame = newFrame;
            _latestFrame = newFrame;
        }];
    }
}

// pan平移手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // 计算accelerator
        CGFloat absCenterX = _screenFrame.origin.x + _screenFrame.size.width / 2;
        CGFloat absCenterY = _screenFrame.origin.y + _screenFrame.size.height / 2;
        CGFloat scaleRatio = _imageView.frame.size.width / _screenFrame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - _imageView.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - _imageView.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:_imageView.superview];
        [_imageView setCenter:(CGPoint){_imageView.center.x + translation.x * acceleratorX, _imageView.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:_imageView.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // 回弹到original frame
        CGRect newFrame = _imageView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            _imageView.frame = newFrame;
            _latestFrame = newFrame;
        }];
    }
}

#pragma mark - 回弹效果

- (CGRect)handleScaleOverflow:(CGRect)newFrame {
    // 回弹到original frame
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < _oldFrame.size.width) {
        newFrame = _oldFrame;
    }
    if (newFrame.size.width > _largeFrame.size.width) {
        newFrame = _largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame {
    // 水平位置
    if (newFrame.origin.x > _screenFrame.origin.x) newFrame.origin.x = _screenFrame.origin.x;
    if (CGRectGetMaxX(newFrame) < _screenFrame.size.width) newFrame.origin.x = _screenFrame.size.width - newFrame.size.width;
    // 垂直位置
    if (newFrame.origin.y > _screenFrame.origin.y) newFrame.origin.y = _screenFrame.origin.y;
    if (CGRectGetMaxY(newFrame) < _screenFrame.origin.y + _screenFrame.size.height) {
        newFrame.origin.y = _screenFrame.origin.y + _screenFrame.size.height - newFrame.size.height;
    }
    // 适配矩形框
    if (_oldFrame.size.width >= _oldFrame.size.height && newFrame.size.height <= _screenFrame.size.height) {
        newFrame.origin.y = _screenFrame.origin.y + (_screenFrame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
}

#pragma mark - 图片保存成功弹框
// 保存图片错误提示方法
- (void)image:(UIImage *)image didFinshSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *mes = nil;
    if (error != nil) {
        mes = @"保存图片失败";
    } else {
        mes = @"保存图片成功";
    }
    _alertController = [UIAlertController alertControllerWithTitle:@"提示" message:mes preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:_alertController animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
}

- (void)performDismiss:(NSTimer *)timer
{
    [_alertController dismissViewControllerAnimated:YES completion:nil];
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
