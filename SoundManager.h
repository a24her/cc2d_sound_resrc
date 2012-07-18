
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SoundManager : NSObject {

	// 만들어진 SystemSoundID를 재사용하기 위해 보관할 dictionary
	NSMutableDictionary *soundIDDic;
	
}

@property (nonatomic, retain) NSMutableDictionary *soundIDDic;

// singleton을 만든다.
+ (SoundManager *)sharedSoundManager;
- (void) playSystemSound:(NSString *)fileName fileType:(NSString *)type;

@end
