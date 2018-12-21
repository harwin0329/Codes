//
//  ViewController.m
//  Codes
//
//  Created by chenzw on 2018/11/22.
//  Copyright © 2018 Gripay. All rights reserved.
//

#import "ViewController.h"
#import "CZWTableViewController.h"
#import "Codes-Swift.h"
#import "Point.h"
#include <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "KVCViewController.h"

NSArray * array(){
    NSArray *array = [[NSArray alloc] initWithObjects:@"1",@"3",nil];
    return array;
}

void te(){
    printf("C函数\r");
}

// 以下所有示例代码打印用的Log宏，打印：内存地址，指针，真实类型，引用计数，值
#define LNLog(description,obj) NSLog(@"%@: 内存地址:%p, 指针地址:%p, 真实类型:%@, 引用计数:%lu, 值:%@", (description),(obj),&(obj),(obj).class,(unsigned long)(obj).retainCount,(obj));

@interface ViewController ()
- (void)test;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

+(BOOL)resolveInstanceMethod:(SEL)sel{
//    if (sel == @selector(test)) {
//        class_addMethod(self, sel, (IMP)testTT, "v@:");
//    }
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    if (aSelector == @selector(test)) {
        
    }
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (aSelector == @selector(test)) {
        
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            // UITableview加载优化(Runloop加载优化)OC部分
            CZWTableViewController *viewController = [[CZWTableViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
        case 1:
        {
            // UITableview加载优化(Runloop加载优化)Swift部分
            CZWCellMoreImageVsController *viewController = [[CZWCellMoreImageVsController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
        case 2:
        {
            // Cocoapods
            CocoaPodsViewController *viewController = [[CocoaPodsViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
        case 3:
        {
            // 学习AFNetworkingx
            AFNetworkingViewController *viewController = [[AFNetworkingViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
        case 4:
        {

        }
            break;
            
        case 5:
        {
            // 学习KVC
            KVCViewController *viewController = [[KVCViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
