//
//  ViewController.m
//  AFNetworking封装
//
//  Created by zhangqian on 16/11/25.
//  Copyright © 2016年 Development. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "Network.h"
@interface ViewController ()
@property (nonatomic,strong) UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor cyanColor];
    
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(50, 200, 220, 50)];
    
    self.label.lineBreakMode = 0;
    self.label.numberOfLines = 2;
    self.label.text = @"请求直接调用Network封装请求方法,传图片调用RTImageClient类传入相应的参数即可";
    
    [self.view addSubview:self.label];
    
    [Network loginWithLoginName:@"13949080784"passWord:@"123456" success:^(id obj) {
       
        
    } fail:^(id obj) {
        // [App_Hud showErrorMessage:obj];
    } complete:^(id obj) {
        //NSError *error = obj;
        //[self showInfoMessage:[self formatterHttpErrorMessage:error.code]];
    }];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
