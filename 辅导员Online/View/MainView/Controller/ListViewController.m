//
//  ListViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/12/22.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "ListViewController.h"
#import "UIScrollView+MJRefreshEX.h"
#import "WordTableViewCell.h"
#import "PicTableViewCell.h"
#import "UIImage+Scaled.h"
#import "PassageViewController.h"
#import "ViewModel.h"
#import "UIViewController+XYSideCategory.h"
#import "AppDelegate.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ListViewController ()<UITableViewDelegate, UITableViewDataSource,MJRefreshEXDelegate>

@property (nonatomic, strong) NSMutableArray<PassageListModel *> *listArr;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) UIImageView *backgroundImgView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ListViewController

-(instancetype)initWithTag:(NSInteger)tag{
    self = [super init];
    if (self) {
        _tag = tag;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _listArr = [[NSMutableArray<PassageListModel *> alloc]init];
    if (_tag==1||_tag==4||_tag==5||_tag==7) {
        [self.view addSubview:self.backgroundImgView];
        self.tableView.pagingEnabled = YES;
        self.tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    [self.view addSubview:self.tableView];
}

- (UIImageView *)backgroundImgView{
    if (!_backgroundImgView) {
        _backgroundImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backgroundImgView.contentMode = UIViewContentModeCenter;
        _backgroundImgView.clipsToBounds = YES;
        UIImage *image = [UIImage imageNamed:@"1-0"];
        CGFloat w = image.size.width*SCREEN_HEIGHT/image.size.height;
        image = [UIImage imageCompressWithSimple:image scaledToSize:CGSizeMake(w, SCREEN_HEIGHT)];
        _backgroundImgView.image = image;
        
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        effectView.frame = CGRectMake(0, 0, self.backgroundImgView.frame.size.width, self.backgroundImgView.frame.size.height+20);
        effectView.alpha = 0.5f;
        [self.backgroundImgView addSubview:effectView];
    }
    return _backgroundImgView;
}

#pragma mark - tableView

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollsToTop = YES;
        _tableView.scrollEnabled = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (_tag==0||_tag==2||_tag==3||_tag==9) {
            [self.tableView addHeaderWithHeaderClass:nil beginRefresh:YES delegate:self animation:YES textColor:[UIColor colorWithWhite:0.4 alpha:1] activityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
            [self.tableView addFooterWithFooterClass:nil automaticallyRefresh:YES delegate:self textColor:[UIColor colorWithWhite:0.4 alpha:1]];
        } else {
            [self.tableView addHeaderWithHeaderClass:nil beginRefresh:YES delegate:self animation:YES textColor:[UIColor whiteColor] activityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
            [self.tableView addFooterWithFooterClass:nil automaticallyRefresh:YES delegate:self textColor:[UIColor whiteColor]];
        }
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MJRefreshEXDelegate
- (void)onRefreshing:(id)control {
    [self requestNetWorkingWithPageNum:1 isHeader:YES];
}

- (void)onLoadingMoreData:(id)control pageNum:(NSNumber *)pageNum {
    [self requestNetWorkingWithPageNum:pageNum.integerValue isHeader:NO];
}

- (void)requestNetWorkingWithPageNum:(NSInteger)pageNum isHeader:(BOOL)isHeader {
    
    [ViewModel getPassageListWithSid:[NSString stringWithFormat:@"1%zd",_tag+1] pageNo:[NSString stringWithFormat:@"%zd",pageNum] pageSize:@"30" finish:^(BOOL success, NSArray<PassageListModel *> *listArr) {
        if (success) {
            if (isHeader) {
                
                [_tableView endHeaderRefreshWithChangePageIndex:YES];
                NSLog(@"%zd",pageNum);
                [_listArr removeAllObjects];
                [_listArr addObjectsFromArray:listArr];
                
            }else {
                [_tableView endFooterRefreshWithChangePageIndex:YES];
                NSLog(@"%zd",pageNum);
                
                if (listArr.count) {
                    [_listArr addObjectsFromArray:listArr];
                }else {
                    [_tableView noMoreData];
                }
            }
            [_tableView reloadData];
        } else {
            if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                [self showAlertControllerWithTitle:@"获取数据失败" message:@"服务器内部错误" handler:nil];
                if (isHeader) {
                    [_tableView endHeaderRefreshWithChangePageIndex:NO];
                }else {
                    [_tableView endFooterRefreshWithChangePageIndex:NO];
                }
            } else {
                [self showAlertControllerWithTitle:@"获取数据失败" message:@"请检查网络连接情况" handler:nil];
                if (isHeader) {
                    [_tableView endHeaderRefreshWithChangePageIndex:NO];
                }else {
                    [_tableView endFooterRefreshWithChangePageIndex:NO];
                }
            }
        }
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tag==0||_tag==2||_tag==3||_tag==9) {
        return 220;
    } else {
        return SCREEN_HEIGHT;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_tag==0||_tag==2||_tag==3) {
        WordTableViewCell *cell = [[WordTableViewCell alloc]init];
        cell.titleLabel.text = _listArr[indexPath.row].title;
        NSString *string = @"        ";
        cell.contentTV.text = [string stringByAppendingString:_listArr[indexPath.row].abstract];
        cell.authorLabel.text = _listArr[indexPath.row].SignatureAuthor;
        cell.timeLabel.text = [_listArr[indexPath.row].posttime componentsSeparatedByString:@"T"][0];
        return cell;
    } else {
        PicTableViewCell *cell = [[PicTableViewCell alloc]init];
        cell.titleLabel.text = _listArr[indexPath.row].title;
        NSString *string = @"        ";
        cell.contentTV.text = [string stringByAppendingString:_listArr[indexPath.row].abstract];
        cell.authorLabel.text = _listArr[indexPath.row].SignatureAuthor;
        cell.timeLabel.text = [_listArr[indexPath.row].posttime componentsSeparatedByString:@"T"][0];
        cell.markLabel.text = [NSString stringWithFormat:@"点赞数：%@  阅读量：%@",_listArr[indexPath.row].favnum, _listArr[indexPath.row].visitnum];

        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd-%zd",_tag,indexPath.row%3]];
        CGFloat imageWidth = image.size.width*(SCREEN_HEIGHT-64-20)*0.8f/image.size.height;
        image = [UIImage imageCompressWithSimple:image scaledToSize:CGSizeMake(imageWidth, (SCREEN_HEIGHT-64-20)*0.75f)];
        cell.coverImgView.image = image;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%zd篇",indexPath.row);
    if (_tag==0) {
        PassageViewController *passageViewController = [[PassageViewController alloc]initWithURL:[NSString stringWithFormat:@"https://fx.scnu.edu.cn/h5android/pages/noticeArticle/noticeArticle.html?id=%@",_listArr[indexPath.row].id] isNotice:YES];
        [self.navigationController pushViewController:passageViewController animated:YES];
    }else{
        if (_tag==2||_tag==3) {
            PassageViewController *passageViewController = [[PassageViewController alloc]initWithURL:[NSString stringWithFormat:@"https://fx.scnu.edu.cn/FXonline/pages/article/showarticle_android.html?sid=10&thumb=%zd&id=%@",indexPath.row%5,_listArr[indexPath.row].id] isNotice:NO];
            [self.navigationController pushViewController:passageViewController animated:YES];
        } else {
            PassageViewController *passageViewController = [[PassageViewController alloc]initWithURL:[NSString stringWithFormat:@"https://fx.scnu.edu.cn/FXonline/pages/article/showarticle_android.html?sid=%@&thumb=%zd&id=%@",_listArr[indexPath.row].classify,indexPath.row%3,_listArr[indexPath.row].id] isNotice:NO];
            [self.navigationController pushViewController:passageViewController animated:YES];
        }
    }
    
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd-%d",_tag,(int)(scrollView.contentOffset.y/SCREEN_HEIGHT)%3]];
    CGFloat w = image.size.width*SCREEN_HEIGHT/image.size.height;
    image = [UIImage imageCompressWithSimple:image scaledToSize:CGSizeMake(w, SCREEN_HEIGHT)];
    [UIView transitionWithView:_backgroundImgView duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        _backgroundImgView.image = image;
    } completion:nil];
    [self.tableView beginHeaderRefresh];
}

//导航栏渐变透明
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_tag==1||_tag==4||_tag==5||_tag==7) {
        CGFloat offset = scrollView.contentOffset.y;
        CGFloat alpha = (64 - offset) / 64;
        self.navigationController.navigationBar.subviews.firstObject.alpha = alpha;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd-%d",_tag,(int)(scrollView.contentOffset.y/SCREEN_HEIGHT)%3]];
    CGFloat w = image.size.width*SCREEN_HEIGHT/image.size.height;
    image = [UIImage imageCompressWithSimple:image scaledToSize:CGSizeMake(w, SCREEN_HEIGHT)];
    [UIView transitionWithView:_backgroundImgView duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        _backgroundImgView.image = image;
    } completion:nil];
}


@end
