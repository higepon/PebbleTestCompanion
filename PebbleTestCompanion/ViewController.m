//
//  ViewController.m
//  PebbleTestCompanion
//
//  Created by Taro Minowa on 1/7/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

@import PebbleKit;
#import "ViewController.h"
#import "theta1.h"
#import "theta2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    double x[NUM_THETA1_COL];
    double a[NUM_THETA1_ROW];
    // todo 0 origin
    for (int i = 1; i < NUM_THETA1_ROW; i++) {
        a[i] = 0;
        for (int j = 1; j < NUM_THETA1_COL; j++) {
            a[i] += theta1[j] * x[j];
        }
    }

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
