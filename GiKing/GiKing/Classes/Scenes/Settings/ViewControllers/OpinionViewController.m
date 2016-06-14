//
//  opinionViewController.m
//  GiKing
//
//  Created by Han-byeol on 16/6/14.
//  Copyright © 2016年 Wj. All rights reserved.
//

#import "opinionViewController.h"

#import <MBProgressHUD.h>
#import <SKPSMTPMessage.h> //实现邮件发送
@interface OpinionViewController ()<UITextViewDelegate,SKPSMTPMessageDelegate,MBProgressHUDDelegate>

//文本视图
@property (nonatomic, strong)UITextView *textView;
//字数label
@property (nonatomic ,strong)UILabel *wordCountLabel;
// 提示框视图
@property (nonatomic ,strong)MBProgressHUD *HUD;
@end

@implementation OpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title =@"意见建议";
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(itemAction:)];
    //    初始化控件
    [self initViews];
    self.HUD.labelText =@"发送中..";
    self.HUD.delegate =self;
    
}




//控件初始化
-(void)initViews
{
    _textView =[[UITextView alloc]initWithFrame:CGRectMake(5, 10, CGRectGetWidth(self.view.frame)-10, 200)];
    //    视图颜色
    _textView.backgroundColor =[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    //    字体颜色
    _textView.textColor =[UIColor blackColor];
    // 边界偏移
    _textView.layer.borderWidth = 0.2f;
//    边界颜色
     _textView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    _textView.clipsToBounds = YES;
    _textView.layer.cornerRadius = 5;
    _textView.font = [UIFont boldSystemFontOfSize:20];
    _textView.returnKeyType = UIReturnKeySend;
    _textView.delegate = self;

    [self.view addSubview:_textView];
    _wordCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_textView.frame) - 60, CGRectGetHeight(_textView.frame) - 30, 60, 30)];
    
    _wordCountLabel.textColor = [UIColor grayColor];
    
    _wordCountLabel.text = @"200";
    
    _wordCountLabel.textAlignment = NSTextAlignmentCenter;
    
    [_textView addSubview:_wordCountLabel];
}

// 初始化提示框
- (MBProgressHUD *)HUD{
    if (_HUD == nil) {
        _HUD =[[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_HUD];
    }
    return _HUD;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationItem.rightBarButtonItem.enabled =NO;
//    设置为第一响应者
    [_textView becomeFirstResponder];
    
    [self.view bringSubviewToFront:self.HUD];
}
- (void)textViewDidChange:(UITextView *)textView
{
    _wordCountLabel.text =[NSString stringWithFormat:@"%ld",200 -textView.text.length];
//    判断输入最小数字等于5
    if (textView.text.length >= 5) {
        self.navigationItem.rightBarButtonItem.enabled =YES;
    }else
    {
        self.navigationItem.rightBarButtonItem.enabled =NO;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >=200) {
        return NO;
    }else{
        return YES;
    }
}


// 完成点击事件
-(void)itemAction:(UIBarButtonItem *)item
{
    if (self.textView.text.length >0) {
        //        释放第一响应者
        [self.textView resignFirstResponder];
        //        弹出提示框
        [self.HUD show:YES];
        
        //        设置发送邮箱
        SKPSMTPMessage *mail =[SKPSMTPMessage new];
        [mail setSubject:[NSString stringWithCString:"UnionFeedback" encoding:NSUTF8StringEncoding]];
        [mail setToEmail:@"applelixiang@yeah.net"]; // 目标邮箱
        
        [mail setFromEmail:@"applelixiang@126.com"]; // 发送者邮箱
        
        [mail setRelayHost:@"smtp.126.com"]; // 发送邮件代理服务器
        
        [mail setRequiresAuth:YES];
        
        [mail setLogin:@"applelixiang@126.com"]; // 发送者邮箱账号
        
        [mail setPass:@"hurhqzkddwurgoab"]; // 发送者邮箱密码(网易授权码)
        
        [mail setWantsSecure:YES];  // 需要加密
        
        [mail setDelegate:self];
        
        //        设置邮件内容
        NSString *content =[NSString stringWithCString:[self.textView.text UTF8String] encoding:NSUTF8StringEncoding];
        
        NSDictionary *plainPart = @{kSKPSMTPPartContentTypeKey : @"text/plain", kSKPSMTPPartMessageKey : content, kSKPSMTPPartContentTransferEncodingKey : @"8bit"};
        //发送邮件
        
        [mail setParts:@[plainPart]]; // 邮件首部字段、邮件内容格式和传输编码
        
        [mail send];
    }
}

-(void)messageSent:(SKPSMTPMessage *)message
{
//    发送成功
    self.HUD.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.HUD.mode = MBProgressHUDModeCustomView;
    
    self.HUD.labelText = @"发送成功了,非常感谢您的宝贵意见";
    [self.HUD hide:YES afterDelay:2.0f];
    //清空内容
    
    self.textView.text = @"";
    
    _wordCountLabel.text = @"200";
    
    __block typeof(self)Self = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //返回
        
        [Self.navigationController popViewControllerAnimated:YES];
        
    });

}
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    
    //发送失败
    
    self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-guanbicuowu"]];
    
    self.HUD.mode = MBProgressHUDModeCustomView;
    
    self.HUD.labelText = @"发送失败,请重新发送";
    
    [self.HUD hide:YES afterDelay:2.0f];
    
    //设置第一响应者
    
    [self.textView becomeFirstResponder];
    
}


#pragma mark ---MBProgressHUDDelegate

-(void)hudWasHidden:(MBProgressHUD *)hud{
    
    hud.customView = nil;
    
    hud.mode = MBProgressHUDModeIndeterminate;
    
    hud.labelText = @"发送中..";
    
    
    
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

