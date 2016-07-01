//
//  ViewController.m
//  04-QQLogin
//
//  Created by vera on 16/6/22.
//  Copyright © 2016年 vera. All rights reserved.
//

#import "ViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentMessageObject.h>

@interface ViewController ()<TencentSessionDelegate>
{
    /**
     *  登录的对象
     */
    TencentOAuth *_tencentOAuth;
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicenameLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, 200, 300, 50);
    [btn setTitle:@"QQ登录" forState:0];
    [btn addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:btn];
}

/**
 *  qq登录
 */
- (void)qqLogin
{
    //appid我们申请appid
     _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105415067"   andDelegate:self];
    //权限
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    //开始授权
    [_tencentOAuth authorize:permissions inSafari:NO];
    
    //sharesdk umeng
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    NSLog(@"登录成功了");
    
    //获取当前登录的用户信息
    [_tencentOAuth getUserInfo];
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"登录失败");
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    NSLog(@"登录时网络有问题");
}

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response
{
    NSLog(@"%@",response.jsonResponse);
    

    //头像
    NSString *iconUrl = response.jsonResponse[@"figureurl_qq_2"];
    //昵称
    NSString *nickname = response.jsonResponse[@"nickname"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrl]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.iconImageView.image = [UIImage imageWithData:data];
            self.nicenameLabel.text = nickname;
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
