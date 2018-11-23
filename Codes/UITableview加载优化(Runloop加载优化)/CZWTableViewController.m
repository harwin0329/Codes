//
//  CZWTableViewController.m
//  Codes
//
//  Created by chenzw on 2018/11/22.
//  Copyright © 2018 Gripay. All rights reserved.
//

#import "CZWTableViewController.h"
#import "ImageVsTableViewCell.h"

typedef void(^RunloopBlock)(void);

@interface CZWTableViewController ()

@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, assign) NSInteger maxTaskCount;

@end

@implementation CZWTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ImageVsTableViewCell class ]) bundle:nil] forCellReuseIdentifier:@"reuseIdentifier"];
    
    self.tasks = [NSMutableArray arrayWithCapacity:21];
    self.maxTaskCount = 21;
    [self addRunloopObserver];
}

- (void)addTask:(RunloopBlock)task{
    [self.tasks addObject:task];
    
    if (self.tasks.count > self.maxTaskCount) {
        [self.tasks removeObjectAtIndex:0];
    }
}

static void callout(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    CZWTableViewController *viewController = (__bridge CZWTableViewController *)(info);
    
    if (viewController.tasks.count == 0) {
        return;
    }
    // 取出任务，执行任务
    RunloopBlock task = viewController.tasks.firstObject;
    task();
    [viewController.tasks removeObject:task];
    
}

- (void)addRunloopObserver{
    // 获取当前的Runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    
    // 定义上下文
    CFRunLoopObserverContext context =  {
        0,
        (__bridge void *)(self),
        CFRetain,
        CFRelease,
        NULL,
    };
    
    // 定义观察者
    static CFRunLoopObserverRef defaultRunLoopObserver;
    defaultRunLoopObserver = CFRunLoopObserverCreate(NULL,kCFRunLoopAfterWaiting, YES, 0, &callout, &context);
    
    // 监听Runloop
    CFRunLoopAddObserver(runloop, defaultRunLoopObserver, kCFRunLoopCommonModes);
    
    CFRelease(defaultRunLoopObserver);
}

+ (void)addImageV:(UITableViewCell *)cell index:(NSInteger )index
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat padding = 15.0f;
    CGFloat imageWidth = ( screenWidth - padding*4 ) / 3;
    UIImageView *newImageV = [[UIImageView alloc] initWithFrame:CGRectMake( padding + index * ( imageWidth + padding ), 20, imageWidth, 120)];
    newImageV.tag = 100+index;
    [cell.contentView addSubview:newImageV];
    
    NSURL *url = [NSURL URLWithString:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1015859102,487495968&fm=11&gp=0.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    newImageV.image = [UIImage imageWithData:data];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 9999;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    for (int i = 0; i < 3; i++) {
        [[cell.contentView viewWithTag:100+i] removeFromSuperview];
    }
    
    // 添加任务
    [self addTask:^{
        [CZWTableViewController addImageV:cell index:0];
    }];
    
    [self addTask:^{
        [CZWTableViewController addImageV:cell index:1];
    }];
    
    [self addTask:^{
        [CZWTableViewController addImageV:cell index:2];
    }];

    return cell;
}

@end
