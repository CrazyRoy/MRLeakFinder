//
//  ViewController.m
//  MRLeakFinderDemo
//
//  Created by Roy on 2019/2/23.
//  Copyright © 2019年 Roy. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIViewController *vc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vc = [[SecondViewController alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushClick:(id)sender {
    [self.navigationController pushViewController:self.vc animated:YES];
}

- (IBAction)presentClick:(id)sender {
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
