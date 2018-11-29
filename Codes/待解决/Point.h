//
//  Point.h
//  Codes
//
//  Created by chenzw on 2018/11/27.
//  Copyright © 2018 Gripay. All rights reserved.
//

#ifndef Point_h
#define Point_h

#include <stdio.h>

typedef struct {
    void *info;
    const void *(*retain)(const void *info);
}Context;

void abcPrint(Context *info, void (*callback)(void *));

#endif /* Point_h */
