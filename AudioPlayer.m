
#import "AudioPlayer.h"


@implementation AudioPlayer

@synthesize backgroundAudioPlayer;

// singleton
static AudioPlayer *_sharedAudioPlayer = nil;

+ (AudioPlayer *) sharedAudioPlayer {
	@synchronized([AudioPlayer class]) {
		if (!_sharedAudioPlayer) {
			[[self alloc] init];
		}
		
		return _sharedAudioPlayer;
	}
	
	return nil; // 컴파일러 에러를 막기 위해 추가한다.
}

+ (id) alloc {
	@synchronized([AudioPlayer class]) {
		_sharedAudioPlayer = [super alloc];
		return _sharedAudioPlayer;
	}
	
	return nil; // 컴파일러 에러를 막기 위해 추가한다.
	
}

- (AVAudioPlayer *) createAudioPlayer:(NSString *)fileName fileType:(NSString *)fileType volumn:(CGFloat)volumn {
	
	// 넘겨받은 파일의 전체 경로를 찾는다.
	NSString *audioPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
	
	// 메인번들에 들어 있는 음악 파일로 AVAudioPlayer 객체를 만들고 반복 횟수, 소리 세기 등을 설정한다.
	AVAudioPlayer *tmpAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioPath] error:NULL];
	
	tmpAudioPlayer.numberOfLoops = 0;
	tmpAudioPlayer.volume = volumn;
	
	// 소리를 내기 위해 버퍼에 로딩한다. play메서드를 호출하면 자동으로 호출된다.
	[tmpAudioPlayer prepareToPlay];
	
	[tmpAudioPlayer autorelease];
	
	return tmpAudioPlayer;
	
}

// 음악을 재생한다.
// 아직 객체가 만들어지지 않았다면 객체를 만들고 재생을 시작한다.
- (void) playAudio:(AudioPlayerType)type {
	if (type == kAudio_Background) {
		if (self.backgroundAudioPlayer == nil) {
			self.backgroundAudioPlayer = [self createAudioPlayer:@"audioBG" fileType:@"wav" volumn:0.7];
			
			// 배경음악이므로 반복해서 재생한다. -1 은 무한반복
			self.backgroundAudioPlayer.numberOfLoops = -1;
		}
		[self.backgroundAudioPlayer play];
	}
}

// 음악 재생을 정지합니다.
- (void) stopAudio:(AudioPlayerType)type {
	if (type == kAudio_Background && self.backgroundAudioPlayer != nil) {
		[self.backgroundAudioPlayer stop];
		self.backgroundAudioPlayer.currentTime = 0; // 처음부터 재생하기 위해서는 currentTime 에 0을 준다.
	}
}

- (void) dealloc {
	if (self.backgroundAudioPlayer != nil) {
		[self stopAudio:kAudio_Background];
		[backgroundAudioPlayer release];
	}
	[super dealloc];
}

@end
