package jta.api;

import openfl.display.Sprite;
import jta.video.GlobalVideo;
import jta.video.VideoHandler;
import jta.video.WebmHandler;

/**
 * Class to initialize video playback.
 */
class VideoInitializer
{
	public static function setupVideo(container:Sprite, source:String):Void
	{
		#if web
		var str1:String = "HTML VIDEO";
		var vHandler = new VideoHandler();
		vHandler.init1();
		vHandler.video.name = str1;
		container.addChild(vHandler.video);
		vHandler.init2();
		GlobalVideo.setVid(vHandler);
		vHandler.source(source);
		#elseif desktop
		var str1:String = "WEBM VIDEO";
		var webmHandle = new WebmHandler();
		webmHandle.source(source);
		webmHandle.makePlayer();
		webmHandle.webm.name = str1;
		container.addChild(webmHandle.webm);
		GlobalVideo.setWebm(webmHandle);
		#end
	}
}
