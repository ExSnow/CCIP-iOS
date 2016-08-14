//
//  InvalidNetworkMessageViewController.m
//  CCIP
//
//  Created by FrankWu on 2016/8/15.
//  Copyright © 2016年 CPRTeam. All rights reserved.
//

#import "InvalidNetworkMessageViewController.h"

@interface InvalidNetworkMessageViewController ()

@property (readwrite, nonatomic) BOOL isRelayout;

@end

@implementation InvalidNetworkMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setAutoresizingMask:UIViewAutoresizingNone];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    if (self.isRelayout != true) {
        self.view.frame = CGRectMake(0.0,
                                     0.0,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height - 64 - 49);
        
        self.view.superview.frame = CGRectMake(0.0,
                                               64.0,
                                               self.view.frame.size.width,
                                               self.view.frame.size.height);
        self.isRelayout = true;
    }
}

- (IBAction)clossView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self dismissViewControllerAnimated:YES completion:nil];
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