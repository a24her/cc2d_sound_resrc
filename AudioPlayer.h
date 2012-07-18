
#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

typedef enum {
	kAudio_Background
} AudioPlayerType;


@interface AudioPlayer : NSObject {
	AVAudioPlayer *backgroundAudioPlayer;
}

@property (nonatomic, retain) AVAudioPlayer *backgroundAudioPlayer;

+ (AudioPlayer *)sharedAudioPlayer;

- (AVAudioPlayer *)createAudioPlayer:(NSString *)fileName fileType:(NSString *)fileType volumn:(CGFloat)volumn;

- (void) playAudio:(AudioPlayerType)type;
- (void) stopAudio:(AudioPlayerType)type;

@end
