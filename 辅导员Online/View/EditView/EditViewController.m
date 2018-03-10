//
//  EditViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/10.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "EditViewController.h"
#import "ImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UILabel+Copy.h"
#import "PortraitImageView.h"
#import "UIViewController+XYSideCategory.h"
#import "IdentifyViewController.h"
#import "AppDelegate.h"
#import "ViewModel.h"
#import "ProgressHUD.h"
#import "UserInfModel.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface EditViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, ImageCropperDelegate, PortraitImageViewDelegate>

@property (nonatomic, strong) PortraitImageView *portraitImageView;
@property (nonatomic, strong) UIImage *portraitImage;
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, strong) UIButton *identificationBtn;

@property (nonatomic, strong) UILabel *identificationLabel;
@property (nonatomic, strong) UILabel *mailLabel;
@property (nonatomic, strong) UILabel *userMailLabel;
@property (nonatomic, strong) UILabel *schoolLabel;
@property (nonatomic, strong) UILabel *userSchoolLabel;
@property (nonatomic, strong) UILabel *departmentLabel;
@property (nonatomic, strong) UILabel *userDepartmentLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *userNumberLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) UserInfModel *userInf;

@end

@implementation EditViewController

- (void)loadView
{
    [super loadView];
    self.view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _token = ((AppDelegate *)[UIApplication sharedApplication].delegate).token;
    _userInf = [[UserInfModel alloc]init];
    _userInf = [UserInfModel unarchive];
    [self setUpViews];
    [self addObserver];
}

-(void)dealloc{
    [self removeObserver];
}

-(void)addObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_userNameTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInfo:) name:@"identificationInfo_changed" object:nil];
}

-(void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:_userNameTextField];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"identificationInfo_changed" object:nil];
}

-(instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        _portraitImage = image;
    }
    return self;
}

-(void)setUpViews{
    [self.view addSubview:self.portraitImageView];
    [self.view addSubview:self.userNameTextField];
    [self drawLine];
    [self.view addSubview:self.identificationLabel];
    [self.view addSubview:self.identificationBtn];
    
    [self.view addSubview:self.mailLabel];
    [self.view addSubview:self.userMailLabel];
    [self.view addSubview:self.schoolLabel];
    [self.view addSubview:self.userSchoolLabel];
    [self.view addSubview:self.departmentLabel];
    [self.view addSubview:self.userDepartmentLabel];
    [self.view addSubview:self.numberLabel];
    [self.view addSubview:self.userNumberLabel];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.userNameLabel];
    
    if (_userInf.Confirmed) {
        [self didIdentified];
    }
}

-(void)didIdentified{
    _userSchoolLabel.text = _userInf.SchoolName;
    _userDepartmentLabel.text = _userInf.Department;
    _userNumberLabel.text = _userInf.Pid;
    _userNameLabel.text = _userInf.FullName;
    CGFloat w1 = self.view.frame.size.width*0.35f;
    CGFloat w2 = self.view.frame.size.width*0.58f;
    CGFloat h = self.view.frame.size.height*0.05f;
    CGFloat x1 = self.view.frame.size.width*0.05f;
    CGFloat x2 = self.view.frame.size.width*0.37f;
    CGFloat y = self.view.frame.size.height*0.5f;
    _identificationLabel.text = @"已认证";
    _identificationLabel.textColor = [UIColor colorWithRed:40/255.0 green:130/255.0 blue:246/255.0 alpha:1];
    _mailLabel.frame = CGRectMake(x1, y, w1, h);
    _userMailLabel.frame = CGRectMake(x2, y, w2, h);
    _schoolLabel.hidden = NO;
    _userSchoolLabel.hidden = NO;
    _departmentLabel.hidden = NO;
    _userDepartmentLabel.hidden = NO;
    _numberLabel.hidden = NO;
    _userNumberLabel.hidden = NO;
    _nameLabel.hidden = NO;
    _userNameLabel.hidden = NO;
    _identificationBtn.hidden = YES;
}

#pragma mark - PortraitImageViewDelegate
- (void)portraitImageViewDidTap:(PortraitImageView *)portraitImageView {
    UIAlertController * sheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 取消
    [sheetController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];
    // 拍照
    [sheetController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([portraitImageView isCameraAvailable] && [portraitImageView doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([portraitImageView isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){

                                 }];
            }
    }]];
    // 从相册中选取
    [sheetController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([portraitImageView isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                
                             }];
        }
    }]];
    
    [self presentViewController:sheetController animated:YES completion:nil];
}

#pragma mark - ImageCropperDelegate
- (void)imageCropper:(ImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    [ProgressHUD showProgressHUD:@"上传中..."];
    [ViewModel uploadHeadPic:editedImage withToken:_token finish:^(BOOL success) {
        if (success) {
            [self showAlertControllerWithTitle:@"上传成功" message:nil handler:nil];
            [ProgressHUD hideAllHUDAnimated:NO];
            [cropperViewController dismissViewControllerAnimated:YES completion:^{
                [ViewModel getUserInfWithToken:_token finish:^(BOOL success) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"portrait_changed" object:nil userInfo:@{@"newImage": editedImage}];
                }];
            }];
        } else {
            if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                [self showAlertControllerWithTitle:@"上传失败" message:@"服务器内部错误" handler:nil];
                [ProgressHUD hideAllHUDAnimated:NO];
            } else {
                [self showAlertControllerWithTitle:@"上传失败" message:@"请检查网络连接情况" handler:nil];
                [ProgressHUD hideAllHUDAnimated:NO];
            }
        }
    }];
}

- (void)imageCropperDidCancel:(ImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [_portraitImageView imageByScalingToMaxSize:portraitImg];
        // 裁剪
        ImageCropperViewController *imgEditorVC = [[ImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - portraitImageView getter
- (PortraitImageView *)portraitImageView {
    if (!_portraitImageView) {
        CGFloat w = self.view.frame.size.height*0.25f; CGFloat h = w;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        CGFloat y = self.view.frame.size.height*0.05f;
        _portraitImageView = [[PortraitImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _portraitImageView.image = _portraitImage;
        _portraitImageView.delegate = self;
    }
    return _portraitImageView;
}

#pragma mark - identificationLabel
-(UILabel *)identificationLabel
{
    if(!_identificationLabel){
        CGFloat w = self.view.frame.size.width*0.3f; CGFloat h = self.view.frame.size.height*0.06f;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        CGFloat y = self.view.frame.size.height*0.42f;
        _identificationLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _identificationLabel.text = @"未认证";
        _identificationLabel.textColor = [UIColor orangeColor];
        _identificationLabel.font = [UIFont boldSystemFontOfSize:26];
        _identificationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _identificationLabel;
}

#pragma mark - identificationBtn
-(UIButton *)identificationBtn{
    if(!_identificationBtn){
        CGFloat w = self.view.frame.size.width*0.5f; CGFloat h = self.view.frame.size.height*0.06f;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        CGFloat y = self.view.frame.size.height*0.5f;
        _identificationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _identificationBtn.frame = CGRectMake(x, y, w, h);
        _identificationBtn.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"去进行身份认证>"];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:strRange];
        [str addAttribute: NSForegroundColorAttributeName value:[UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1] range:strRange];
        [_identificationBtn setAttributedTitle:str forState:UIControlStateNormal];
        [_identificationBtn addTarget:self action:@selector(identify) forControlEvents:UIControlEventTouchUpInside];
    }
    return _identificationBtn;
}

-(void)identify{
    IdentifyViewController * identifyViewController = [[IdentifyViewController alloc]init];
    identifyViewController.title = @"身份认证";
    [self XYSidePushViewController:identifyViewController animated:YES];
}

#pragma mark - infoLabels
-(UILabel *)mailLabel
{
    if(!_mailLabel){
        CGFloat w = self.view.frame.size.width*0.35f; CGFloat h = self.view.frame.size.height*0.05f;
        CGFloat x = self.view.frame.size.width*0.05f;
        CGFloat y = self.view.frame.size.height*0.6f;
        _mailLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _mailLabel.text = @"注册邮箱";
        _mailLabel.font = [UIFont systemFontOfSize:20];
        _mailLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
    }
    return _mailLabel;
}

-(UILabel *)userMailLabel
{
    if(!_userMailLabel){
        CGFloat w = self.view.frame.size.width*0.58f; CGFloat h = self.view.frame.size.height*0.05f;
        CGFloat x = self.view.frame.size.width*0.37f;
        CGFloat y = self.view.frame.size.height*0.6f;
        _userMailLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        [_userMailLabel addCopy];
        _userMailLabel.text = _userInf.Email;
        _userMailLabel.font = [UIFont systemFontOfSize:20];
        _userMailLabel.adjustsFontSizeToFitWidth = YES;
        _userMailLabel.minimumScaleFactor = 0.5f;
        _userMailLabel.textColor = [UIColor blackColor];
    }
    return _userMailLabel;
}

-(UILabel *)schoolLabel
{
    if(!_schoolLabel){
        CGFloat w = self.view.frame.size.width*0.35f; CGFloat h = self.view.frame.size.height*0.05f;
        CGFloat x = self.view.frame.size.width*0.05f;
        CGFloat y = self.view.frame.size.height*0.57f;
        _schoolLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _schoolLabel.text = @"高校";
        _schoolLabel.font = [UIFont systemFontOfSize:20];
        _schoolLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _schoolLabel.hidden = YES;
    }
    return _schoolLabel;
}

-(UILabel *)userSchoolLabel
{
    if(!_userSchoolLabel){
        CGFloat w = self.view.frame.size.width*0.58f; CGFloat h = self.view.frame.size.height*0.05f;
        CGFloat x = self.view.frame.size.width*0.37f;
        CGFloat y = self.view.frame.size.height*0.57f;
        _userSchoolLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        [_userSchoolLabel addCopy];
        _userSchoolLabel.font = [UIFont systemFontOfSize:20];
        _userSchoolLabel.adjustsFontSizeToFitWidth = YES;
        _userSchoolLabel.minimumScaleFactor = 0.5f;
        _userSchoolLabel.textColor = [UIColor blackColor];
        _userSchoolLabel.hidden = YES;
    }
    return _userSchoolLabel;
}

-(UILabel *)departmentLabel
{
    if(!_departmentLabel){
        CGFloat w = self.view.frame.size.width*0.35f; CGFloat h = self.view.frame.size.height*0.05f;
        CGFloat x = self.view.frame.size.width*0.05f;
        CGFloat y = self.view.frame.size.height*0.64f;
        _departmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _departmentLabel.text = @"院系";
        _departmentLabel.font = [UIFont systemFontOfSize:20];
        _departmentLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _departmentLabel.hidden = YES;
    }
    return _departmentLabel;
}

-(UILabel *)userDepartmentLabel
{
    if(!_userDepartmentLabel){
        CGFloat w = self.view.frame.size.width*0.58f; CGFloat h = self.view.frame.size.height*0.05f;
        CGFloat x = self.view.frame.size.width*0.37f;
        CGFloat y = self.view.frame.size.height*0.64f;
        _userDepartmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        [_userDepartmentLabel addCopy];
        _userDepartmentLabel.font = [UIFont systemFontOfSize:20];
        _userDepartmentLabel.adjustsFontSizeToFitWidth = YES;
        _userDepartmentLabel.minimumScaleFactor = 0.5f;
        _userDepartmentLabel.textColor = [UIColor blackColor];
        _userDepartmentLabel.hidden = YES;
    }
    return _userDepartmentLabel;
}

-(UILabel *)numberLabel
{
    if(!_numberLabel){
        CGFloat w = self.view.frame.size.width*0.35f; CGFloat h = self.view.frame.size.height*0.05f;
        CGFloat x = self.view.frame.size.width*0.05f;
        CGFloat y = self.view.frame.size.height*0.71f;
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _numberLabel.text = @"学(工)号";
        _numberLabel.font = [UIFont systemFontOfSize:20];
        _numberLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _numberLabel.hidden = YES;
    }
    return _numberLabel;
}

-(UILabel *)userNumberLabel
{
    if(!_userNumberLabel){
        CGFloat w = self.view.frame.size.width*0.58f; CGFloat h = self.view.frame.size.height*0.05f;
        CGFloat x = self.view.frame.size.width*0.37f;
        CGFloat y = self.view.frame.size.height*0.71f;
        _userNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        [_userNumberLabel addCopy];
        _userNumberLabel.font = [UIFont systemFontOfSize:20];
        _userNumberLabel.adjustsFontSizeToFitWidth = YES;
        _userNumberLabel.minimumScaleFactor = 0.5f;
        _userNumberLabel.textColor = [UIColor blackColor];
        _userNumberLabel.hidden = YES;
    }
    return _userNumberLabel;
}

-(UILabel *)nameLabel
{
    if(!_nameLabel){
        CGFloat w = self.view.frame.size.width*0.35f; CGFloat h = self.view.frame.size.height*0.05f;
        CGFloat x = self.view.frame.size.width*0.05f;
        CGFloat y = self.view.frame.size.height*0.78f;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _nameLabel.text = @"姓名";
        _nameLabel.font = [UIFont systemFontOfSize:20];
        _nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _nameLabel.hidden = YES;
    }
    return _nameLabel;
}

-(UILabel *)userNameLabel
{
    if(!_userNameLabel){
        CGFloat w = self.view.frame.size.width*0.58f; CGFloat h = self.view.frame.size.height*0.05f;
        CGFloat x = self.view.frame.size.width*0.37f;
        CGFloat y = self.view.frame.size.height*0.78f;
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        [_userNameLabel addCopy];
        _userNameLabel.font = [UIFont systemFontOfSize:20];
        _userNameLabel.adjustsFontSizeToFitWidth = YES;
        _userNameLabel.minimumScaleFactor = 0.5f;
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.hidden = YES;
    }
    return _userNameLabel;
}

#pragma mark - 分割线
-(void)drawLine{
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    //   创建一个路径对象
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    //  起点
    [linePath moveToPoint:(CGPoint){0, 0}];
    // 其他点
    [linePath addLineToPoint:(CGPoint){w*0.9f, 0}];
    
    //  设置路径画布
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.bounds = (CGRect){0,0,w*0.9f,5};
    lineLayer.position = CGPointMake(w*0.5f, h*0.41f);
    lineLayer.lineWidth = 1.5;
    lineLayer.strokeColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:0.6].CGColor; //   边线颜色
    
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor  = nil;   //  默认是black
    
    //  添加到图层上
    [self.view.layer addSublayer:lineLayer];
}

#pragma mark - userNameTextField
-(UITextField *)userNameTextField{
    if (!_userNameTextField) {
        CGFloat w = self.view.frame.size.width*0.6f; CGFloat h = self.view.frame.size.height*0.06f;
        CGFloat x = (self.view.frame.size.width - w + h*0.6) / 2;
        CGFloat y = self.view.frame.size.height*0.33f;
        _userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _userNameTextField.delegate = self;
        _userNameTextField.layer.cornerRadius = 7;
        _userNameTextField.clipsToBounds = YES;
        _userNameTextField.textAlignment = NSTextAlignmentCenter;
        _userNameTextField.font = [UIFont boldSystemFontOfSize:24];

        _userNameTextField.text = _userInf.NickName;
        _userName = _userNameTextField.text;
        //设置字体大小自适应
        _userNameTextField.adjustsFontSizeToFitWidth = YES;
        _userNameTextField.minimumFontSize = 3;
        //设置输入框上的提示文字
        _userNameTextField.placeholder = @"请输入用户名";
        //设置清除按钮的显示模式
        _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        //设置右视图
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, h*0.6, h*0.6)];
        imageView.image = [UIImage imageNamed:@"edit_nick_name"];
        _userNameTextField.rightView = imageView;
        //设置右视图的显示模式
        _userNameTextField.rightViewMode = UITextFieldViewModeUnlessEditing;

    }
    return _userNameTextField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [_userNameTextField resignFirstResponder];
//}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
    textField.textColor = [UIColor whiteColor];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor whiteColor];
    textField.textColor = [UIColor blackColor];
    _userNameTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
    if (textField.text==nil||[textField.text isEqualToString:@""]) {
        textField.text = _userName;
    } else {
        _userName = textField.text;
    }
    
    [ProgressHUD showProgressHUD:@"修改中..."];
    [ViewModel changNickNameWithNewNickName:_userNameTextField.text token:_token finish:^(BOOL success){
        if (success) {
            [self showAlertControllerWithTitle:@"修改成功" message:nil handler:nil];
            [ProgressHUD hideAllHUDAnimated:NO];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"userName_changed" object:nil];
        } else {
            if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                [self showAlertControllerWithTitle:@"修改失败" message:@"服务器内部错误" handler:nil];
                [ProgressHUD hideAllHUDAnimated:NO];
            } else {
                [self showAlertControllerWithTitle:@"修改失败" message:@"请检查网络连接情况" handler:nil];
                [ProgressHUD hideAllHUDAnimated:NO];
            }
        }
    }];
    return YES;
}

#pragma mark - NSNotificationMethod

//输入字数限制
#define charMaxLength 20
#define wordMaxLength 13
-(void)textFiledEditChanged:(NSNotification *)obj{
    if ((UITextField *)obj.object==_userNameTextField) {
        UITextField *textField = (UITextField *)obj.object;
        
        NSString *toBeString = textField.text;
        if (toBeString.length==0) {
            _userNameTextField.rightViewMode = UITextFieldViewModeNever;
        }
//        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
//        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
//            UITextRange *selectedRange = [textField markedTextRange];
//            //获取高亮部分
//            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//            if (!position) {
//                if (toBeString.length > wordMaxLength) {
//                    textField.text = [toBeString substringToIndex:wordMaxLength];
//                }else if (toBeString.length==0){
//                    _userNameTextField.rightViewMode = UITextFieldViewModeNever;
//                }
//            }
//            // 有高亮选择的字符串，则暂不对文字进行统计和限制
//            else{
//
//            }
//        }
//        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//        else{
//            if (toBeString.length > charMaxLength) {
//                textField.text = [toBeString substringToIndex:charMaxLength];
//            }else if (toBeString.length==0){
//                _userNameTextField.rightViewMode = UITextFieldViewModeNever;
//            }
//        }
    }
}

- (void)updateInfo:(NSNotification *)notification{
    [self didIdentified];
    _userSchoolLabel.text = [notification.userInfo[@"school"] substringFromIndex:6];
    _userDepartmentLabel.text = notification.userInfo[@"department"];
    _userNumberLabel.text = notification.userInfo[@"number"];
    _userNameLabel.text = notification.userInfo[@"name"];
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
