//
//  ViewController.m
//  test
//
//  Created by Jesus++ on 18.05.2020.
//  Copyright © 2020 Jesus++. All rights reserved.
//

#import "ViewController.h"
#import "Gcd.h"

@implementation ViewController

-(void)viewDidAppear
{
	[super viewDidAppear];

	gcd.after(3 *NSEC_PER_SEC).globalQueue
	{
		gcd.async.waitForFinishedOr(3 *NSEC_PER_SEC).globalQueue
		{
			gcd.async.mainQueue
			{
				self.view.layer.backgroundColor = NSColor.redColor.CGColor;
			};
			sleep(3);
		};
		gcd.async.mainQueue
		{
			self.view.layer.backgroundColor = NSColor.blueColor.CGColor;
		};
	};
}


@end
