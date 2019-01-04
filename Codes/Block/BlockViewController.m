//
//  BlockViewController.m
//  Codes
//
//  Created by chenzw on 2019/1/3.
//  Copyright © 2019 Gripay. All rights reserved.
//

#import "BlockViewController.h"
#include <objc/objc.h>

typedef int(^Block)(void);

typedef NSString *(^Competion)(NSDictionary *);

@interface BlockViewController ()

@property (nonatomic, strong) Block blk;

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    self.blk = ^int{
//        NSLog(@"blk");
//        return 0;
//    };
//
//    [self test:self.blk];
//
//    NSLog(@"%d",self.blk());
//
//
    
    NSDictionary *dic = @{@"Key":@"Value"};
    // C语言函数的定义
//    NSLog(@"%d",test(10));
    
    // Block语法
    // Block三种写法
    
    
    
    //函数指针
//    NSString*(*testCompletionStr)(NSDictionary *) = &testCompletion;
//    NSLog(@"%@",testCompletionStr(dic));
    
    // 截获自动变量值
    
    // __block说明符
//    __block int a = 10;
//    int A = 10;
//
//    void(^b)(void) = ^{
//        NSLog(@"%d",a);
//        NSLog(@"%d",A);
//    };
//    a = 99;
//    A = 99;
//    b();
    
    // 截获的自动变量

    
    
}

  NSString *testCompletion(NSDictionary *dic){
    return [dic description];
}




//- (void)test:(Block)b{
//    NSLog(@"2");
//}

int test(int i){
    NSLog(@"%d",i);
    return i*i;
}

@end
