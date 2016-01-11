//
//  Predictor.h
//  PebbleTestCompanion
//
//  Created by Taro Minowa on 1/11/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Predictor : NSObject

+ (NSArray *)predict:(const uint32_t *)x;

@end
