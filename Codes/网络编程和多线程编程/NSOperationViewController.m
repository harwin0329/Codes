//
//  NSOperationViewController.m
//  Codes
//
//  Created by chenzw on 2019/1/3.
//  Copyright © 2019 Gripay. All rights reserved.
//

#import "NSOperationViewController.h"

@interface NSOperationViewController ()

@end

@implementation NSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test) object:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [invocationOperation start];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 100; i < 110; i++) {
                NSLog(@"%d",i);
            }
        });
    });
        
}

- (void)test{
    for (int i = 0; i < 10; i++) {
        sleep(1);
        NSLog(@"%d",i);
    }
}

@end
