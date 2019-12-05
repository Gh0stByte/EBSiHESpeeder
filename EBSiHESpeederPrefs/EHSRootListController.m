#include <spawn.h>
#import <Cephei/HBPreferences.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSListController.h>

@interface EHSRootListController : PSListController 

@end

@implementation EHSRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

-(void)twitter_xsf1re {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/XsF1re"]];
}

-(void)resetPrefs:(id)sender {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"EBSiHESpeeder"
        message:@"EBSi 고교강의 속도조절기의 모든 설정들을 초기화하실건가요?\n자동으로 리스프링됩니다."
        preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"초기화" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action){
    	HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"kr.xsf1re.ebsihespeeder"];
    	[prefs removeAllObjects];
    UIAlertController *alert_respring = [UIAlertController
                              alertControllerWithTitle:@"잠시후 리스프링됩니다."
                              message:@"조금만 기다려 주세요!"
                              preferredStyle:UIAlertControllerStyleAlert];
[self presentViewController:alert_respring animated:YES completion:nil];
[self performSelector:@selector(respring:) withObject:nil afterDelay:3.0];
        }
    ];

    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }
    ];

    [alert addAction:ok];
    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:nil];
    

}

- (void)respring:(id)sender {
	pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}



@end
