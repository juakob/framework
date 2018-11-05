package com.imageAtlas ;
import com.gEngine.tempStructures.Bitmap;
import com.helpers.Rectangle;
	
	/**
	 * ...
	 * @author joaquin
	 */
	 class ImageTree 
	{
		private var firstNode:Node;
		private var mImageSeparation:Float;

		public function new(width:Float,height:Float,aImageSeparation:Float)
		{
			firstNode = new Node();
			firstNode.rect = new Rectangle(0, 0, width, height);
			mImageSeparation = aImageSeparation*2;
		}
		public function insertImage(bitmap:Bitmap):Rectangle
		{
			var node:Node = Insert(bitmap, firstNode);
			if (node!=null)
			{
				var rec:Rectangle = node.rect.clone();
				rec.x += mImageSeparation * 0.5;
				rec.y += mImageSeparation * 0.5;
				return rec;
			}else {
				return null;
			}
		}
		private function Insert(bitmap:Bitmap,node:Node):Node
		{
			//if we're not a leaf then
			if (node.Right!=null||node.Left!=null)
			{
				var newNode:Node = Insert(bitmap, node.Left);
				if (newNode != null) return newNode;
				
				return Insert(bitmap, node.Right);
			}else {
				if (node.bitmap!=null) return null;
				
				//try to fit
				if (!rectangleFitIn(node.rect, bitmap)) return null;
				var normal:Bool = rectangleFitIn(node.rect, bitmap);
				
				var rotated:Bool = rectangleFitIn(node.rect, bitmap);
				
				if (!normal && !rotated)
				{
					return null;
				}else {
					if (rotated && !normal)
					{
						
					}
				}
				
				
				if (rectangleFitPerfect(node.rect, bitmap)) 
				{ 
					node.bitmap = bitmap; 
					return node ;
				};
				
				var rc:Rectangle = node.rect;
				node.Left = new Node();
				node.Right = new Node();
				
				var dw:Float = rc.width - (bitmap.width+mImageSeparation);
				var dh:Float = rc.height - (bitmap.height+mImageSeparation);

				if (dw < dh)
				{
					//horizontal
					node.Left.rect = new Rectangle(rc.x, rc.y ,rc.width, bitmap.height+mImageSeparation);
					node.Right.rect = new Rectangle(rc.x, rc.y+bitmap.height+mImageSeparation, rc.width, rc.height-(bitmap.height+mImageSeparation));
				}else {
					//vertical
					node.Left.rect = new Rectangle(rc.x, rc.y, bitmap.width+mImageSeparation, rc.height);
					node.Right.rect = new Rectangle(rc.x+bitmap.width+mImageSeparation, rc.y, rc.width-(bitmap.width+mImageSeparation), rc.height);
				}
				return Insert(bitmap, node.Left);
			}
			//cant fit
			return null;
		}
		
		private function rectangleFitPerfect(rect:Rectangle, bitmap:Bitmap):Bool
		{
			return rect.width == (bitmap.width+mImageSeparation) &&
					rect.height == (bitmap.height+mImageSeparation);
		}
		
		private function rectangleFitIn(rect:Rectangle, bitmap:Bitmap):Bool
		{
			return rect.width >= (bitmap.width+mImageSeparation) &&
					rect.height >= (bitmap.height+mImageSeparation);
		}
		
	}

