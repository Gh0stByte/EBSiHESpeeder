#include <substrate.h>
#include <mach-o/dyld.h>
#include <writeData.h>
#import <Cephei/HBPreferences.h>

NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/kr.xsf1re.ebsihespeeder.plist"];
double seekIntervalSec;

%group RateControl
	%hook CNMoviePlayerController
		-(void)setRateArray:(id)arg1 {
			arg1 = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0.05], [NSNumber numberWithFloat:0.1], [NSNumber numberWithFloat:0.15], [NSNumber numberWithFloat:0.2], [NSNumber numberWithFloat:0.25], [NSNumber numberWithFloat:0.3], [NSNumber numberWithFloat:0.35], [NSNumber numberWithFloat:0.45], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.55], [NSNumber numberWithFloat:0.6], [NSNumber numberWithFloat:0.65], [NSNumber numberWithFloat:0.7], [NSNumber numberWithFloat:0.75], [NSNumber numberWithFloat:0.8], [NSNumber numberWithFloat:0.85], [NSNumber numberWithFloat:0.9], [NSNumber numberWithFloat:0.95], [NSNumber numberWithFloat:1.0], [NSNumber numberWithFloat:1.05], [NSNumber numberWithFloat:1.1], [NSNumber numberWithFloat:1.15], [NSNumber numberWithFloat:1.2], [NSNumber numberWithFloat:1.25], [NSNumber numberWithFloat:1.3], [NSNumber numberWithFloat:1.35], [NSNumber numberWithFloat:1.4], [NSNumber numberWithFloat:1.45], [NSNumber numberWithFloat:1.5], [NSNumber numberWithFloat:1.55], [NSNumber numberWithFloat:1.6], [NSNumber numberWithFloat:1.65], [NSNumber numberWithFloat:1.7], [NSNumber numberWithFloat:1.75], [NSNumber numberWithFloat:1.8], [NSNumber numberWithFloat:1.85], [NSNumber numberWithFloat:1.9], [NSNumber numberWithFloat:1.95], [NSNumber numberWithFloat:2.0], nil];
			%orig(arg1);
		}
	%end
%end

%group SeekInterval
	%hook CNMoviePlayerController
		-(void)setSeekInterval:(double)arg1 {
			arg1 = [[prefs objectForKey:@"SeekIntervalSec"] doubleValue];
			if(arg1 == 0) {
					arg1 = 5;
			}
			//NSLog(@"[EBSiHESpeeder] CNMoviePlayerController setSeekInterval = %f", arg1);
			%orig(arg1);
		}
	%end
%end

%ctor {

	HBPreferences *preferences;
	preferences = [[HBPreferences alloc] initWithIdentifier:@"kr.xsf1re.ebsihespeeder"];

    [preferences registerDefaults:@{
			  @"SeekIntervalSec": @5,
        @"SeekInterval": @NO,
        @"RateControl": @NO,
    }];



	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/kr.xsf1re.ebsihespeeder.plist"];
	if(prefs){
		if([prefs[@"RateControl"] boolValue])
			{
				%init(RateControl);
				#if defined __arm64__ || defined __arm64e__
				/* Only Work on 3.9.1 App Version */
				writeData(0x1001DA72C, 0x252E3266);	//DCB "%.1f",0 -> DCB "%.2f",0	-[CNMoviePlayerController movieDurationAvailable:]+624
				writeData(0x1000E4C00, 0x49028052);	//MOV W9, #1 -> MOVZ	W9, #0x12 -[CNMoviePlayerController initWithNibName:bundle:]+4AC
				#endif
			}

		if([prefs[@"SeekInterval"] boolValue])
			{
				%init(SeekInterval);
			}
	}
}
