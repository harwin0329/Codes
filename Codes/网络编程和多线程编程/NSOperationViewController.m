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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];

        NSBlockOperation *a = [NSBlockOperation  blockOperationWithBlock:^{
            for (int i = 0; i < 10; i++) {
                NSLog(@"AAAAAAAAAA%d",i);
                sleep(1);
            }
        }];
        
        NSBlockOperation *b= [NSBlockOperation  blockOperationWithBlock:^{
            for (int i = 0; i < 10; i++) {
                NSLog(@"BBBBBBBBBBBB%d",i);
                sleep(1);
            }
        }];
        
        NSBlockOperation *c = [NSBlockOperation  blockOperationWithBlock:^{
            for (int i = 0; i < 10; i++) {
                NSLog(@"CCCCCCCCCCC%d",i);
                sleep(1);
            }
        }];
        [a addDependency:b];
        [b addDependency:c];
        
        [queue addOperation:a];
        [queue addOperation:b];
        [queue addOperation:c];
    });

}

- (void)test{
    for (int i = 0; i < 10; i++) {
        sleep(1);
        NSLog(@"%d",i);
    }
}

@end
