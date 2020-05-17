//
//  Gcd.m
//
//  Created by Jesus++ on 17.05.2020.
//  Copyright © 2020 Jesus++. All rights reserved.
//

#import "Gcd.h"

#undef mainQueue
#undef globalQueue
#undef currentQueue
#undef customQueue

typedef enum: NSUInteger
{
	AsyncType,
	SyncType,
	AfterType,
} GcdType;

@interface Gcd()
@property dispatch_queue_t queue;
@property GcdType type;
@property void (^run_internal)(void);
@property dispatch_semaphore_t semaphore;
@property dispatch_time_t timeout;
@property dispatch_time_t delay;
@end

@implementation Gcd

+ (Gcd *)async
{
	Gcd *gcdObject = Gcd.alloc;
	[gcdObject setType: AsyncType];
	return gcdObject;
}

+ (Gcd *)sync
{
	Gcd *gcdObject = Gcd.alloc;
	[gcdObject setType: SyncType];
	return gcdObject;
}

+ (Gcd *(^)(dispatch_time_t))after
{
	return (Gcd *(^)(dispatch_time_t))^(dispatch_time_t delay)
	{
		Gcd *gcdObject = Gcd.alloc;
		[gcdObject setType: AfterType];
		gcdObject.delay = delay;
		return gcdObject;
	};
}

- (Gcd *)mainQueue
{
	self.queue = dispatch_get_main_queue();
	return self;
}

- (Gcd *)globalQueue
{
	self.queue = dispatch_get_global_queue(0, 0);
	return self;
}

- (Gcd *)currentQueue
{
	self.queue = dispatch_get_current_queue();
	return self;
}

- (Gcd * (^)(dispatch_queue_t))customQueue
{
	return (Gcd * (^)(dispatch_queue_t))^(dispatch_queue_t q)
	{
		self.queue = q;
		return self;
	};
}

- (Gcd *)waitForFinished
{
	self.semaphore = dispatch_semaphore_create(0);
	self.timeout = DISPATCH_TIME_FOREVER;
	return self;
}

- (Gcd *(^)(dispatch_time_t))waitForFinishedOr
{
	return (Gcd * (^)(dispatch_time_t))^(dispatch_time_t timeout)
	{
		self.semaphore = dispatch_semaphore_create(0);
		self.timeout = timeout;
		return self;
	};
}

- (void)setRun: (void (^)(void))run
{
	self.run_internal = run;

	void (^block)(void) = ^
	{
		if (self.run_internal)
		{
			self.run_internal();
		}
		if (self.semaphore)
		{
			dispatch_semaphore_signal(self.semaphore);
		}
	};

	switch (self.type)
	{
	case AsyncType:
		dispatch_async(self.queue, block);
		break;

	case SyncType:
		dispatch_sync(self.queue, block);
		break;

	case AfterType:
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
									 (int64_t)(self.delay)),
					   self.queue, block);
		break;
	}

	if (self.semaphore)
	{
		dispatch_semaphore_wait(self.semaphore,
								dispatch_time(DISPATCH_TIME_NOW,
											  self.timeout));
		self.run_internal = nil;
	}
}

@end
