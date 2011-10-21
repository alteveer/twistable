package net.secretstudios.twisty {
	
	import flash.display.Sprite
	import flash.events.Event
	import flash.events.MouseEvent
	import flash.text.TextField;
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class Main extends Sprite {
		private var previous_x:Number = 0
		private var current_image:Number = 0
		private const SPIN_SPEED:Number = 0.1
		public const DEFAULT_PATH:String = "images/sample"
		public const SET_LENGTH:Number = 60
		public const FILE_EXTENSION:String = "jpg"
		private var image_set:ImageSet
		public var image_path:String
		public var tf:TextField = new TextField()
		
		public function Main():void {
			if (stage) init()
			else addEventListener(Event.ADDED_TO_STAGE, init)
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init)
			// entry point
			
			tf.textColor = 0xff0000
			tf.autoSize = "left"
			stage.addChild(tf)				
	
			image_set = new ImageSet(
				stage.stageWidth, 
				stage.stageHeight, 
				loaderInfo.parameters.image_path || DEFAULT_PATH, 
				loaderInfo.parameters.set_length || SET_LENGTH, 
				loaderInfo.parameters.file_extension || FILE_EXTENSION
			)
			
			stage.addChild(image_set)
			
			image_set.addEventListener(Event.COMPLETE, image_set_loaded)
		}
		protected function image_set_loaded(e:Event):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, scrub)
		}
		
		protected function scrub(e:MouseEvent):void {
			if (e.buttonDown) {
				//every time the mouse moves find how far on X and add that to the spinner's rotation.
				//spinner.rotation += (mouseX - previous_x) * SPIN_SPEED
				//trace((mouseX - previous_x) * SPIN_SPEED)
				current_image += Math.round(((mouseX - previous_x) * SPIN_SPEED) % (image_set._set_length -1))
				if (current_image < 0) {
					current_image = image_set._set_length -1
				} 
				if (current_image > image_set._set_length -1) {
					current_image = 0
				}
				image_set.draw_image(current_image)
			
			}
			previous_x = mouseX
				
			
		}
	}
}