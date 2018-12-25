//
//  ZZMainViewController.m
//  ZZLarkifyViewDemo
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZMainViewController.h"
#import "ZZTableViewController.h"

@interface ZZMainViewController ()

@end

@implementation ZZMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)demoClick:(id)sender {
    [self.navigationController pushViewController:[ZZTableViewController new] animated:YES];
}

@end
