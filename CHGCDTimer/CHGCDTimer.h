//
//  CHGCDTimer.h
//  03-GCD定时器
//
//  Created by CoderHong on 2019/5/23.
//  Copyright © 2019 CoderHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHGCDTimer : NSObject
 /**
  开启定时任务
  
  @return 任务唯一标识
  */
+ (NSString *)doWithTask:(void(^)(void))task
             start:(NSTimeInterval)start
          interval:(NSTimeInterval)interval repeats:(BOOL)repeat async:(BOOL)async;

+ (NSString *)doWithTask:(id)target
                selector:(SEL)selector
                   start:(NSTimeInterval)start
                interval:(NSTimeInterval)interval
                 repeats:(BOOL)repeat
                   async:(BOOL)async;


/**
 根据任务唯一标识取消定时任务

 @param task 任务唯一标识
 */
+ (void)cacelTask:(NSString *)task;

@end
