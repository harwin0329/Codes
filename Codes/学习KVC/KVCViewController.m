//
//  KVCViewController.m
//  Codes
//
//  Created by chenzw on 2018/12/20.
//  Copyright © 2018 Gripay. All rights reserved.
//

#import "KVCViewController.h"

@interface Animal : NSObject
{
    @private
    NSInteger age;
}

@end
@implementation Animal

@end

@interface Person : Animal
{
    @private
    NSString *name;
}

@end
@implementation Person

@end

@interface Major : NSObject
{
    @private
    NSString *majorName;
}
@end
@implementation Major

@end


@interface Student : Person
{
@private
    NSInteger Id;
}
@property (nonatomic, strong) Major *major;
@end

@implementation Student

@end


@interface KVCViewController ()
{
}

@property (nonatomic, strong) Student *student;


@end

@implementation KVCViewController

- (Student *)student{
    if (_student == nil) {
        _student = [[Student alloc] init];

    }
    return _student;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.student addObserver:self forKeyPath:@"major.majorName" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    
    NSArray *array = [NSArray arrayWithObjects:@"10.11", @"20.22",@"a", nil];
    NSArray *resultArray1 = [array valueForKeyPath:@"doubleValue.intValue"];
    NSLog(@"%@", resultArray1);

    NSArray *resultArray2 = [array valueForKey:@"length"];
    NSLog(@"%@", resultArray2);

    NSArray *resultArray3 = [array valueForKey:@"capitalizedString"];
    NSLog(@"%@", resultArray3);
    
    NSArray *resultArray4 = [array valueForKey:@"appendString"];
    NSLog(@"%@", resultArray4);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.student setValue:@"英语" forKeyPath:@"major.majorName"];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self.student setValue:@"语文" forKeyPath:@"major.majorName"];
}

//+ (NSSet<NSString *> *)keyPathsForValuesAffecting<#DependentKey#>
//{
//    return [NSSet setWithObjects:@"<#keyPath#>", nil];
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([[keyPath description]  isEqualToString:@"major.majorName"]) {
        NSLog(@"%@",[change objectForKey:NSKeyValueChangeNewKey]);
        NSLog(@"%@",[change objectForKey:NSKeyValueChangeOldKey]);
        if ([[change objectForKey:NSKeyValueChangeNewKey] isEqualToString:@"语文"]) {
            self.view.backgroundColor = [UIColor redColor];
        }
        else if ([[change objectForKey:NSKeyValueChangeNewKey] isEqualToString:@"英语"]){
            self.view.backgroundColor = [UIColor greenColor];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
