/*
@author:		Ahmed Nuaman (ahmed@firestartermedia.com)
@date:			2009-03-23

Web Site Designed, Programmed and Maintained by FireStarter Media Limited, www.firestartermedia.com, hello@firestartermedia.com.
The content and images are copyright COMPANY. The design and code are copyright COMPANY and FireStarter Media Limited.
Copyright (c) FireStarter Media Limited. All rights reserved.
*/

import com.gskinner.utils.SWFBridgeAS2;

import com.tangozebra.utils.TZTrace;
import com.tangozebra.youtube.TZYouTubePlayer;
import com.tangozebra.youtube.TZYouTubePlayerEvent;

import mx.utils.Delegate;

class YouTubePlayerWrapper
{
	static var NAME:String										= 'YouTubePlayerWrapper';
	
	static var BRIDGE_NAME:String								= 'YouTubePlayerBridge';
	
	private var parent:MovieClip;
	private var player:TZYouTubePlayer;
	private var bridge:SWFBridgeAS2;
	private var bridgeName:String;
	
	public function YouTubePlayerWrapper(parent:MovieClip, bridgeName:String)
	{
		TZTrace.info( NAME + ' created' );
		
		this.bridgeName = ( bridgeName ? bridgeName : BRIDGE_NAME );
		
		Stage.scaleMode = 'noScale';
		Stage.align = 'TL';

		System.security.allowDomain( '*' );
		System.security.allowDomain( 'www.youtube.com' );  
		System.security.allowDomain( 'youtube.com' );  
		System.security.allowDomain( 's.ytimg.com' );  
		System.security.allowDomain( 'i.ytimg.com' );
		
		this.parent = parent;
		
		init();
	}
	
	private function init():Void
	{
		var playerHolder:MovieClip = parent.createEmptyMovieClip( 'playerHolder' + bridgeName, parent.getNextHighestDepth() );
		
		TZTrace.info( NAME + ' connecting to bridge ' + bridgeName );
		
		bridge = new SWFBridgeAS2( bridgeName, this );
		
		bridge.addEventListener( 'connect', this );

		player = new TZYouTubePlayer( playerHolder );
		
		player.addEventListener( TZYouTubePlayerEvent.READY,         		Delegate.create( this, sendEvent ) );
		player.addEventListener( TZYouTubePlayerEvent.PLAYER_ENDED,         Delegate.create( this, sendEvent ) );
		player.addEventListener( TZYouTubePlayerEvent.PLAYER_PLAYING,       Delegate.create( this, sendEvent ) );
		player.addEventListener( TZYouTubePlayerEvent.PLAYER_PAUSED,        Delegate.create( this, sendEvent ) );
		player.addEventListener( TZYouTubePlayerEvent.PLAYER_BUFFERING,     Delegate.create( this, sendEvent ) );
		player.addEventListener( TZYouTubePlayerEvent.PLAYER_QUEUED,        Delegate.create( this, sendEvent ) );
		player.addEventListener( TZYouTubePlayerEvent.PLAYER_NOT_STARTED,   Delegate.create( this, sendEvent ) );
	}
	
	private function sendEvent(e:TZYouTubePlayerEvent):Void
	{	
		bridge.send( 'sendEvent', e.type );
	}
	
	public function playVideo(videoId:String, playerWidth:Number, playerHeight:Number, autoPlay:Boolean, pars:String, chromeless:Boolean):Void
	{
		TZTrace.info( NAME + ' received videoId ' + videoId );
		
		player.autoPlay       = ( autoPlay !== false ? true : false );
		player.chromeless     = ( chromeless ? chromeless : false );
		player.pars           = ( pars ? pars : player.pars );
		player.playerWidth    = ( playerWidth ? playerWidth : player.playerWidth );
		player.playerHeight   = ( playerHeight ? playerHeight : player.playerHeight );

		player.init( videoId );
	}
	
	public function resizePlayer(width:Number, height:Number):Void
	{
		TZTrace.info( NAME + ' resizing video to: ' + width + ', ' + height );
		
		player.resizePlayer( width, height );
	}

	public function stopVideo():Void
	{
		TZTrace.info( NAME + ' stopping video' );
		
		player.stopVideo();
	}
	
	public function pauseVideo():Void
	{
		TZTrace.info( NAME + ' pausing video' );
		
		player.pauseVideo();
	}

	public function resumeVideo():Void
	{
		TZTrace.info( NAME + ' resuming video' );
		
		player.resumeVideo();
	}
}

/* End of file PlayerWrapper.as */
/* Location: ./PlayerWrapper.as */