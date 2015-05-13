//
//  SceneControlView.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-6.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "SceneControlView.h"
#import "ILBarButtonItem.h"
#import "UINavigationBar+customBar.h"
#import "AppDelegate.h"
#import "UIDevice+Resolutions.h"
#import <OpenEars/OEPocketsphinxController.h>
#import <OpenEars/OEFliteController.h>
#import <OpenEars/OELanguageModelGenerator.h>
#import <OpenEars/OELogging.h>
#import <OpenEars/OEAcousticModel.h>
#import "XYAlertViewHeader.h"

@implementation SegmentData
@synthesize light = _light;
@synthesize one = _one;
@synthesize two = _two;
@synthesize three = _three;
@synthesize four = _four;
@synthesize five = _five;

-(id)initWithName:(int) light oneseg :(int) one twoseg :(int) two threeseh :(int) three fourseg :(int) four fiveseg :(int) five
{
    self = [super init];
    if(self)
    {

    _light = light;
    _one = one;
    _two = two;
    _three = three;
    _four = four;
    _five = five;
    }
    return self;
}

@end

@implementation SettingData
@synthesize light = _light;
@synthesize color = _color;
@synthesize type = _type;
@synthesize seg = _seg;

-(id)initWithName:(int) type light:(int)light color:(int)color segment:(int) seg
{
    self = [super init];
    if(self)
    {
    _light = light;
    _color = color;
    _type = type;
    _seg = seg;
    }
    return self;
}


@end

@interface SceneControlView ()
@property (nonatomic, assign) int restartAttemptsDueToPermissionRequests;
@property (nonatomic, assign) BOOL startupFailedDueToLackOfPermissions;

//@property (nonatomic, strong) Slt *slt;

@property (nonatomic, strong) OEEventsObserver *openEarsEventsObserver;
@property (nonatomic, strong) OEPocketsphinxController *pocketsphinxController;
@property (nonatomic, strong) OEFliteController *fliteController;

// Things which help us show off the dynamic language features.
@property (nonatomic, copy) NSString *pathToFirstDynamicallyGeneratedLanguageModel;
@property (nonatomic, copy) NSString *pathToFirstDynamicallyGeneratedDictionary;
@property (nonatomic, copy) NSString *pathToSecondDynamicallyGeneratedLanguageModel;
@property (nonatomic, copy) NSString *pathToSecondDynamicallyGeneratedDictionary;

@end

@implementation SceneControlView


#pragma mark -
#pragma mark View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _ble = nil;
        _device = nil;
        _listing = FALSE;
        _ResultcheckQuenue = [[NSOperationQueue alloc] init];
        _closed = false;
        
        [self commInit];
    }
    
    return self;
}

- (id)initWithDevice:(Device*)device ble:(BLENetworkControl*)ble
{
    self = [super init];
    if (self) {
        _ble = ble;
        _device = device;
        _listing = FALSE;
        _ResultcheckQuenue = [[NSOperationQueue alloc] init];
        _closed = false;
        [self commInit];
        if(_device != nil)
            [_navigateBar setCaptureText:_device.name];
        
        AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if( apd && apd.BLENetworkControl)
        {
            [_control setSwitch:[apd.BLENetworkControl getStatus]];
            
        }
    }
    
    return self;
}

-(void)commInit{
    _listing = FALSE;
    _ResultcheckQuenue = [[NSOperationQueue alloc] init];
    _closed = false;
    
    int currentResolution = (int)[UIDevice currentResolution];
    
    
    
    int modeHeight = 52;
    int title_font_size = 24;
    
    switch (currentResolution) {
            // iPhone 1,3,3GS 标准分辨率  像素(320x480px)
        case UIDevice_iPhoneStandardRes:
            // iPhone 4,4S 高清分辨率  像素(320x480px)
        case UIDevice_iPhoneHiRes:
            modeHeight = 45;
            title_font_size = 18;
            break;
            // iPhone 5 高清分辨率  像素(320x568px)
        case UIDevice_iPhoneTallerHiRes:
            modeHeight = 52;
            title_font_size = 20;
            break;
            //iPhone6  高清分辨率  像素(375x667px)
        case UIDevice_iPhone6_Res:
            modeHeight = 68;
            title_font_size = 22;
            break;
            //iPhon6+  高清分辨率  像素(424x736px)
        case UIDevice_iPhonePlus:
            modeHeight = 78;
            title_font_size = 22;
            break;
            
            // iPad 1,2 标准分辨率  像素(768x1024px)
        case UIDevice_iPadStandardRes:
            // iPad 3 High Retina  像素(768x1024px)
        case UIDevice_iPadHiRes:
            title_font_size = 30;
            modeHeight = 128;
            break;
            
        default:
            break;
    }
    
    
    //创建一个导航栏集合
    CGRect screen = [ UIScreen mainScreen ].bounds;
    int componenttop = 20,componentheight = 50;
    
    
    _navigateBar = [[NavigateBarView alloc] initWithDevice:CGRectMake(0, componenttop, screen.size.width, componentheight) device:nil];
    _navigateBar.delegate = self;
    [_navigateBar setCaptureText:@"控制"];
    [self.view addSubview:_navigateBar];
    componenttop += componentheight;
    
    
    //模式选择栏,标题就那么宽
    componentheight = 30;
    if(currentResolution >= UIDevice_iPadStandardRes)
        componentheight = 40;
    _titleModel = [[UILabel alloc] initWithFrame:CGRectMake(0, componenttop, self.view.frame.size.width/2, componentheight)];
    _titleModel.backgroundColor = [UIColor colorWithRed:0x21/255.0 green:0xF1/255.0 blue:0xF1/255.0 alpha:1];
    _titleModel.textColor = [UIColor colorWithRed:0x1A/255.0 green:0x95/255.0 blue:0x1D/255.0 alpha:1];
    _titleModel.textAlignment = NSTextAlignmentLeft;
    _titleModel.font = [UIFont systemFontOfSize:title_font_size];

    _titleModel.text = NSLocalizedString(@"selectMode", nil);
    _titleModel.userInteractionEnabled = YES;
    UITapGestureRecognizer* selectTapGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewClick)];
    [_titleModel addGestureRecognizer:selectTapGesturRecognizer ];
    [self.view addSubview:_titleModel];
    
    _titleDelay = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, componenttop, self.view.frame.size.width/2, componentheight)];
    _titleDelay.backgroundColor = [UIColor colorWithRed:0x21/255.0 green:0xF1/255.0 blue:0xF1/255.0 alpha:1];
    _titleDelay.textColor = [UIColor colorWithRed:0x1A/255.0 green:0x95/255.0 blue:0x1D/255.0 alpha:1];
    _titleDelay.font = [UIFont systemFontOfSize:title_font_size];

    _titleDelay.textAlignment = NSTextAlignmentLeft;
    _titleDelay.text = NSLocalizedString(@"delayMode", nil);
    _titleDelay.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* delayTapGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delayViewClick)];
    
    [_titleDelay addGestureRecognizer:delayTapGesturRecognizer ];
    
    [self.view addSubview:_titleDelay];
    
    componenttop += componentheight;
    
    //模式列表
    _modes = [[ModelListView alloc] initWithFrame:CGRectMake(0, componenttop, self.view.frame.size.width, modeHeight*5)];
    _modes.viewDelegate = self;
    
    [self.view addSubview:_modes];
    _modes.hidden = NO;
    
    //分段列表
    _segments = [[SegmentListView alloc] initWithFrame:CGRectMake(0, componenttop, self.view.frame.size.width, modeHeight*5)];
    _segments.viewDelegate = self;
    [self.view addSubview:_segments];
    _segments.hidden = YES;
    
    
    //延时列表
    _delaies = [[DelaylListView alloc] initWithFrame:CGRectMake(0, componenttop, self.view.frame.size.width, modeHeight*5)];
    _delaies.delayDelegate = self;
    [_delaies setDelay:_device.delay];
    [self.view addSubview:_delaies];
    _delaies.hidden = YES;
    
    componenttop += modeHeight*5;
    
    componentheight = 30;
    if(currentResolution >= UIDevice_iPadStandardRes)
        componentheight = 40;

    //自定义控制标题栏
    _titleControl =[[UILabel alloc] initWithFrame:CGRectMake(0, componenttop, self.view.frame.size.width, componentheight)];
    _titleControl.backgroundColor = [UIColor colorWithRed:0x21/255.0 green:0xF1/255.0 blue:0xF1/255.0 alpha:1];
    _titleControl.textColor = [UIColor colorWithRed:0x1A/255.0 green:0x95/255.0 blue:0x1D/255.0 alpha:1];
    _titleControl.text = NSLocalizedString(@"freeMode", nil);
    _titleControl.font = [UIFont systemFontOfSize:title_font_size];

    [self.view addSubview:_titleControl];
    componenttop += componentheight;
    
    //亮度调节控制器
    _control = [[SceneControl alloc] initWithType:CGRectMake(0, componenttop, self.view.frame.size.width, self.view.frame.size.height - componenttop) type:_device.type];
    _control.delegate = self;
    [self.view addSubview:_control];
    
}


- (void)viewDidLoad
{
#ifdef _DEBUG_LOG
    NSLog(@"SceneControlView viewDidLoad ");
#endif
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
    
}


-(void) initOP
{
    
    self.fliteController = [[OEFliteController alloc] init];
    self.openEarsEventsObserver = [[OEEventsObserver alloc] init];
    self.openEarsEventsObserver.delegate = self;
    
    self.restartAttemptsDueToPermissionRequests = 0;
    self.startupFailedDueToLackOfPermissions = FALSE;
    
    [OELogging startOpenEarsLogging];
    [self.openEarsEventsObserver setDelegate:self];
    [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
}

//按下home键后终止监听器
- (void)applicationWillResignActive:(NSNotification *)notification
{
    [self stopListening];
    
    [_control setMicing:NO];
    
}
//第二次进入action
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [_control setMicing:NO];
    
}

//每次界面活动的时候先打开监听器
- (void) viewWillAppear:(BOOL)animated
{
    //[self startListening];
    [_control setMicing:NO];

}


-(void)operationAction:(id)obj
{
    
    [NSThread sleepForTimeInterval:4.0f];

    if(_ble)
        [_ble    ReadDataFromPrepharal];
};


//每次退出界面的时候关闭监听器
- (void)viewWillDisappear:(BOOL)animated
{
    [self stopListening];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark OEEventsObserver delegate methods
//设置语音文件路径,中文定义，英文还没加
-(void)setPath
{
    
}



//开始监听
- (void) startListening
{
    {
        
        //if(languageModelGenerator == nil)
        {
            NSArray *languageArray = @[@"white",
                                            @"whitel",
                                            @"whiteg",
                                            @"save",
                                            @"dark",
                                            @"light",
                                            @"closelamb",
                                            @"openlamb",
                                            @"warm",
                                            @"warml",
                                            @"warmg",
                                            @"natural",
                                            @"highlight",
                                            @"breathing",
                                            @"look",
                                            @"night",
                                            @"game"];
            
            OELanguageModelGenerator *languageModelGenerator = [[OELanguageModelGenerator alloc] init];
            
            NSError *error = [languageModelGenerator generateLanguageModelFromArray:languageArray withFilesNamed:@"FirstOpenEarsDynamicLanguageModel" forAcousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelMandarin"]];
            
            
            if(error) {
#ifdef _DEBUG_LOG
                NSLog(@"Dynamic language generator reported error %@", [error description]);
#endif
            } else {
                self.pathToFirstDynamicallyGeneratedLanguageModel = [languageModelGenerator pathToSuccessfullyGeneratedLanguageModelWithRequestedName:@"FirstOpenEarsDynamicLanguageModel"];
                self.pathToFirstDynamicallyGeneratedDictionary = [languageModelGenerator pathToSuccessfullyGeneratedDictionaryWithRequestedName:@"FirstOpenEarsDynamicLanguageModel"];
            }
            
        }
        
        
        [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil]; // Call this once before setting properties of the OEPocketsphinxController instance.
        
        if(![OEPocketsphinxController sharedInstance].isListening) {
            [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:self.pathToFirstDynamicallyGeneratedLanguageModel dictionaryAtPath:self.pathToFirstDynamicallyGeneratedDictionary acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelMandarin"] languageModelIsJSGF:FALSE]; // Start speech recognition if we aren't already listening.
        }
    
    }
}

//结束监听
- (void) stopListening
{
    NSError *error = nil;
    if([OEPocketsphinxController sharedInstance].isListening){
        error = [[OEPocketsphinxController sharedInstance] stopListening];
        if(error)
            NSLog(@"Error while stopping listening in audioInputDidBecomeUnavailable: %@", error);
        _listing = FALSE;
    }
}

//监听返回结果
- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID
{
    [self hypothesisAction:hypothesis];
}

-(void)hypothesisAction:(NSString *)hypothesis
{
    NSArray *array = [hypothesis componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
    
    for(NSString *str in array)
    {
        if([str isEqualToString:@"openlamb"])
        {
            [_control controlSwitch:0];
        } else if([str isEqualToString:@"closelamb"])
        {
            [_control controlSwitch:1];
        } else if([str isEqualToString:@"white"]){
            [_control controlColor:100];
        } else if([str isEqualToString:@"warm"]){
            [_control controlColor:0];
        } else if([str isEqualToString:@"whiteg"]){
            [_control additionColorValue];
        } else if([str isEqualToString:@"warmg"]){
            [_control subtractionColorValue];
        } else if([str isEqualToString:@"whitel"]){
            [_control subtractionLightValue];
        } else if([str isEqualToString:@"warml"]){
            [_control subtractionLightValue];
        } else if([str isEqualToString:@"light"]){
            [_control additionLightValue];
        } else if([str isEqualToString:@"dark"]){
            [_control subtractionLightValue];
        } else if([str isEqualToString:@"highlight"]){
            [self speakHighLight];
        } else if([str isEqualToString:@"look"]){
            [_modes controlMode:1];
        } else if([str isEqualToString:@"breathing"]){
            [_modes controlMode:2];
        } else if([str isEqualToString:@"game"]){
            [_modes controlMode:3];
        } else if([str isEqualToString:@"night"]){
            [self speakNight];
        } else if([str isEqualToString:@"延时30分钟"]){
            [_delaies controlDelay:30];
        } else if([str isEqualToString:@"延时60分钟"]){
            [_delaies controlDelay:60];
        } else if([str isEqualToString:@"延时90分钟"]){
            [_delaies controlDelay:90];
        } else if([str isEqualToString:@"延时120分钟"]){
            [_delaies controlDelay:120];
        } else if([str isEqualToString:@"关闭延时"]){
            [_delaies controlDelay:0];
        }
    }
}


//#ifdef kGetNbest
- (void) pocketsphinxDidReceiveNBestHypothesisArray:(NSArray *)hypothesisArray { // Pocketsphinx has an n-best hypothesis dictionary.
#ifdef _DEBUG_LOG
    NSLog(@"Local callback:  hypothesisArray is %@",hypothesisArray);
#endif
}
//#endif
- (void) audioSessionInterruptionDidBegin {
    
    NSError *error = nil;
    if([OEPocketsphinxController sharedInstance].isListening) {
        error = [[OEPocketsphinxController sharedInstance] stopListening]; // React to it by telling Pocketsphinx to stop listening (if it is listening) since it will need to restart its loop after an interruption.
        if(error) NSLog(@"Error while stopping listening in audioSessionInterruptionDidBegin: %@", error);
    }
}

// An optional delegate method of OEEventsObserver which informs that the interruption to the audio session ended.
- (void) audioSessionInterruptionDidEnd {
    NSLog(@"Local callback:  AudioSession interruption ended."); // Log it.
    
    // We're restarting the previously-stopped listening loop.
    if(![OEPocketsphinxController sharedInstance].isListening){
        [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:self.pathToFirstDynamicallyGeneratedLanguageModel dictionaryAtPath:self.pathToFirstDynamicallyGeneratedDictionary acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelMandarin"] languageModelIsJSGF:FALSE]; // Start speech recognition if we aren't currently listening.
    }
    
    // We're restarting the previously-stopped listening loop.
//    if(![OEPocketsphinxController sharedInstance].isListening){
//        [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelMandarin"] languageModelIsJSGF:FALSE]; // Start speech recognition if we aren't currently listening.
//    }
}

// An optional delegate method of OEEventsObserver which informs that the audio input became unavailable.
- (void) audioInputDidBecomeUnavailable {
    NSLog(@"Local callback:  The audio input has become unavailable"); // Log it.
    NSError *error = nil;
    if([OEPocketsphinxController sharedInstance].isListening){
        error = [[OEPocketsphinxController sharedInstance] stopListening]; // React to it by telling Pocketsphinx to stop listening since there is no available input (but only if we are listening).
        if(error) NSLog(@"Error while stopping listening in audioInputDidBecomeUnavailable: %@", error);
    }
}

// An optional delegate method of OEEventsObserver which informs that the unavailable audio input became available again.
- (void) audioInputDidBecomeAvailable {
    if(![OEPocketsphinxController sharedInstance].isListening) {
        [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:self.pathToFirstDynamicallyGeneratedLanguageModel dictionaryAtPath:self.pathToFirstDynamicallyGeneratedDictionary acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelMandarin"] languageModelIsJSGF:FALSE]; // Start speech recognition, but only if we aren't already listening.
    }
    
}
// An optional delegate method of OEEventsObserver which informs that there was a change to the audio route (e.g. headphones were plugged in or unplugged).
- (void) audioRouteDidChangeToRoute:(NSString *)newRoute {
    NSLog(@"Local callback: Audio route change. The new audio route is %@", newRoute); // Log it.
    NSError *error = [[OEPocketsphinxController sharedInstance] stopListening]; // React to it by telling the Pocketsphinx loop to shut down and then start listening again on the new route
    
    if(error)NSLog(@"Local callback: error while stopping listening in audioRouteDidChangeToRoute: %@",error);
    
    
    if(![OEPocketsphinxController sharedInstance].isListening) {
        [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:self.pathToFirstDynamicallyGeneratedLanguageModel dictionaryAtPath:self.pathToFirstDynamicallyGeneratedDictionary acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelMandarin"] languageModelIsJSGF:FALSE]; // Start speech recognition if we aren't already listening.
    }
    
}

// An optional delegate method of OEEventsObserver which informs that the Pocketsphinx recognition loop has entered its actual loop.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx.
- (void) pocketsphinxRecognitionLoopDidStart {
    
    NSLog(@"Local callback: Pocketsphinx started."); // Log it.
}

// An optional delegate method of OEEventsObserver which informs that Pocketsphinx is now listening for speech.
- (void) pocketsphinxDidStartListening {
    
    NSLog(@"Local callback: Pocketsphinx is now listening."); // Log it.
    
    //开始监听回调，可以用来显示界面信息
}

// An optional delegate method of OEEventsObserver which informs that Pocketsphinx detected speech and is starting to process it.
- (void) pocketsphinxDidDetectSpeech {
//    NSLog(@"Local callback: Pocketsphinx has detected speech."); // Log it.

}

// An optional delegate method of OEEventsObserver which informs that Pocketsphinx detected a second of silence, indicating the end of an utterance.
// This was added because developers requested being able to time the recognition speed without the speech time. The processing time is the time between
// this method being called and the hypothesis being returned.
- (void) pocketsphinxDidDetectFinishedSpeech {
//    NSLog(@"Local callback: Pocketsphinx has detected a second of silence, concluding an utterance."); // Log it.

}


// An optional delegate method of OEEventsObserver which informs that Pocketsphinx has exited its recognition loop, most
// likely in response to the OEPocketsphinxController being told to stop listening via the stopListening method.
- (void) pocketsphinxDidStopListening {
    NSLog(@"Local callback: Pocketsphinx has stopped listening."); // Log it.

}

// An optional delegate method of OEEventsObserver which informs that Pocketsphinx is still in its listening loop but it is not
// Going to react to speech until listening is resumed.  This can happen as a result of Flite speech being
// in progress on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
// or as a result of the OEPocketsphinxController being told to suspend recognition via the suspendRecognition method.
- (void) pocketsphinxDidSuspendRecognition {
    NSLog(@"Local callback: Pocketsphinx has suspended recognition."); // Log it.

    
}

// An optional delegate method of OEEventsObserver which informs that Pocketsphinx is still in its listening loop and after recognition
// having been suspended it is now resuming.  This can happen as a result of Flite speech completing
// on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
// or as a result of the OEPocketsphinxController being told to resume recognition via the resumeRecognition method.
- (void) pocketsphinxDidResumeRecognition {
    NSLog(@"Local callback: Pocketsphinx has resumed recognition."); // Log it.

}

// An optional delegate method which informs that Pocketsphinx switched over to a new language model at the given URL in the course of
// recognition. This does not imply that it is a valid file or that recognition will be successful using the file.
- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
    NSLog(@"Local callback: Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

// An optional delegate method of OEEventsObserver which informs that Flite is speaking, most likely to be useful if debugging a
// complex interaction between sound classes. You don't have to do anything yourself in order to prevent Pocketsphinx from listening to Flite talk and trying to recognize the speech.
- (void) fliteDidStartSpeaking {
    NSLog(@"Local callback: Flite has started speaking"); // Log it.

}

// An optional delegate method of OEEventsObserver which informs that Flite is finished speaking, most likely to be useful if debugging a
// complex interaction between sound classes.
- (void) fliteDidFinishSpeaking {
    NSLog(@"Local callback: Flite has finished speaking"); // Log it.

}

- (void) pocketSphinxContinuousSetupDidFailWithReason:(NSString *)reasonForFailure { // This can let you know that something went wrong with the recognition loop startup. Turn on [OELogging startOpenEarsLogging] to learn why.
    NSLog(@"Local callback: Setting up the continuous recognition loop has failed for the reason %@, please turn on [OELogging startOpenEarsLogging] to learn more.", reasonForFailure); // Log it.

}

- (void) pocketSphinxContinuousTeardownDidFailWithReason:(NSString *)reasonForFailure { // This can let you know that something went wrong with the recognition loop startup. Turn on [OELogging startOpenEarsLogging] to learn why.
    NSLog(@"Local callback: Tearing down the continuous recognition loop has failed for the reason %@, please turn on [OELogging startOpenEarsLogging] to learn more.", reasonForFailure); // Log it.

}

- (void) testRecognitionCompleted { // A test file which was submitted for direct recognition via the audio driver is done.
    NSLog(@"Local callback: A test file which was submitted for direct recognition via the audio driver is done."); // Log it.
    NSError *error = nil;
    if([OEPocketsphinxController sharedInstance].isListening) { // If we're listening, stop listening.
        error = [[OEPocketsphinxController sharedInstance] stopListening];
        if(error) NSLog(@"Error while stopping listening in testRecognitionCompleted: %@", error);
    }
    
}
/** Pocketsphinx couldn't start because it has no mic permissions (will only be returned on iOS7 or later).*/
- (void) pocketsphinxFailedNoMicPermissions {
    NSLog(@"Local callback: The user has never set mic permissions or denied permission to this app's mic, so listening will not start.");

}

/** The user prompt to get mic permissions, or a check of the mic permissions, has completed with a TRUE or a FALSE result  (will only be returned on iOS7 or later).*/
- (void) micPermissionCheckCompleted:(BOOL)result {
    if(result) {
        self.restartAttemptsDueToPermissionRequests++;
        if(self.restartAttemptsDueToPermissionRequests == 1 && self.startupFailedDueToLackOfPermissions) { // If we get here because there was an attempt to start which failed due to lack of permissions, and now permissions have been requested and they returned true, we restart exactly once with the new permissions.
            NSError *error = nil;
            if([OEPocketsphinxController sharedInstance].isListening){
                error = [[OEPocketsphinxController sharedInstance] stopListening]; // Stop listening if we are listening.
                if(error) NSLog(@"Error while stopping listening in micPermissionCheckCompleted: %@", error);
            }
            if(!error && ![OEPocketsphinxController sharedInstance].isListening) { // If there was no error and we aren't listening, start listening.
                [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:self.pathToFirstDynamicallyGeneratedLanguageModel dictionaryAtPath:self.pathToFirstDynamicallyGeneratedDictionary acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelMandarin"] languageModelIsJSGF:FALSE]; // Start speech recognition.
                self.startupFailedDueToLackOfPermissions = FALSE;
            }
        }
    }
}


#pragma mark -
#pragma mark UI

- (void)setDevice:(Device *)device
{
    _device = device;
    
    [_control setType:device.type];
    [_delaies setDelay:_device.delay];
    [_navigateBar setCaptureText:device.name];
    
    
    if(device.type == 2)
    {
        _modes.hidden = YES;
        _segments.hidden = NO;
        [_segments setSegment:device.segment];
    } else {
        _modes.hidden = NO;
        _segments.hidden = YES;
    }
}

- (void)setBLENetwork:(BLENetworkControl*)ble
{
    _ble = ble;
    
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if( apd && apd.BLENetworkControl)
    {
        [_control setSwitch:[apd.BLENetworkControl getStatus]];
    }
}

- (void)clickReturnButton :(id)sender
{
    NSLog(@"返回  ");

}

- (void) showAlterClose
{
    if(!_closed)
    {
        _closed = true;

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"stringMessage", nil) message:NSLocalizedString(@"connectFailMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CancelButton",nil) otherButtonTitles:NSLocalizedString(@"OKButton",nil) , nil];
        
        [alert show];
    }
}

-(void)dismissLightDevice:(NSNumber *)_light
{
    if(_ble && _ble.cbConnected)
    {
        if(self.delegate)
            [self.delegate changeLight:_light.floatValue];
    } else {
        [self showAlterClose];
    }
}

-(void)dismissDelayDevice:(NSNumber *)_delay
{
    if(_ble && _ble.cbConnected)
    {
        if(self.delegate)
//            [self.delegate changeDelay:1];
            [self.delegate changeDelay:_delay.intValue];
    } else {
        [self showAlterClose];
    }
}

-(void)dismissColorDevice:(NSNumber *)_color
{
    if(_ble && _ble.cbConnected)
    {
        if(self.delegate)
            [self.delegate changeColor:_color.floatValue];
    } else {
        [self showAlterClose];
    }
}

- (void)SelectDelay:(int)delay
{
    if([_control getSwitch] == NO)
        return;
    
    
    NSNumber *_delay= [NSNumber numberWithInt:delay];
    if(!_ble || !_ble.cbConnected)
    {
        AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [apd.BLENetworkControl ConnectedBLEPrepharal:true];
        
        
        [self performSelector:@selector(dismissDelayDevice:) withObject:_delay afterDelay:1];
    }else
        [self dismissDelayDevice:_delay];

    _device.delay = delay;
}

-(void) changeLight:(float) value
{
    if([_control getSwitch] == NO)
        return;
    
    
    NSNumber *_light= [NSNumber numberWithFloat:(float)value];
    if(!_ble || !_ble.cbConnected)
    {
        AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [apd.BLENetworkControl ConnectedBLEPrepharal:true];
        
        
        [self performSelector:@selector(dismissLightDevice:) withObject:_light afterDelay:1];
    }else
        [self dismissLightDevice:_light];
    
//    NSLog(@"change light %f",value);
}

-(void) changeSpeak
{
    //如果语音启动，关闭语音否则就启动
    if([OEPocketsphinxController sharedInstance].isListening){
        [self stopListening];
        

        [_control setMicing:FALSE];
    } else {
        [self initOP];
    
        [self startListening];
        [_control setMicing:TRUE];
        
    }
    
}


-(void) changeColor:(float) value
{
    if([_control getSwitch] == NO)
        return;
    
    
    NSNumber *_color= [NSNumber numberWithFloat:(float)value];
    if(!_ble || !_ble.cbConnected)
    {
        AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [apd.BLENetworkControl ConnectedBLEPrepharal:true];
        
        
        [self performSelector:@selector(dismissColorDevice:) withObject:_color afterDelay:1];
    }else
        [self dismissColorDevice:_color];
}




-(void)dismissOpenDevice:(NSNumber *)_open
{
    if(_ble && _ble.cbConnected)
    {
        [_modes clearAllSelectMode];
        [_segments clearAllSelectSeg];
        
        if(_open == false){
            [_control setLightValue:1.0];
            [_delaies setDelay:4];
        }
        else
            [_control setLightValue:0.01];
        
        if(self.delegate){
            //如果是关闭，那么久需要保存当前操作模式，如果是打开，就需要获取一次模块状态
            if(_open.intValue == 0)
            {
                [self.delegate readStatus];
            }
            
            [self.delegate changeSwitch:_open.intValue];
        }
   
    } else {
        //蓝牙不通,显示 错误信息
        [self showAlterClose];
    }
}


-(void) changeOpen:(BOOL) open{
    NSNumber *_switch= [NSNumber numberWithInt:(int)open];
    
    
    if(!_ble || !_ble.cbConnected)
    {
        AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [apd.BLENetworkControl ConnectedBLEPrepharal:true];
        
        [self performSelector:@selector(dismissOpenDevice:) withObject:_switch afterDelay:1];
    } else
        [self dismissOpenDevice:_switch];
    
}


-(void)dismissModeDevice:(NSNumber *)_mode
{
    NSLog(@"wait 5 min  to connected.");
    
    if(_ble && _ble.cbConnected)
    {
        if(self.delegate)
        {
            switch (_mode.intValue) {
                case 0:
                    [self.delegate changeLight:0.80];
                    [_control setLightValue:0.80];
                    break;
                case 1:
                    [self.delegate changeLight:0.70];
                    [_control setLightValue:0.70];
                    break;
                case 2:   //呼吸灯
                    [self.delegate changeMode:_mode.intValue];
                    break;
                case 3:
                    [self.delegate changeLight:0.20];
                    [_control setLightValue:0.20];
                    break;
                case 4:
                    [self.delegate changeLight:2.0];
                    [_control setLightValue:0.02];
                    
                    break;
                    
                default:
                    break;
            }
        }

        NSLog(@"switch open");
    } else {
        [self showAlterClose];
    }
}

//切换模式窗口
-(void)selectMode:(int) mode
{
    NSNumber *_mode= [NSNumber numberWithInt:(int)mode];
    if(!_ble || !_ble.cbConnected)
    {
        AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [apd.BLENetworkControl ConnectedBLEPrepharal:true];
        
        [self performSelector:@selector(dismissModeDevice:) withObject:_mode afterDelay:1];
    }
    else
        [self dismissModeDevice:_mode];
}

//返回主菜单界面
- (void) leftButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate  retuenMainView];
}

//5S后判断是否写入成功
-(void)querySaveOKAction:(id)obj
{    
    //    延迟5秒
    [NSThread sleepForTimeInterval:3.0f];
   
    if(!_SaveOK)
    {
        //弹出保存失败对话框
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"stringMessage", nil)  message:NSLocalizedString(@"saveFailMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CancelButton", nil)  otherButtonTitles:NSLocalizedString(@"OKButton", nil) , nil];
        alert.tag = 88;
        [alert show];
    }
    
};

//保存按钮
- (void) rightButtonClick
{
//    NSLog(@"rightButtonClick    ssss");
    
    //保存数据，这个时候启动一个监听线程，等待返回数据，如果5S没有返回数据，就要提示保存失败！！！！！
    _SaveOK = NO;
    
//    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
//        [self querySaveOKAction:@"query save Block Operation"];
//    }];
//    
//    [_ResultcheckQuenue addOperation:op];

    
    //发送保存数b据到设备中
    if(!_segments.hidden)
        [self saveSetting:(_device.type+1) light:[_control getLight] color:[_control getColor] segment:[_segments getSegment]];
    else
        [self saveSetting:(_device.type+1) light:[_control getLight] color:[_control getColor] segment:[_modes getMode]];

    
    
    XYLoadingView *loadingView = XYShowLoading(NSLocalizedString(@"wait2minSaveMessage", nil));
    [loadingView performSelector:@selector(dismiss) withObject:nil afterDelay:2];
    
    //等待1秒时间打开控制界面
    [self performSelector:@selector(dismissAlertSaveMessage) withObject:nil afterDelay:2];

    
}
-(void)dismissAlertSaveMessage
{
    
    NSLog(@"dismissAlertSaveMessage");
    if(_SaveOK)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"stringMessage", nil)  message:NSLocalizedString(@"saveOKMessage", nil) delegate:self cancelButtonTitle:nil  otherButtonTitles:NSLocalizedString(@"OKButton", nil) , nil];
        alert.tag = 88;
        [alert show];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"stringMessage", nil)  message:NSLocalizedString(@"saveFailMessage", nil) delegate:self cancelButtonTitle:nil  otherButtonTitles:NSLocalizedString(@"OKButton", nil) , nil];
        alert.tag = 88;
        [alert show];
    }
}

-(void)dismiss
{
    [[XYAlertViewManager sharedAlertViewManager] dismiss:self];
}



- (void) editTitle:(NSString *)title
{
    
    NSLog(@"Change lamp name:   %@",title);
    
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(apd)
    {
        //修改配置
//        apd.config.
    }
    
    
}

-(void)selectViewClick
{
    if( _device.type == 2)
    {
        _segments.hidden = NO;
        _modes.hidden = YES;
        _delaies.hidden = YES;
    } else {
        _segments.hidden = YES;
        _modes.hidden = NO;
        _delaies.hidden = YES;
    }
}

-(void)delayViewClick
{
    _modes.hidden = YES;
    _delaies.hidden = NO;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 88)
    {
        //
     
        return;
    }
    
    if(buttonIndex == 1)
        [self leftButtonClick];

}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    [self leftButtonClick];
}

- (void)setCapture:(NSString*)capture
{
    [_navigateBar setCaptureText:capture];
}


-(void)dismissSegmentDevice:(NSNumber *)_seg
{
    if(_ble && _ble.cbConnected)
    {
        if(self.delegate)
        {
            switch (_seg.intValue) {
                case 0://A
                case 1://B
                case 2://C
                case 3://D
                case 4://E
                case 5:  //全亮
                    [self.delegate changeMode:_seg.intValue];
                    break;
                case 6: //小夜灯
                    [self.delegate changeLight:2.0];
                    [_control setLightValue:2.0];
                    break;
                default:
                    break;
            }
        }
        
    } else {
        [self showAlterClose];
    }
}



-(void)dismissChangeSegementDevice:(SegmentData *)_data
{
    if(_ble && _ble.cbConnected)
    {
        //全亮
        
        //小夜灯
        
        //分段选择
        
        if(self.delegate){
                [self.delegate changeSegment:_data.light oneseg:_data.one twoseg:_data.two threeseh:_data.three fourseg:_data.four fiveseg:_data.five ];
        }

        
    } else {
        [self showAlterClose];
    }
}

//发送数据到模块
-(void)selectSegment:(int) seg
{
    
    if([_control getSwitch] == NO)
        return;
    
    //获取亮度信息
    SegmentData *data = [[SegmentData alloc] init ];
    
    data.light = [_control getLight];
    data.one = (seg & SEGMENT_ONE_FLAG ) ? 1 : 0;
    data.two = (seg & SEGMENT_TWO_FLAG ) ? 1 : 0;
    data.three = (seg & SEGMENT_THREE_FLAG ) ? 1 : 0;
    data.four = (seg & SEGMENT_FOUR_FLAG ) ? 1 : 0;
    data.five =  (seg >> 4) & 0x01;
    
    if(seg == SEGMENT_ALL_FLAG )
    {
        switch (_device.segment) {
            case 0:
            case 1:
                data.one = 1;
                data.two = 0;
                data.three = 0;
                data.four = 0;
                data.five = 0;
                break;
            case 2:
                data.one = 1;
                data.two = 1;
                data.three = 0;
                data.four = 0;
                data.five = 0;

                break;
            case 3:
                data.one = 1;
                data.two = 1;
                data.three = 1;
                data.four = 0;
                data.five = 0;

                break;
            case 4:
                data.one = 1;
                data.two = 1;
                data.three = 1;
                data.four = 1;
                data.five = 0;
                break;
            case 5:
                data.one = 1;
                data.two = 1;
                data.three = 1;
                data.four = 1;
                data.five = 1;

                break;
                
            default:
                break;
        }
        
        data.light = 255;  //打到最大亮度
        [self.delegate changeLight:1.0];
        [_control setLightValue:1.0];

    }
    
    if(seg == SEGMENT_NIGHT_FLAG)
    {
        data.one = 1;
        data.two = 0;
        data.three = 0;
        data.four = 0;
        data.five = 0;
        data.light = 2;
  
        //先设置最小亮度
        [self.delegate changeLight:2.0];
        [_control setLightValue:0.02];

        //再设置单路
    }


    if(!_ble || !_ble.cbConnected)
    {
        AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [apd.BLENetworkControl ConnectedBLEPrepharal:true];
        
        [self performSelector:@selector(dismissChangeSegementDevice:) withObject:data afterDelay:1];
    }
    else {
        [self dismissChangeSegementDevice:data];
    }
    
}

//语音控制的全亮
-(void)speakHighLight
{
    
    if(_segments.hidden)
    {
        [_modes controlMode:0];
    } else
    {
        SegmentData *data = [[SegmentData alloc] init ];
        
        switch (_device.segment) {
            case 0:
            case 1:
                data.one = 1;
                data.two = 0;
                data.three = 0;
                data.four = 0;
                data.five = 0;
                break;
            case 2:
                data.one = 1;
                data.two = 1;
                data.three = 0;
                data.four = 0;
                data.five = 0;
                
                break;
            case 3:
                data.one = 1;
                data.two = 1;
                data.three = 1;
                data.four = 0;
                data.five = 0;
                
                break;
            case 4:
                data.one = 1;
                data.two = 1;
                data.three = 1;
                data.four = 1;
                data.five = 0;
                break;
            case 5:
                data.one = 1;
                data.two = 1;
                data.three = 1;
                data.four = 1;
                data.five = 1;
                
                break;
                
            default:
                break;
        }
        
        data.light = 255;  //打到最大亮度
        
        [_segments controlSeg:98];
        [self.delegate changeLight:1.0];
        [_control setLightValue:1.0];
        
        
        
        if(!_ble || !_ble.cbConnected)
        {
            AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            [apd.BLENetworkControl ConnectedBLEPrepharal:true];
            
            [self performSelector:@selector(dismissChangeSegementDevice:) withObject:data afterDelay:1];
        }
        else {
            [self dismissChangeSegementDevice:data];
        }
        
        
    }
}

//语音控制的小夜灯
-(void)speakNight
{
    
    if(_segments.hidden)
    {
        [_modes controlMode:4];
    } else
    {
        SegmentData *data = [[SegmentData alloc] init ];
        
        data.light = [_control getLight];
        
        data.one = 1;
        data.two = 0;
        data.three = 0;
        data.four = 0;
        data.five = 0;
        data.light = 2;
        
        //先设置最小亮度
        [self.delegate changeLight:2.0];
        [_control setLightValue:0.02];
        [_segments controlSeg:99];
        
        
        if(!_ble || !_ble.cbConnected)
        {
            AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            [apd.BLENetworkControl ConnectedBLEPrepharal:true];
            
            [self performSelector:@selector(dismissChangeSegementDevice:) withObject:data afterDelay:1];
        }
        else {
            [self dismissChangeSegementDevice:data];
        }
    
        
    }

}

-(void)dismissSettingDevice:(SettingData *)_data
{
    if(_ble && _ble.cbConnected)
    {
        if(self.delegate)
            [self.delegate saveSetting:_data.type light:_data.light color:_data.color segment:_data.seg ];
    } else {
        [self showAlterClose];
    }
}

-(void) saveSetting:(int) type light:(float)light color:(float)color segment:(int) seg
{
//    if([_control getSwitch] == NO)
//        return;
    
    
    NSLog(@"light  %f",light);
    
    
    SettingData *data = [[SettingData alloc] initWithName:type light:(int)(light*255) color:(int)(color *255)/100 segment:seg];
    
    if(data.color>255)
        data.color /= 100;
    
    if(!_ble || !_ble.cbConnected)
    {
        AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [apd.BLENetworkControl ConnectedBLEPrepharal:true];
        
        [self performSelector:@selector(dismissSettingDevice:) withObject:data afterDelay:1];
    }else
        [self dismissSettingDevice:data];
    
}

//状态回调，当状态改变的时候，回调这个函数显示修正界面
- (void)setStatus:(PResultData) status
{
    [_control setSwitch:status->Switch - 1];
    
    if(status->Switch -1)
    {
        return ;
    }
    
    float color = (float) status->color;
    float light = (float) status->light;
    
    NSLog(@"%d,%f",status->light,light);
    [_control setColorValue:(float)(color/255.0f) * 100];
    [_control setLightValue:(float)(light/255.0f)];
    
    if(!_segments.hidden)
    {
#ifdef _DEBUG_LOG
        NSLog(@"segment %x",status->segtype);
#endif
        if((status->segtype & SEGMENT_ONE_FLAG))
            [_segments controlSeg:0];
        if((status->segtype & SEGMENT_TWO_FLAG))
            [_segments controlSeg:1];
        if((status->segtype & SEGMENT_THREE_FLAG))
            [_segments controlSeg:2];
        if((status->segtype & SEGMENT_FOUR_FLAG))
            [_segments controlSeg:3];
        if((status->segtype & SEGMENT_FIVE_FLAG))
            [_segments controlSeg:4];
    } else {
        
//#ifdef _DEBUG_LOG
        NSLog(@"mode %x",status->segtype);
//#endif
        if((status->segtype & SEGMENT_ONE_FLAG))
            [_modes checkMode:0];
        if((status->segtype & SEGMENT_TWO_FLAG))
            [_modes checkMode:1];
        if((status->segtype & SEGMENT_THREE_FLAG))
            [_modes checkMode:2];
        if((status->segtype & SEGMENT_FOUR_FLAG))
            [_modes checkMode:3];
        if((status->segtype & SEGMENT_FIVE_FLAG))
            [_modes checkMode:4];
        
    }
    
    
    
}

- (void)saveOK
{
    NSLog(@"saveOK  === YES ");
    _SaveOK = YES;
    
    
    //弹出保存成功对话框
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"stringMessage", nil)  message:NSLocalizedString(@"saveOKMessage", nil) delegate:self cancelButtonTitle:nil  otherButtonTitles:NSLocalizedString(@"OKButton", nil) , nil];
//    alert.tag = 88;
//    [alert show];

}

//系统通知意见断线了,弹出对话框，返回主界面，等待扫描出现
- (void)disconnectBLE:(NSUUID*)uuid
{
//    NSLog(@"系统通知 %@已经断线了  ",uuid);

    if([self isCurrentViewControllerVisible])
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"stringMessage", nil) message:NSLocalizedString(@"connectFailMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CancelButton",nil) otherButtonTitles:NSLocalizedString(@"OKButton",nil) , nil];
//    
//        [alert show];
    }

    
    //[self leftButtonClick];
}


-(BOOL)isCurrentViewControllerVisible
{
    return (self.isViewLoaded && self.view.window);
}


@end
