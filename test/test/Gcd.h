//
//  Gcd.h
//
//  Created by Jesus++ on 17.05.2020.
//  Copyright © 2020 Jesus++. All rights reserved.
//

#import <Foundation/Foundation.h>

#define gcd Gcd

@interface Gcd : NSProxy
+ (Gcd *)async;
+ (Gcd *)sync;
+ (Gcd *(^)(dispatch_time_t))after;
- (Gcd *)mainQueue;
- (Gcd *)globalQueue;
- (Gcd *)currentQueue;
- (Gcd *)waitForFinished;
- (Gcd *(^)(dispatch_time_t))waitForFinishedOr;
- (Gcd *(^)(dispatch_queue_t))customQueue;
- (void)setRun: (void (^)(void))run;
@end

#define mainQueue mainQueue.run = ^
#define globalQueue globalQueue.run = ^
#define currentQueue currentQueue.run = ^
#define customQueue(Q) customQueue(Q).run = ^
