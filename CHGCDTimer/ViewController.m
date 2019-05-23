//
//  ViewController.m
//  CHGCDTimer
//
//  Created by CoderHong on 2019/5/23.
//  Copyright © 2019 CoderHong. All rights reserved.
//

#import "ViewController.h"
#import "CHGCDTimer.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *taskID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.taskID = [CHGCDTimer doWithTask:^{
        NSLog(@"111");
    } start:2.0 interval:1.0 repeats:YES async:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [CHGCDTimer cacelTask:self.taskID];
}


@end
