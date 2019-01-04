//
//  NetViewController.m
//  Codes
//
//  Created by chenzw on 2018/12/21.
//  Copyright © 2018 Gripay. All rights reserved.
//

#import "NetViewController.h"

@interface NetViewController ()

@property (nonatomic, assign)NSInteger tickets;

@end

@implementation NetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    NSLog(@"AAA");
//    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(th2:) object:nil];
//    thread2.name = @"线程2";
//    [thread2 start];
//
//    NSLog(@"BBB");
//    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(th3:) object:nil];
//    thread3.name = @"线程3";
//    [thread3 start];
//
//    NSLog(@"CCC");
//
//
//    [self performSelectorOnMainThread:@selector(main) withObject:nil waitUntilDone:NO];
//    NSLog(@"执行主线程后的下一句代码");
    
//    self.tickets = 100;
//    NSThread *t1 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTickets) object:nil];
//    t1.name = @"售票员A";
//    [t1 start];
//
//    NSThread *t2 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTickets) object:nil];
//    t2.name = @"售票员B";
//    [t2 start];

    // GCD
    // 串行队列异步
//    [self serialAsync];
    // 串行队列同步步
//    [self serialSync];
    
    
    // 主线程同步
//    [self mainAsync];
    
    
    // 3秒后执行
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"3秒已到");
//    });
    
    
//    // 创建一个Serial Queue,用于执行完成处理
//    dispatch_queue_t serialQueue = dispatch_queue_create("com.Sky.serialTest", NULL);
//    // 创建默认优先级Concurrent Queue
//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
//    // 创建Dispatch Group
//    dispatch_group_t group = dispatch_group_create();
//    // 添加操作
//    dispatch_group_async(group, concurrentQueue, ^{printf("处理1\n");
//        sleep(2);
//    });
//    dispatch_group_async(group, concurrentQueue, ^{printf("处理2\n");
//        sleep(3);
//    });
//    dispatch_group_async(group, concurrentQueue, ^{printf("处理3\n");
//        sleep(5);
//    });
//    // 操作完成执行
//    dispatch_group_notify(group, serialQueue, ^{printf("处理全部完成\n");});
    
    
    
    // 执行这个dispatch_get_main_queue队列的是主线程。执行了dispatch_sync函数后，将block添加到了main_queue中，同时调用dispatch_syn这个函数的线程（也就是主线程）被阻塞，等待block执行完成，而执行主线程队列任务的线程正是主线程，此时他处于阻塞状态，所以block永远不会被执行，因此主线程一直处于阻塞状态。因此这段代码运行后，并非卡在block中无法返回，而是根本无法执行到这个block
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSLog(@"1");
    });
    
}

- (void)mainAsync{
    NSLog(@"主线程开始");
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 10; i++ ) {
            sleep(1);
            NSLog(@"******%d %@",i,[NSThread currentThread]);
        }
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 10; i++ ) {
            sleep(1);
            NSLog(@"&&&&&&&%d %@",i,[NSThread currentThread]);
        }
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 10; i++ ) {
            sleep(1);
            NSLog(@"&&&&&&&%d %@",i,[NSThread currentThread]);
        }
    });
    NSLog(@"主线程结束");
}

-(void)serialAsync
{
    NSLog(@"开始");
    dispatch_queue_t queue = dispatch_queue_create("自定义队列的唯一字符串", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"第一个开始睡3秒");
        sleep(3);
        NSLog(@"第一个睡完了");
        for (int i = 0; i < 10; i++ ) {
            sleep(1);
            NSLog(@"******%d %@",i,[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        NSLog(@"第二个开始睡3秒");
        sleep(3);
        NSLog(@"第二个睡完了");
        for (int i = 0; i < 10; i++ ) {
            sleep(1);
            NSLog(@"&&&&&&&%d %@",i,[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        NSLog(@"第3个开始睡3秒");
        sleep(3);
        NSLog(@"第3个睡完了");
        for (int i = 0; i < 10; i++ ) {
            sleep(1);
            NSLog(@"￥￥￥￥￥￥￥￥%d %@",i,[NSThread currentThread]);
        }
    });
    NSLog(@"结束");
}

-(void)serialSync
{
    NSLog(@"开始");
    dispatch_queue_t queue = dispatch_queue_create("自定义队列的唯一字符串", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"第一个开始睡3秒");
        sleep(3);
        NSLog(@"第一个睡完了");
        for (int i = 0; i < 10; i++ ) {
            NSLog(@"******%d %@",i,[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"第二个开始睡3秒");
        sleep(3);
        NSLog(@"第二个睡完了");
        for (int i = 0; i < 10; i++ ) {
            NSLog(@"&&&&&&&%d %@",i,[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"第3个开始睡3秒");
        sleep(3);
        NSLog(@"第3个睡完了");
        for (int i = 0; i < 10; i++ ) {
            NSLog(@"￥￥￥￥￥￥￥￥%d %@",i,[NSThread currentThread]);
        }
    });
    NSLog(@"结束");
}

- (void)dealloc{
    NSLog(@"88");
}

- (void)saleTickets{
    while (YES) {
        [NSThread sleepForTimeInterval:1.0];
        //互斥锁 -- 保证锁内的代码在同一时间内只有一个线程在执行
        @synchronized (self){
            //1.判断是否有票
            if (self.tickets > 0) {
                //2.如果有就卖一张
                self.tickets --;
                NSLog(@"还剩%ld张票  %@",(long)self.tickets,[NSThread currentThread]);
            }else{
                //3.没有票了提示
                [[NSThread currentThread] cancel];
                NSLog(@"卖完了 %@",[NSThread currentThread]);
                
                break;
            }
        }
    }
    
}

- (void)main{
    NSLog(@"准备睡10秒");
    sleep(10);
    NSLog(@"睡完了");
}


- (void)th2:(NSThread *)th {
    NSLog(@"th:%@----当前:%@ ---- 主线程:%@",th,[NSThread currentThread],[NSThread mainThread]);
    
    [NSThread sleepForTimeInterval:3];
    for (int i = 0; i < 3; i++) {
        NSLog(@"正在执行线程2...");
    }
}

- (void)th3:(NSThread *)th {
    NSLog(@"th:%@----当前:%@ ---- 主线程:%@",th,[NSThread currentThread],[NSThread mainThread]);

    [NSThread sleepForTimeInterval:3];
    for (int i = 0; i < 3; i++) {
        NSLog(@"正在执行线程3...");
    }
}


@end
