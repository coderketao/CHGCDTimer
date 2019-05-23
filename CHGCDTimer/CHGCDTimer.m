//
//  CHGCDTimer.m
//  03-GCD定时器
//
//  Created by CoderHong on 2019/5/23.
//  Copyright © 2019 CoderHong. All rights reserved.
//

#import "CHGCDTimer.h"

static NSMutableDictionary *_timers = nil;
dispatch_semaphore_t semaphore;

@implementation CHGCDTimer

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _timers = [NSMutableDictionary dictionary];
    });
    
    semaphore = dispatch_semaphore_create(1);
}

/**
 根据任务唯一标识取消定时任务
 
 @param task 任务唯一标识
 */
+ (NSString *)doWithTask:(void(^)(void))task
             start:(NSTimeInterval)start
          interval:(NSTimeInterval)interval repeats:(BOOL)repeat async:(BOOL)async {
    
    if (!task || start < 0 || (interval <= 0 && repeat)) return nil;
    
    // 主队列
    dispatch_queue_t queue = async
    ? dispatch_get_global_queue(0, 0)
    : dispatch_get_main_queue();
    
    // GCD定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // CGD设置开始时间不能传递秒 需要转换成纳秒
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                              interval * NSEC_PER_SEC,
                              0);
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    // 定时器唯一标识
    NSString *name = [NSString stringWithFormat:@"%f", [NSDate date].timeIntervalSince1970];
    // 存放到字典
    _timers[name] = timer;
    dispatch_semaphore_signal(semaphore);
    
    // 设置回调
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeat) {
            [self cacelTask:name];
        }
    });

    dispatch_resume(timer);
    
    return name;
}

/**
 根据任务唯一标识取消定时任务
 
 @param task 任务唯一标识
 */
+ (void)cacelTask:(NSString *)name {
    if (name.length == 0) return;
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_source_t timer = _timers[name];
    if(timer) {
        dispatch_source_cancel(_timers[name]);
        [_timers removeObjectForKey: name];
    }

    dispatch_semaphore_signal(semaphore);
}
@end
