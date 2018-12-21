//
//  main.m
//  Codes
//
//  Created by chenzw on 2018/11/22.
//  Copyright © 2018 Gripay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"



int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        int t = 1;
        
        const int *a = &t;
 
        

        printf("——————\r",a,"\r");
        printf("——————\r",&a,"\r");

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
