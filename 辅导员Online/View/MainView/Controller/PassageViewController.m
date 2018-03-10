//
//  PassageViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/12/24.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "PassageViewController.h"
#import "UIScrollView+MJRefreshEX.h"
#import "JMDropMenu.h"

@interface PassageViewController ()<MJRefreshEXDelegate,UIWebViewDelegate,JMDropMenuDelegate>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isNotice;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSArray *titleArr1;
@property (nonatomic, strong) NSArray *titleArr2;
@property (nonatomic, strong) NSArray *imageArr1;
@property (nonatomic, strong) NSArray *imageArr2;
@property (nonatomic, strong) NSArray *imageArr3;
@property (nonatomic, strong) NSArray *imageArr4;
@property (nonatomic, strong) NSArray *imageArr5;
@property (nonatomic, strong) NSArray *imageArr6;
@property (nonatomic, assign) BOOL collected;
@property (nonatomic, assign) BOOL praised;

@end

@implementation PassageViewController


-(instancetype)initWithURL:(NSString *)url isNotice:(BOOL)isNotice{
    self = [super init];
    if (self) {
        _url = url;
        _isNotice = isNotice;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navRightClick)];
    self.titleArr2 = @[@"收藏"];
    self.imageArr5 = @[@"收藏"];
    self.imageArr6 = @[@"收藏了"];
    
    self.titleArr1 = @[@"点赞",@"收藏"];
    self.imageArr1 = @[@"点赞",@"收藏"];
    self.imageArr2 = @[@"点赞了",@"收藏"];
    self.imageArr3 = @[@"点赞",@"收藏了"];
    self.imageArr4 = @[@"点赞了",@"收藏了"];
    _collected = NO;
    _praised = NO;
    [self setupSubView];
}

- (void)setupSubView{
    [self.view addSubview:self.webView];
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        [self.webView.scrollView addHeaderWithHeaderClass:nil beginRefresh:YES delegate:self animation:NO textColor:[UIColor colorWithWhite:0.4 alpha:1] activityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
    return _webView;
}

- (void)navRightClick {
    if (_isNotice) {
        if (_collected) {
            JMDropMenu *dropMenu = [[JMDropMenu alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 70, 85, 47)  ArrowOffset:65.f TitleArr:self.titleArr2 ImageArr:self.imageArr6 Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
            dropMenu.titleColor = [UIColor whiteColor];
            dropMenu.lineColor = [UIColor whiteColor];
        } else {
            JMDropMenu *dropMenu = [[JMDropMenu alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 70, 85, 47)  ArrowOffset:65.f TitleArr:self.titleArr2 ImageArr:self.imageArr5 Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
            dropMenu.titleColor = [UIColor whiteColor];
            dropMenu.lineColor = [UIColor whiteColor];
        }
    } else {
        if (_praised) {
            if (_collected) {
                JMDropMenu *dropMenu = [[JMDropMenu alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 70, 85, 87)  ArrowOffset:65.f TitleArr:self.titleArr1 ImageArr:self.imageArr4 Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
                dropMenu.titleColor = [UIColor whiteColor];
                dropMenu.lineColor = [UIColor whiteColor];
            } else {
                JMDropMenu *dropMenu = [[JMDropMenu alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 70, 85, 87)  ArrowOffset:65.f TitleArr:self.titleArr1 ImageArr:self.imageArr2 Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
                dropMenu.titleColor = [UIColor whiteColor];
                dropMenu.lineColor = [UIColor whiteColor];
            }
        } else {
            if (_collected) {
                JMDropMenu *dropMenu = [[JMDropMenu alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 70, 85, 87)  ArrowOffset:65.f TitleArr:self.titleArr1 ImageArr:self.imageArr3 Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
                dropMenu.titleColor = [UIColor whiteColor];
                dropMenu.lineColor = [UIColor whiteColor];
            } else {
                JMDropMenu *dropMenu = [[JMDropMenu alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 70, 85, 87)  ArrowOffset:65.f TitleArr:self.titleArr1 ImageArr:self.imageArr1 Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
                dropMenu.titleColor = [UIColor whiteColor];
                dropMenu.lineColor = [UIColor whiteColor];
            }
        }
    }
}

- (void)didSelectRowAtIndex:(NSInteger)index Title:(NSString *)title Image:(NSString *)image {
    if (_isNotice) {
        _collected = !_collected;
    }else{
        if (index==0) {
            _praised = !_praised;
        } else {
            _collected = !_collected;
        }
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.webView.scrollView.mj_header beginRefreshing];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webView.scrollView.mj_header endRefreshing];
}

#pragma mark - MJRefreshEXDelegate
- (void)onRefreshing:(id)control {
    [_webView reload];
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
