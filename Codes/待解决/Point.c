//
//  Point.c
//  Codes
//
//  Created by chenzw on 2018/11/27.
//  Copyright © 2018 Gripay. All rights reserved.
//

#include "Point.h"



// c 的实现文件
void abcPrint(Context *info, void (*callback)(void *)){
    
    (*callback)(info->info);
    printf("abcPrint call");
}


