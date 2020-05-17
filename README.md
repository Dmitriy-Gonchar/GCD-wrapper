# GCD-wrapper
Obj-C Grand Central Dispatch convenient wrapper

###Main queue usage:

```
dispatch_async(dispatch_get_main_queue(), ^
{
	// UI code
});
```
with wrapper:

```
gcd.async.mainQueue
{
	// UI code
};
```
###Dispatch after usage:

```
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)),
				   dispatch_get_global_queue(0, 0)(), ^
{
	// code
});
```
with wrapper:

```
gcd.after(10 * NSEC_PER_SEC).globalQueue
{
	// code
};
```
###Waiting for block finished usage:

```
gcd.async.waitForFinished.globalQueue
{
	// code
};
```
or limited by timeout:

```
gcd.async.waitForFinishedOr(10 * NSEC_PER_SEC).globalQueue
{
	// code
};
```
