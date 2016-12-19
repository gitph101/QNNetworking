//
//  ViewController.m
//  QNNetworking
//
//  Created by 研究院01 on 16/12/14.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import "ViewController.h"
#import "TestBaseManager.h"
#import "QNBlockManager.h"
@interface ViewController () <QNManagerParamSource, QNManagerCallBackDelegate>

@property (nonatomic, strong) TestBaseManager *testAPIManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view, typically from a nib.
}

-(void)click
{
//    [self.testAPIManager loadData];
    QNBlockManager *manage =  [[QNBlockManager alloc]init];
    [manage GETWithParams:nil urlString:@"https://www.baidu.com" success:^(QNURLResponse *response) {
        
    } fail:^(QNURLResponse *response) {
        
    }];
    [manage loadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (TestBaseManager *)testAPIManager
//{
//    if (_testAPIManager == nil) {
//        _testAPIManager = [[TestBaseManager alloc] init];
//        _testAPIManager.delegate = self;
//        _testAPIManager.paramSource = self;
//    }
//    return _testAPIManager;
//}


#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(QNBaseManager *)manager
{
    NSLog(@"YES");
}

- (void)managerCallAPIDidFailed:(QNBaseManager *)manager
{
    NSLog(@"NO");

}
#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(QNBaseManager *)manager
{
    NSDictionary *params = @{};
    return params;
}

@end
