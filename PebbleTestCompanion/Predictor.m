//
//  Predictor.m
//  PebbleTestCompanion
//
//  Created by Taro Minowa on 1/11/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

#import "Predictor.h"
#import "theta1.h"
#import "theta2.h"

@implementation Predictor

static double sigmoid(double z) {
    return 1 / (1 + exp(-z));
}

+ (NSArray *)predict:(const uint32_t *)x;
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:3];

    double z2[NUM_THETA1_ROW];
    uint32_t xone[NUM_THETA1_COL];
    xone[0] = 1;
    memcpy(xone + 1, x, (NUM_THETA1_COL - 1) * sizeof(uint32_t));
    for (int i = 0; i < NUM_THETA1_ROW; i++) {
        z2[i] = 0;
        for (int j = 0; j < NUM_THETA1_COL; j++) {
            z2[i] += theta1[j + NUM_THETA1_COL * i] * xone[j];
        }
    }
    for (int i = 0; i < NUM_THETA1_ROW; i++) {
        z2[i] = sigmoid(z2[i]);
    }

    double zone[NUM_THETA2_COL];
    zone[0] = 1.0;
    memcpy(zone + 1, z2, (NUM_THETA2_COL - 1) * sizeof(double));

    double p[NUM_THETA2_ROW];
    for (int i = 0; i < NUM_THETA2_ROW; i++) {
        p[i] = 0;
        for (int j = 0; j < NUM_THETA2_COL; j++) {
            p[i] += theta2[j + i * NUM_THETA2_COL] * zone[j];
        }
    }
    for (int i = 0; i < NUM_THETA2_ROW; i++) {
        p[i] = sigmoid(p[i]);
    }

    for (int i = 0; i < NUM_THETA2_ROW; i++) {
        [ret addObject:@(p[i])];
    }
    return ret;
}

@end
