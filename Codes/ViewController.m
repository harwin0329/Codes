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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
            
        default:
            break;
    }
}

@end
