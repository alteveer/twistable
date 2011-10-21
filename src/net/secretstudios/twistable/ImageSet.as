package net.secretstudios.twisty {
	import br.com.stimuli.loading.BulkProgressEvent
	import flash.display.Bitmap
	import flash.display.Loader
	import flash.display.Sprite
	import flash.events.Event
	import flash.events.ProgressEvent
	import flash.events.MouseEvent
	import flash.events.TextEvent
	import flash.events.TimerEvent
	import flash.geom.Point
	import flash.net.URLRequest
	import flash.text.StaticText
	import flash.text.TextField
	import flash.text.TextFieldAutoSize
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import br.com.stimuli.loading.BulkLoader
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class ImageSet extends Sprite {
		
		public const PROGRESS_BAR_WIDTH:Number = 400
		public const PROGRESS_BAR_HEIGHT:Number = 30
		public var _path:String
		public var _set_length:Number
		protected var _rotation:Number = 0
		protected var image_set:Object = new Object()
		private var loader:BulkLoader = new BulkLoader("image_loader")
		private var loaded_number:Number = 0
		private var progress_bar:Sprite
		private var stage_dimensions:Point
		private var flashy_count:Boolean = true
		private var faster_load_tick:Timer;
		private var load_text:TextField = new TextField()
		private var text_format:TextFormat = new TextFormat()
		//private var display_pane:Sprite = new Sprite()
				
		public function ImageSet(_stage_width:Number, 
								 _stage_height:Number, 
								 _path:String = "images/sample", 
								 _set_length:Number = 60,
								 _file_extension:String = "jpg") {
			this._path = _path
			this._set_length = _set_length;
			stage_dimensions = new Point(_stage_width, _stage_height)

			for (var i:Number = 0; i < this._set_length; i++) {
				loader.add(this._path + "/turn_around" + pad_number(i, 4) + "." + _file_extension, { id:"image" + i })
			}
			
			loader.addEventListener(BulkLoader.COMPLETE, images_loaded)
			loader.addEventListener(BulkLoader.PROGRESS, update_progress_bar)
			
			build_progress_bar()
			loader.start()			
		}
				
		protected function build_progress_bar():void {
			progress_bar = new Sprite()
			with(progress_bar.graphics) {
				beginFill(0xeeeeee)
				//lineStyle(1, 0x666666, 1, true)
				drawRect(0, 0, PROGRESS_BAR_WIDTH, PROGRESS_BAR_HEIGHT)
				endFill()
			}
			progress_bar.x = stage_dimensions.x/2 - progress_bar.width/2
			progress_bar.y = stage_dimensions.y/2 - progress_bar.height/2
			addChild(progress_bar)
			
			load_text.text = "Loading..."
			load_text.autoSize = "center"
			text_format.letterSpacing = 2
			text_format.font = "Georgia"
			text_format.size = 16
			load_text.setTextFormat(text_format)
			progress_bar.addChild(load_text)
			load_text.x = progress_bar.width/2 - load_text.width / 2
			
		}
		
		protected function update_progress_bar(e:BulkProgressEvent):void {
			//trace(e.loadingStatus())
			//load_text.text = String(Math.floor(e._weightPercent * 100))
			//load_text.text = String(e.weightPercent * 100) + "%"
			with(progress_bar.graphics) {
				beginFill(0x666666)
				lineStyle(0,0,0)
				drawRect(0, 0, e.weightPercent * PROGRESS_BAR_WIDTH, PROGRESS_BAR_HEIGHT)
				endFill()
			}
		}
		protected function images_loaded(e:BulkProgressEvent):void {
			trace(loaded_number)
			for (var i:Number = 0; i < _set_length; i++) {
				//trace(i)
				image_set["image"+i] = e.target.getBitmap("image"+i)
			}
			//trace(image_set["image0"].width +", " + image_set["image0"].height)

			this.dispatchEvent(new Event(Event.COMPLETE))
			removeChild(progress_bar)
			//addChild(display_pane)

			draw_image(0)
		}
		
		public function draw_image(image:Number, zoom:Number = .5):void {
			trace(image)
			with(graphics) {
				beginBitmapFill(image_set["image" + image].bitmapData)
				drawRect(0, 0, stage_dimensions.x, stage_dimensions.y)
				endFill()
			}
		}
				
		private function pad_number(num:Number, digits:int):String {
			var ret:String = num.toString()
			while (ret.length < digits)
				ret = "0" + ret
			return ret
		}
	}
	
}