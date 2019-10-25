//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <flutter_native_web/FlutterNativeWebPlugin.h>
#import <flutter_webview_plugin/FlutterWebviewPlugin.h>
#import <image_gallery_saver/ImageGallerySaverPlugin.h>
#import <path_provider/PathProviderPlugin.h>
#import <screen/ScreenPlugin.h>
#import <sqflite/SqflitePlugin.h>
#import <url_launcher/UrlLauncherPlugin.h>
#import <video_player/VideoPlayerPlugin.h>
#import <webview_flutter/WebViewFlutterPlugin.h>
#import <wifi/WifiPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterNativeWebPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterNativeWebPlugin"]];
  [FlutterWebviewPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterWebviewPlugin"]];
  [ImageGallerySaverPlugin registerWithRegistrar:[registry registrarForPlugin:@"ImageGallerySaverPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [ScreenPlugin registerWithRegistrar:[registry registrarForPlugin:@"ScreenPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
  [FLTUrlLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTUrlLauncherPlugin"]];
  [FLTVideoPlayerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTVideoPlayerPlugin"]];
  [FLTWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTWebViewFlutterPlugin"]];
  [WifiPlugin registerWithRegistrar:[registry registrarForPlugin:@"WifiPlugin"]];
}

@end
