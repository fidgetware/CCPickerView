#import "Scale9Sprite.h"

@implementation Scale9Sprite

@synthesize opacity, color;

enum positions {
	pCentre = 0,
	pTop,
	pLeft,
	pRight,
	pBottom,
	pTopRight,
	pTopLeft,
	pBottomRight,
	pBottomLeft
};	

CGSize baseSize;
CGRect resizableRegion;

-(id) initWithFile:(NSString*)file centreRegion:(CGRect)centreRegion {
	
	if( (self=[super init]) ) {
		
		scale9Image = [[CCSpriteBatchNode alloc] initWithFile:file capacity:9];
		CGSize imageSize = scale9Image.texture.contentSize;
		CCLOG(@">>>>>>>>> Image size %0.2f x %0.2f",imageSize.width,imageSize.height);
		//Set up centre sprite
		centre = [[CCSprite alloc] initWithBatchNode:scale9Image rect:centreRegion];
		[scale9Image addChild:centre z:0 tag:pCentre];
		
		//top
		top = [[CCSprite alloc]
			   initWithBatchNode:scale9Image
			   rect:CGRectMake(centreRegion.origin.x,
							   0,
							   centreRegion.size.width,
							   centreRegion.origin.y)
			   ];
		
		[scale9Image addChild:top z:1 tag:pTop];
		
		//bottom
		bottom = [[CCSprite alloc]
				  initWithBatchNode:scale9Image
				  rect:CGRectMake(centreRegion.origin.x,
								  centreRegion.origin.y + centreRegion.size.height,
								  centreRegion.size.width,
								  imageSize.height - (centreRegion.origin.y + centreRegion.size.height))
				  ];
		
		[scale9Image addChild:bottom z:1 tag:pBottom];
		
		//left
		left = [[CCSprite alloc]
				initWithBatchNode:scale9Image
				rect:CGRectMake(0,
								centreRegion.origin.y,
								centreRegion.origin.x,
								centreRegion.size.height)
				];
		
		[scale9Image addChild:left z:1 tag:pLeft];
		
		//right
		right = [[CCSprite alloc]
				 initWithBatchNode:scale9Image
				 rect:CGRectMake(centreRegion.origin.x + centreRegion.size.width,
								 centreRegion.origin.y,
								 imageSize.width - (centreRegion.origin.x + centreRegion.size.width),
								 centreRegion.size.height)
				 ];
		
		[scale9Image addChild:right z:1 tag:pRight];
		
		//top left
		topLeft = [[CCSprite alloc]
				   initWithBatchNode:scale9Image
				   rect:CGRectMake(0,
								   0,
								   centreRegion.origin.x,
								   centreRegion.origin.y)
				   ];
		
		[scale9Image addChild:topLeft z:2 tag:pTopLeft];
		
		//top right
		topRight = [[CCSprite alloc]
					initWithBatchNode:scale9Image
					rect:CGRectMake(centreRegion.origin.x + centreRegion.size.width,
									0,
									imageSize.width - (centreRegion.origin.x + centreRegion.size.width),
									centreRegion.origin.y)
					];
		
		[scale9Image addChild:topRight z:2 tag:pTopRight];
		
		//bottom left
		bottomLeft = [[CCSprite alloc]
					  initWithBatchNode:scale9Image
					  rect:CGRectMake(0,
									  centreRegion.origin.y + centreRegion.size.height,
									  centreRegion.origin.x,
									  imageSize.height - (centreRegion.origin.y + centreRegion.size.height))
					  ];
		
		[scale9Image addChild:bottomLeft z:2 tag:pBottomLeft];
		
		//bottom right
		bottomRight = [[CCSprite alloc]
					   initWithBatchNode:scale9Image
					   rect:CGRectMake(centreRegion.origin.x + centreRegion.size.width,
									   centreRegion.origin.y + centreRegion.size.height,
									   imageSize.width - (centreRegion.origin.x + centreRegion.size.width),
									   imageSize.height - (centreRegion.origin.y + centreRegion.size.height))
					   ];
		
		[scale9Image addChild:bottomRight z:2 tag:pBottomRight];
		
		baseSize = imageSize;
		resizableRegion = centreRegion;
		[self setContentSize:imageSize];
		[self addChild:scale9Image];
		[self setAnchorPoint:CGPointMake(0.5f,0.5f)];
	}
	return self;
}	

-(void) dealloc
{
	
	[topLeft release];
	[top release];
	[topRight release];
	[left release];
	[centre release];
	[right release];
	[bottomLeft release];
	[bottom release];
	[bottomRight release];
	[scale9Image release];
	[super dealloc];
}	

-(void) setPosition: (CGPoint)newPosition
{
	CCLOG(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! scale9 set position %0.2f %0.2f",newPosition.x, newPosition.y);
	[super setPosition:newPosition];
	
}

-(void) setAnchorPoint:(CGPoint)newAnchorPoint
{
	CCLOG(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! scale9 set anchor point %0.2f %0.2f",newAnchorPoint.x, newAnchorPoint.y);
	[super setAnchorPoint:newAnchorPoint];
	
}	

-(void) setContentSize:(CGSize)size
{
	
	[super setContentSize:size];
	//[self setRelativeAnchorPoint:NO];
//	[self setAnchorPoint:CGPointMake(0.5f,0.5f)];
	//[scale9Image setAnchorPoint:CGPointMake(0.5f,0.5f)];
	
	CCLOG(@"scale9 set content size %0.2f %0.2f",size.width,size.height);
	CCLOG(@"leftCap %0.2f rightCap %0.2f",topLeft.contentSize.width,topRight.contentSize.width);
	
	float sizableWidth = size.width - topLeft.contentSize.width - topRight.contentSize.width;
	float sizableHeight = size.height - topLeft.contentSize.height - bottomRight.contentSize.height;
	float horizontalScale = sizableWidth/centre.contentSize.width;
	float verticalScale = sizableHeight/centre.contentSize.height;
	centre.scaleX = horizontalScale;
	centre.scaleY = verticalScale;
	float rescaledWidth = centre.contentSize.width * horizontalScale;
	float rescaledHeight = centre.contentSize.height * verticalScale;
	
    float despx = size.width*0.5f+topLeft.contentSize.width/2-topRight.contentSize.width/2;
	float despy = size.height*0.5f-topLeft.contentSize.height/2+bottomLeft.contentSize.height/2;
	
	//Position corners
	[topLeft setPosition:CGPointMake(-rescaledWidth/2 - topLeft.contentSize.width/2 +despx, rescaledHeight/2 + topLeft.contentSize.height*0.5 +despy) ];
	[topRight setPosition:CGPointMake(rescaledWidth/2 + topRight.contentSize.width/2 +despx, rescaledHeight/2 + topRight.contentSize.height*0.5 +despy)];
	[bottomLeft setPosition:CGPointMake(-rescaledWidth/2 - bottomLeft.contentSize.width/2 +despx, -rescaledHeight/2 - bottomLeft.contentSize.height*0.5 +despy)];
	[bottomRight setPosition:CGPointMake(rescaledWidth/2 + bottomRight.contentSize.width/2 +despx, -rescaledHeight/2 + -bottomRight.contentSize.height*0.5 +despy)];
	top.scaleX = horizontalScale;
	[top setPosition:CGPointMake(0+despx,rescaledHeight/2 + topLeft.contentSize.height*0.5 +despy)];
	bottom.scaleX = horizontalScale;
	[bottom setPosition:CGPointMake(0+despx,-rescaledHeight/2 - bottomLeft.contentSize.height*0.5 +despy)];
	left.scaleY = verticalScale;
	[left setPosition:CGPointMake(-rescaledWidth/2 - topLeft.contentSize.width/2 +despx, 0+despy)];
	right.scaleY = verticalScale;
	[right setPosition:CGPointMake(rescaledWidth/2 + topRight.contentSize.width/2 +despx, 0+despy)];
	[centre setPosition:CGPointMake(despx, despy)];
	
	CCLOG(@"Scale9 setContentSize %02.f x %02.f <%0.2f x %0.2f>",sizableWidth,sizableHeight,horizontalScale,verticalScale);
}

-(void) draw {
	[scale9Image draw];
}
@end