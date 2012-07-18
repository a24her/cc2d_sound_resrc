//
//  SoundManager.m
//  GameDemo
//
//  Created by 주형 김 on 12. 7. 2..
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"


@implementation SoundManager

@synthesize soundIDDic;

static SoundManager *_sharedSoundManager = nil;

+ (SoundManager *)sharedSoundManager {
	
	// 아직 객체가 만들어지지 않았다면 init 메서드를 호출하여 새로 만든다.
	@synchronized([SoundManager class]) {
		if (!_sharedSoundManager) {
			[[self alloc] init];
		}
		return _sharedSoundManager;
	}
	
	return nil; // 컴파일러 에러를 막기 위해 추가

}

+ (id) alloc {
	@synchronized([SoundManager class]) {
		_sharedSoundManager = [super alloc];
		return _sharedSoundManager;
	}
	
	return nil; // 컴파일러 에러를 막기 위해 추가
	
}

- (id) init {
	if ( (self = [super init]) ) {
		// SystemSoundID를 보관할 Dictionary를 만든다.
		NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] initWithCapacity:20];
		self.soundIDDic = tmpDic;
		[tmpDic release];
	}
	
	return self;
	
}

- (void) playSystemSound:(NSString *)fileName fileType:(NSString *)type {
	
	@try {
		// 넘어온 파일 이름으로 만들어진 소리가 dictionary에 이미 들어 있는지 확인
		NSNumber *num = (NSNumber *)[self.soundIDDic objectForKey:fileName];
		SystemSoundID soundID;
		
		// 없다면 새로 만든다.
		if (num == nil) {
			NSBundle *mainBundle = [NSBundle mainBundle];
			NSString *path = [mainBundle pathForResource:fileName ofType:type];
			AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
			
			// 만들어진 SystemSoundID를 dictionary에 추가합니다. 파일 이름이 키(key)로 사용됩니다.
			num = [[NSNumber alloc] initWithUnsignedLong:soundID];
			[self.soundIDDic setObject:num forKey:fileName];
		} else {
			// 같은 파일 이름이 있다면 사용
			soundID = [num unsignedLongValue];
		}
		
		// soundID로 소리를 낸다.
		AudioServicesPlaySystemSound(soundID);
	} @catch(NSException *e) {
		// 혹시 파일을 읽어들일 때 문제가 생길 때를 대비하여 예외를 적절히 처리한다.
		NSLog(@"Exception from playSystemSound: %@ for '%@'", e, type);
	}
	
}

- (void) dealloc {
	
	// dictionary에 보관 중이던 SystemSoundID를 릴리즈한다.
	if (self.soundIDDic != nil && [self.soundIDDic count] > 0) {
		NSArray *IDs = [self.soundIDDic allValues];
		if (IDs != nil) {
			for (NSInteger i=0; i < [IDs count]; i++) {
				NSNumber *num = (NSNumber *)[IDs objectAtIndex:i];
				if (num == nil) {
					continue;
				}
				SystemSoundID soundID = [num unsignedLongValue];
				AudioServicesDisposeSystemSoundID(soundID);				
			}
		}
	}
	[soundIDDic release];
	 
	[super dealloc];

}

@end
