//
//  GameScene.m
//  eyeCandy
//
//  Created by Robert Zimmelman on 11/10/14.
//  Copyright (c) 2014 Robert Zimmelman. All rights reserved.
//

int myButtonWidth = 30;
int myCounter = 0;
int myFiveSpriteLoops = 2;
int myMassMult = 1;
int myYOffset = 30;
float myRestitution = .9;
float myPhotoSpriteScale = .1;

//

int myColorSpriteDefaultSize = 15;
int myColorSpriteLoops = 1;
float myColorSpriteRestitution = 1.1;
int myNumberOfLoopsForSquares = 20;

int myShape = 0;


//
int myCircleSpriteSize = 10;
float myCircleSpriteScale = 0.1;
float myCircleSpriteRestitution = 0.9;
int myCircleSpriteLoops = 1;

#import "GameScene.h"



@implementation GameScene{
    CMMotionManager *myCoreMotionManager;
}
@synthesize mySpriteImage1, mySpriteImage2, mySpriteImage3, mySpriteImage4, mySpriteImage5;



//-(BOOL)canBecomeFirstResponder{
//    return YES;
//}


-(void)didMoveToView:(SKView *)view {
    //
    //
    //
    //
    myCoreMotionManager = [[CMMotionManager alloc] init];
    
//        [myCoreMotionManager ]
        [myCoreMotionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            CGVector gravityVector = CGVectorMake(motion.gravity.x, motion.gravity.y);
            gravityVector.dx *= 9.81;
            gravityVector.dy *= 9.81;
            self.physicsWorld.gravity = gravityVector;
        }];
    
    // rz set the physics world to go 1/2 speed
    //
    //
    //
    //[self.physicsWorld setSpeed:0.25];
    
    UISwipeGestureRecognizer *myUpSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myUpSwipeAction)];
    [myUpSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:myUpSwipeGestureRecognizer];
    
    
    UISwipeGestureRecognizer *myDownSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myDownSwipeAction)];
    [myDownSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:myDownSwipeGestureRecognizer];
    
    
    
    
    UISwipeGestureRecognizer *myLeftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myLeftSwipeAction)];
    [myLeftSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:myLeftSwipeGestureRecognizer];
    
    
    UISwipeGestureRecognizer *myRightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myRightSwipeAction)];
    [myRightSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:myRightSwipeGestureRecognizer];
    
    //
    // rz single tap recognizer
    UITapGestureRecognizer *singleFingerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    [singleFingerTapGesture setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleFingerTapGesture];
    //
    
    UITapGestureRecognizer *doubleFingerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];
    [doubleFingerTapGesture setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:doubleFingerTapGesture];
    //
    UITapGestureRecognizer *tripleFingerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapAction)];
    [tripleFingerTapGesture setNumberOfTouchesRequired:3];
    [self.view addGestureRecognizer:tripleFingerTapGesture];
    
    
    
    
    [self runAction:[SKAction repeatActionForever:[SKAction playSoundFileNamed:@"BG Music.m4a" waitForCompletion:YES]]];
    /* Setup your scene here */
    
    NSArray *myControlValues  = [[ NSArray alloc] initWithObjects:@"1",@"2",@"3", @"4", @"5", @"Circles", @"Squares", @"Quit", nil] ;
    
    UISegmentedControl *myControl = [[ UISegmentedControl alloc] initWithItems:myControlValues ];
    
    [myControl setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    
    //
    //
    //   rz  WHY DOES THIS CONTROL HAVE DEAD SPACE AT THE VERY TOP OF THE SCREEN  ???
    //
    //
    //
    //    [myControl setFrame:CGRectMake(20, 20 , 290 , 50)];
    [myControl setWidth:(myButtonWidth) forSegmentAtIndex:0];
    [myControl setWidth:(myButtonWidth) forSegmentAtIndex:1];
    [myControl setWidth:(myButtonWidth) forSegmentAtIndex:2];
    [myControl setWidth:(myButtonWidth) forSegmentAtIndex:3];
    [myControl setWidth:(myButtonWidth) forSegmentAtIndex:4];
    
    [myControl addTarget:self action:@selector(mySwitchChanged:) forControlEvents:UIControlEventValueChanged ];
    [myControl setSelectedSegmentIndex:-1];
    [self.view addSubview:myControl];
    
    //
    //  set up the physics body so the sprites don't fall through the bottom
    //
    //
    //
//    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.view.frame];
    
    
    
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    //self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.view.bounds];
    self.physicsWorld.contactDelegate = self;
    //
    // rz set up the labels describing the scene
    //
    [self makeMyIntroLabels];
    
    [self makeMyInstructionLabels];
    //
    //
    // rz become first responder here so we receive the user's touches on the top
    //    of the screen
    //
//    [myControl becomeFirstResponder];
    
    //
}

-(void)makeMyIntroLabels{
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    myLabel.text = @"eyeCandy! Tap for 5 Little Pictures";
    SKLabelNode *my2ndLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    my2ndLabel.text = @"that bounce and kick each other around!";
    myLabel.fontSize = my2ndLabel.fontSize = 12;
    myLabel.horizontalAlignmentMode = my2ndLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame) + 200 );
    my2ndLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame) + 180);
    [my2ndLabel runAction:[SKAction sequence:@[ [SKAction waitForDuration:5.0],
                                                [SKAction removeFromParent],
                                                ]]];
    //    NSLog(@"ready to add the labels");
    [self addChild:myLabel];
    [self addChild:my2ndLabel];
    
    
}



-(void)makeMyInstructionLabels{
    SKLabelNode *myLabel1 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    [myLabel1 setText:@"Tap or Swipe Right"];
    //    , tap with two fingers to create snow, tap with three fingers to create smoke, swipe right to clear the screen!"];
    [myLabel1 setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [myLabel1 setFontSize:14];
    [myLabel1 setFontColor:[UIColor redColor]];
    [myLabel1 setAlpha:0.0];
    [self addChild:myLabel1];
    [myLabel1 runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0],
                                             [SKAction fadeInWithDuration:2.0],]]];
    

    
    SKLabelNode *myLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    //    , tap with two fingers to create snow, tap with three fingers to create smoke, swipe right to clear the screen!"];
    [myLabel2 setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-20)];
    [myLabel2 setFontSize:14];
    [myLabel2 setFontColor:[UIColor redColor]];
    [myLabel2 setText:@"Double Tap To Drop Random Squares"];
    [myLabel2 setAlpha:0.0];
    [self addChild:myLabel2];
    [myLabel2 runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0],
                                             [SKAction fadeInWithDuration:3.0],]]];
    
    SKLabelNode *myLabel3 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    //    , tap with two fingers to create snow, tap with three fingers to create smoke, swipe right to clear the screen!"];
    [myLabel3 setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-40)];
    [myLabel3 setFontSize:14];
    [myLabel3 setFontColor:[UIColor redColor]];
    [myLabel3 setText:@"Swipe Up for Larger Pictures, Down for Smaller Pictures"];
    [myLabel3 setAlpha:0.0];
    [self addChild:myLabel3];
    [myLabel3 runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0],
                                             [SKAction fadeInWithDuration:4.0],]]];
    
    
    SKLabelNode *myLabel4 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    //    , tap with two fingers to create snow, tap with three fingers to create smoke, swipe right to clear the screen!"];
    [myLabel4 setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-60)];
    [myLabel4 setFontSize:14];
    [myLabel4 setFontColor:[UIColor redColor]];
    [myLabel4 setText:@"Swipe Right to Clear the Screen"];
    [myLabel4 setAlpha:0.0];
    [self addChild:myLabel4];
    [myLabel4 runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0],
                                             [SKAction fadeInWithDuration:5.0],]]];
    
}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
-(void)singleTapAction {
    /* Called when a touch begins */
    NSString *myPath = [[NSBundle mainBundle] pathForResource:@"myParticle" ofType:@"sks"];
    //
    
    NSArray *mySpriteNames = [[NSArray alloc] initWithObjects:mySpriteImage1, mySpriteImage2, mySpriteImage3, mySpriteImage4, mySpriteImage5, nil];
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[ SKTexture textureWithImage:mySpriteImage1]];
    //    for (UITouch *touch in touches) {
    CGPoint location = CGPointMake(CGRectGetMidX(self.frame) , CGRectGetMaxY(self.frame) - myYOffset );
    UIImage *mySpriteImage = [[UIImage alloc] init];
    //        if (touch.tapCount > 1 ){
    
    for (int myLoopCount = 1 ; myLoopCount < myFiveSpriteLoops ; myLoopCount++) {
        for ( mySpriteImage in mySpriteNames ) {
            sprite = [SKSpriteNode spriteNodeWithTexture:[ SKTexture textureWithImage:mySpriteImage]];
            [sprite setName:@"photosprite"];
            [sprite setPosition:location];
            [sprite setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:sprite.size]];
            [sprite.physicsBody setMass:myMassMult]; // make them heavy if we want to
            [sprite.physicsBody setRestitution:myRestitution];
            [sprite setScale:myPhotoSpriteScale];
            [sprite.physicsBody setContactTestBitMask:0x1];
            //                NSLog(@"Xsize = %f Ysize = %f",sprite.size.width, sprite.size.height);
            [self addChild:sprite];
            
            
            SKEmitterNode *myExitEmitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:myPath];
            [sprite addChild:myExitEmitter];
            [sprite runAction:
             [SKAction sequence:@[
                                  [SKAction waitForDuration:10.0 withRange:2.5],
                                  [SKAction removeFromParent],
                                  ]]  ];
            [myExitEmitter setAlpha:0.0];
            [myExitEmitter setScale:10];
            [myExitEmitter runAction:[SKAction sequence:@[
                                                          [SKAction fadeInWithDuration:5.0],
                                                          [SKAction waitForDuration:2.0],
                                                          [SKAction removeFromParent],
                                                          ]]  ];
        }
    } // end of loopcount
    //        }  // end of if
    
    //    } // end of touches loop
}



-(void)doubleTapAction
{
    
    for (int myLoopCount = 1; myLoopCount < myNumberOfLoopsForSquares ; myLoopCount++) {
    
    int myHeight = self.view.bounds.size.height;
    int myRandomHeight = arc4random() % myHeight ;

    int myWidth = self.view.bounds.size.width;
    int myRandomWidth = arc4random() % myWidth ;
//    NSLog(@"Frame Width= %i Frmame Height= %i Width= %i Height= %i, ", myWidth , myHeight, myRandomWidth, myRandomHeight);
    SKSpriteNode *myColorSprite = [[SKSpriteNode alloc] init];
//    CGPoint location = [touch locationInNode:self];
    CGPoint location = CGPointMake(myRandomHeight, myRandomWidth);
    CGSize myColorSpriteSize =   CGSizeMake(myColorSpriteDefaultSize, myColorSpriteDefaultSize) ;
    int myRandomSprite = arc4random()%15;
    switch (myRandomSprite) {
        case 1:
            myColorSprite =  [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:myColorSpriteSize];
            break;
        case 2:
            myColorSprite = [ SKSpriteNode spriteNodeWithColor:[UIColor darkGrayColor] size:myColorSpriteSize];
            break;
        case 3:
            myColorSprite = [ SKSpriteNode spriteNodeWithColor:[UIColor lightGrayColor] size:myColorSpriteSize];
            break;
        case 4:
            myColorSprite = [ SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:myColorSpriteSize];
            break;
        case 5:
            myColorSprite = [ SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:myColorSpriteSize];
            break;
        case 6:
            myColorSprite = [ SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:myColorSpriteSize];
            break;
        case 7:
            myColorSprite = [ SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:myColorSpriteSize];
            break;
        case 8:
            myColorSprite = [ SKSpriteNode spriteNodeWithColor:[UIColor cyanColor] size:myColorSpriteSize];
            break;
        case 9:
            myColorSprite = [ SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:myColorSpriteSize];
            break;
        case 10:
            myColorSprite = [ SKSpriteNode spriteNodeWithColor:[UIColor magentaColor] size:myColorSpriteSize];
            break;
        case 11:
            myColorSprite = [ SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:myColorSpriteSize];
            break;
        case 12:
            myColorSprite = [ SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:myColorSpriteSize];
            break;
        case 13:
            myColorSprite = [ SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:myColorSpriteSize];
            break;
        default:
            break;
    }  // end of switch
    [myColorSprite setPosition:location];
    [myColorSprite setBlendMode:SKBlendModeAdd];
    [myColorSprite setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:myColorSprite.size]];
    [myColorSprite.physicsBody setAffectedByGravity:YES];
    [myColorSprite.physicsBody setMass:myMassMult]; // make them heavy if we want to
    [myColorSprite.physicsBody setRestitution:myRestitution];
    [myColorSprite runAction:
     [SKAction sequence:@[
                          [SKAction waitForDuration:10.0 withRange:2.5],
                          [SKAction removeFromParent],
                          ]]  ];

    [self addChild:myColorSprite];

    } // end of loop
    
}




-(void)tripleTapAction
{
    [self mySpray];
}


-(void)myUpSwipeAction
{
    
    //    NSLog(@"up swipe!");
    // rz make photo sprites larger
    myPhotoSpriteScale += .05;
    [self enumerateChildNodesWithName:@"photosprite" usingBlock:^(SKNode *node, BOOL *stop) {
        [node setScale:myPhotoSpriteScale ];
    }];

}

-(void)myDownSwipeAction
{
    //    NSLog(@"down swipe!");
    // rz make photo sprites smaller
    if (myPhotoSpriteScale >= .06) {
        myPhotoSpriteScale -= .05;
    }
    [self enumerateChildNodesWithName:@"photosprite" usingBlock:^(SKNode *node, BOOL *stop) {
        [node setScale:myPhotoSpriteScale ];
    }];
}




-(void)myLeftSwipeAction
{
    //    NSLog(@"left swipe!");
}



-(void)myRightSwipeAction
{
    //    NSLog(@"right swipe!");
    [self removeAllChildren];
    [self makeMyInstructionLabels];
}






- (void)didBeginContact:(SKPhysicsContact *)contact {
    //NSLog(@"Contact started between %@ and %@", contact.bodyA, contact.bodyB);
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    
    
    bool myWait =  YES;
    
    if ( contact.bodyA.contactTestBitMask == 0x1 ){
        switch (contact.bodyB.contactTestBitMask) {
            case 1:
                // rz a dropped sprite hits another dropped sprite
                [self runAction:[SKAction playSoundFileNamed:@"hit.m4a" waitForCompletion:myWait]];
                break;
            case 2:
                // rz a dropped sprite hits another dropped sprite
                [self runAction:[SKAction playSoundFileNamed:@"cymbalhit.m4a" waitForCompletion:myWait]];
                break;
            case 4:
                [self runAction:[SKAction playSoundFileNamed:@"snare.m4a" waitForCompletion:myWait]];
                break;
            default:
                break;
        }
    }
    if (contact.bodyA.contactTestBitMask == 0x2 ){
        switch (contact.bodyB.contactTestBitMask) {
            case 2:
                [self runAction:[SKAction playSoundFileNamed:@"ow.m4a" waitForCompletion:myWait]];
                break;
            case 3:
                // rz an image sprite hits a dropped sprite
                [self runAction:[SKAction playSoundFileNamed:@"crash.m4a" waitForCompletion:myWait]];
                break;
            case 4:
                [self runAction:[SKAction playSoundFileNamed:@"hit.m4a" waitForCompletion:myWait]];
                break;
            default:
                break;
        }
    }
}





- (IBAction)mySwitchChanged:(UISegmentedControl *)sender{
    long myValue = sender.selectedSegmentIndex;
    //NSLog(@"Value = %ld",myValue);
    
    SKAction *myImageSpriteAction =    [SKAction sequence:@[
                                                            [SKAction waitForDuration:10.0 withRange:1.5],
                                                            [SKAction removeFromParent],
                                                            ]];
    switch (myValue) {
        case 0: {
            SKSpriteNode *myImageSprite1 = [SKSpriteNode spriteNodeWithTexture:[ SKTexture textureWithImage:mySpriteImage1]];
            myImageSprite1.position = CGPointMake(CGRectGetMidX(self.frame) - 100, CGRectGetMaxY(self.frame) - myYOffset );
            [myImageSprite1 setScale: myPhotoSpriteScale];
            myImageSprite1.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myImageSprite1.size];
            myImageSprite1.physicsBody.restitution = 0.94;
            myImageSprite1.physicsBody.contactTestBitMask = 0x02;
            [myImageSprite1.physicsBody setMass:100.0];
            [myImageSprite1 setName:@"photosprite"];
            [myImageSprite1 runAction:myImageSpriteAction];
            [self addChild:myImageSprite1];
            break;
        }
        case 1: {
            SKSpriteNode *myImageSprite2 = [SKSpriteNode spriteNodeWithTexture:[ SKTexture textureWithImage:mySpriteImage2]];
            myImageSprite2.position = CGPointMake(CGRectGetMidX(self.frame) - 50, CGRectGetMaxY(self.frame) - myYOffset );
            [myImageSprite2 setScale: myPhotoSpriteScale];
            myImageSprite2.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myImageSprite2.size];
            myImageSprite2.physicsBody.restitution = 0.94;
            myImageSprite2.physicsBody.contactTestBitMask = 0x02;
            [myImageSprite2.physicsBody setMass:100.0];
            [myImageSprite2 setName:@"photosprite"];
            [myImageSprite2 runAction:myImageSpriteAction];
            [self addChild:myImageSprite2];
            break;
        }
        case 2: {
            SKSpriteNode *myImageSprite3 = [SKSpriteNode spriteNodeWithTexture:[ SKTexture textureWithImage:mySpriteImage3]];
            myImageSprite3.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - myYOffset );
            [myImageSprite3 setScale: myPhotoSpriteScale];
            myImageSprite3.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myImageSprite3.size];
            myImageSprite3.physicsBody.restitution = 0.94;
            myImageSprite3.physicsBody.contactTestBitMask = 0x02;
            [myImageSprite3.physicsBody setMass:100.0];
            [myImageSprite3 setName:@"photosprite"];
            [myImageSprite3 runAction:myImageSpriteAction];
            [self addChild:myImageSprite3];
            break;
        }
        case 3: {
            SKSpriteNode *myImageSprite4 = [SKSpriteNode spriteNodeWithTexture:[ SKTexture textureWithImage:mySpriteImage4]];
            myImageSprite4.position = CGPointMake(CGRectGetMidX(self.frame) + 50, CGRectGetMaxY(self.frame) - myYOffset );
            [myImageSprite4 setScale: myPhotoSpriteScale];
            myImageSprite4.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myImageSprite4.size];
            myImageSprite4.physicsBody.restitution = 0.94;
            myImageSprite4.physicsBody.contactTestBitMask = 0x02;
            [myImageSprite4.physicsBody setMass:100.0];
            [myImageSprite4 setName:@"photosprite"];
            [myImageSprite4 runAction:myImageSpriteAction];
            [self addChild:myImageSprite4];
            break;
        }
        case 4: {
            SKSpriteNode *myImageSprite5 = [SKSpriteNode spriteNodeWithTexture:[ SKTexture textureWithImage:mySpriteImage5]];
            myImageSprite5.position = CGPointMake(CGRectGetMidX(self.frame) + 100, CGRectGetMaxY(self.frame) - myYOffset );
            [myImageSprite5 setScale: myPhotoSpriteScale];
            myImageSprite5.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myImageSprite5.size];
            myImageSprite5.physicsBody.restitution = 0.94;
            myImageSprite5.physicsBody.contactTestBitMask = 0x02;
            [myImageSprite5.physicsBody setMass:100.0];
            [myImageSprite5 setName:@"photosprite"];
            [myImageSprite5 runAction:myImageSpriteAction];
            [self addChild:myImageSprite5];
            break;
        }
        case 5:
            // rz have to put circle sprites in here
            //
            [self myCircles];
            break;
        case 6:
            [self mySpray];
            break;
        case 7:
            exit(0);
        default:
            break;
    }
    [sender setSelectedSegmentIndex:-1];
}





-(void)mySpray{
    CGSize myColorSpriteSize =   CGSizeMake(myColorSpriteDefaultSize, myColorSpriteDefaultSize) ;
    for ( int i = 1 ; i <= myColorSpriteLoops ; i++){
        SKSpriteNode *colorsprite1 = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:myColorSpriteSize];
        SKSpriteNode *colorsprite2 = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:myColorSpriteSize ];      // 0.0 white
        SKSpriteNode *colorsprite3 = [SKSpriteNode spriteNodeWithColor:[UIColor darkGrayColor] size:myColorSpriteSize ];   // 0.333 white
        SKSpriteNode *colorsprite4 = [SKSpriteNode spriteNodeWithColor:[UIColor lightGrayColor] size:myColorSpriteSize ];  // 0.667 white
        SKSpriteNode *colorsprite5 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:myColorSpriteSize ];      // 1.0 white
        SKSpriteNode *colorsprite6 = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:myColorSpriteSize ];       // 0.5 white
        SKSpriteNode *colorsprite7 = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:myColorSpriteSize ];        // 1.0, 0.0, 0.0 RGB
        SKSpriteNode *colorsprite8 = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:myColorSpriteSize ];      // 0.0, 1.0, 0.0 RGB
        SKSpriteNode *colorsprite9 = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:myColorSpriteSize ];       // 0.0, 0.0, 1.0 RGB
        SKSpriteNode *colorsprite10 = [SKSpriteNode spriteNodeWithColor:[UIColor cyanColor] size:myColorSpriteSize ];       // 0.0, 1.0, 1.0 RGB
        SKSpriteNode *colorsprite11 = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:myColorSpriteSize ];     // 1.0, 1.0, 0.0 RGB
        SKSpriteNode *colorsprite12 = [SKSpriteNode spriteNodeWithColor:[UIColor magentaColor] size:myColorSpriteSize ];    // 1.0, 0.0, 1.0 RGB
        SKSpriteNode *colorsprite13 = [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:myColorSpriteSize ];     // 1.0, 0.5, 0.0 RGB
        SKSpriteNode *colorsprite14 = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:myColorSpriteSize ];     // 0.5, 0.0, 0.5 RGB
        SKSpriteNode *colorsprite15 = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:myColorSpriteSize ];      // 0.6, 0.4, 0.2 RGB
        
        
        
        colorsprite1.position = CGPointMake(CGRectGetMidX(self.frame) - 175 , CGRectGetMaxY(self.frame) - myYOffset );
        colorsprite2.position = CGPointMake(CGRectGetMidX(self.frame) - 150 , CGRectGetMaxY(self.frame) - myYOffset );
        colorsprite3.position = CGPointMake(CGRectGetMidX(self.frame) - 125 , CGRectGetMaxY(self.frame) - myYOffset );
        colorsprite4.position = CGPointMake(CGRectGetMidX(self.frame) - 100, CGRectGetMaxY(self.frame) - myYOffset );
        colorsprite5.position = CGPointMake(CGRectGetMidX(self.frame) - 75 , CGRectGetMaxY(self.frame) - myYOffset );
        colorsprite6.position = CGPointMake(CGRectGetMidX(self.frame) - 50 , CGRectGetMaxY(self.frame) - myYOffset );
        colorsprite7.position = CGPointMake(CGRectGetMidX(self.frame) - 25 , CGRectGetMaxY(self.frame) - myYOffset );
        colorsprite8.position = CGPointMake(CGRectGetMidX(self.frame) , CGRectGetMaxY(self.frame) - myYOffset );
        colorsprite9.position = CGPointMake(CGRectGetMidX(self.frame) + 25 , CGRectGetMaxY(self.frame) - myYOffset );
        colorsprite10.position = CGPointMake(CGRectGetMidX(self.frame) + 50 , CGRectGetMaxY(self.frame) - myYOffset );
        colorsprite11.position = CGPointMake(CGRectGetMidX(self.frame) + 75 , CGRectGetMaxY(self.frame) - myYOffset );
        colorsprite12.position = CGPointMake(CGRectGetMidX(self.frame) + 100 , CGRectGetMaxY(self.frame) - myYOffset );
        colorsprite13.position = CGPointMake(CGRectGetMidX(self.frame) + 125 , CGRectGetMaxY(self.frame) - myYOffset );
        colorsprite14.position = CGPointMake(CGRectGetMidX(self.frame) + 150 , CGRectGetMaxY(self.frame) - myYOffset );
        colorsprite15.position =  CGPointMake(CGRectGetMidX(self.frame) + 175 , CGRectGetMaxY(self.frame) - myYOffset );
        
        
        colorsprite1.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        colorsprite2.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        colorsprite3.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        colorsprite4.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        colorsprite5.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        colorsprite6.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        colorsprite7.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        colorsprite8.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        colorsprite9.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        colorsprite10.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        colorsprite11.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        colorsprite12.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        colorsprite13.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        colorsprite14.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        colorsprite15.physicsBody = [ SKPhysicsBody bodyWithRectangleOfSize:myColorSpriteSize];
        
        
        colorsprite1.physicsBody.affectedByGravity = YES;
        colorsprite2.physicsBody.affectedByGravity = YES;
        colorsprite3.physicsBody.affectedByGravity = YES;
        colorsprite4.physicsBody.affectedByGravity = YES;
        colorsprite5.physicsBody.affectedByGravity = YES;
        colorsprite6.physicsBody.affectedByGravity = YES;
        colorsprite7.physicsBody.affectedByGravity = YES;
        colorsprite8.physicsBody.affectedByGravity = YES;
        colorsprite9.physicsBody.affectedByGravity = YES;
        colorsprite10.physicsBody.affectedByGravity = YES;
        colorsprite11.physicsBody.affectedByGravity = YES;
        colorsprite12.physicsBody.affectedByGravity = YES;
        colorsprite13.physicsBody.affectedByGravity = YES;
        colorsprite14.physicsBody.affectedByGravity = YES;
        colorsprite15.physicsBody.affectedByGravity = YES;
        
        colorsprite1.physicsBody.restitution = myColorSpriteRestitution;
        colorsprite2.physicsBody.restitution = myColorSpriteRestitution;
        colorsprite3.physicsBody.restitution = myColorSpriteRestitution;
        colorsprite4.physicsBody.restitution = myColorSpriteRestitution;
        colorsprite5.physicsBody.restitution = myColorSpriteRestitution;
        colorsprite6.physicsBody.restitution = myColorSpriteRestitution;
        colorsprite7.physicsBody.restitution = myColorSpriteRestitution;
        colorsprite8.physicsBody.restitution = myColorSpriteRestitution;
        colorsprite9.physicsBody.restitution = myColorSpriteRestitution;
        colorsprite10.physicsBody.restitution = myColorSpriteRestitution;
        colorsprite11.physicsBody.restitution = myColorSpriteRestitution;
        colorsprite12.physicsBody.restitution = myColorSpriteRestitution;
        colorsprite13.physicsBody.restitution = myColorSpriteRestitution;
        colorsprite14.physicsBody.restitution = myColorSpriteRestitution;
        colorsprite15.physicsBody.restitution = myColorSpriteRestitution;
        
        
        colorsprite1.name = @"colorsprite";
        colorsprite2.name = @"colorsprite" ;
        colorsprite3.name = @"colorsprite" ;
        colorsprite4.name = @"colorsprite" ;
        colorsprite5.name = @"colorsprite" ;
        colorsprite6.name = @"colorsprite" ;
        colorsprite7.name = @"colorsprite" ;
        colorsprite8.name = @"colorsprite" ;
        colorsprite9.name = @"colorsprite" ;
        colorsprite10.name = @"colorsprite" ;
        colorsprite11.name = @"colorsprite" ;
        colorsprite12.name = @"colorsprite" ;
        colorsprite13.name = @"colorsprite" ;
        colorsprite14.name = @"colorsprite" ;
        colorsprite15.name = @"colorsprite" ;
        
        
        
        colorsprite1.physicsBody.contactTestBitMask = 0x03;
        colorsprite2.physicsBody.contactTestBitMask = 0x03;
        colorsprite3.physicsBody.contactTestBitMask = 0x03;
        colorsprite4.physicsBody.contactTestBitMask = 0x03;
        colorsprite5.physicsBody.contactTestBitMask = 0x03;
        colorsprite6.physicsBody.contactTestBitMask = 0x03;
        colorsprite7.physicsBody.contactTestBitMask = 0x03;
        colorsprite8.physicsBody.contactTestBitMask = 0x03;
        colorsprite9.physicsBody.contactTestBitMask = 0x03;
        colorsprite10.physicsBody.contactTestBitMask = 0x03;
        colorsprite11.physicsBody.contactTestBitMask = 0x03;
        colorsprite12.physicsBody.contactTestBitMask = 0x03;
        colorsprite13.physicsBody.contactTestBitMask = 0x03;
        colorsprite14.physicsBody.contactTestBitMask = 0x03;
        colorsprite15.physicsBody.contactTestBitMask = 0x03 ;
        
        
        
        
        SKAction *mycolorSpriteAction =    [SKAction sequence:@[
//                                                                [SKAction rotateByAngle:( M_PI ) duration:1],
                                                                [SKAction waitForDuration:5.0 withRange:1.5],
                                                                [SKAction removeFromParent],
                                                                ]];
        
        
        
        [colorsprite1 runAction:mycolorSpriteAction];
        [colorsprite2 runAction:mycolorSpriteAction];
        [colorsprite3 runAction:mycolorSpriteAction];
        [colorsprite4 runAction:mycolorSpriteAction];
        [colorsprite5 runAction:mycolorSpriteAction];
        [colorsprite6 runAction:mycolorSpriteAction];
        [colorsprite7 runAction:mycolorSpriteAction];
        [colorsprite8 runAction:mycolorSpriteAction];
        [colorsprite9 runAction:mycolorSpriteAction];
        [colorsprite10 runAction:mycolorSpriteAction];
        [colorsprite11 runAction:mycolorSpriteAction];
        [colorsprite12 runAction:mycolorSpriteAction];
        [colorsprite13 runAction:mycolorSpriteAction];
        [colorsprite14 runAction:mycolorSpriteAction];
        [colorsprite15 runAction:mycolorSpriteAction];
        
        
        
        
        [self addChild:colorsprite1];
        [self addChild:colorsprite2];
        [self addChild:colorsprite3];
        [self addChild:colorsprite4];
        [self addChild:colorsprite5];
        [self addChild:colorsprite6];
        [self addChild:colorsprite7];
        [self addChild:colorsprite8];
        [self addChild:colorsprite9];
        [self addChild:colorsprite10];
        [self addChild:colorsprite11];
        [self addChild:colorsprite12];
        [self addChild:colorsprite13];
        [self addChild:colorsprite14];
        [self addChild:colorsprite15];
        
    } // end of loop
}


-(void)myCircles{
    for ( int i = 1 ; i <= myCircleSpriteLoops ; i++){
        SKSpriteNode *myCircleSprite1 = [ SKSpriteNode spriteNodeWithImageNamed:@"Leopard"];
        [myCircleSprite1 setScale: myCircleSpriteScale ];
        [myCircleSprite1 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite1.physicsBody setAffectedByGravity:YES];
        [myCircleSprite1.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite1.physicsBody setContactTestBitMask:0x03];
        myCircleSprite1.position = CGPointMake(CGRectGetMidX(self.frame) - 175 , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite1];
        SKAction *myCircleSpriteAction =    [SKAction sequence:@[
                                                                 [SKAction waitForDuration:5.0 withRange:1.5],
                                                                 [SKAction removeFromParent],
                                                                 ]];
        [myCircleSprite1 runAction:myCircleSpriteAction];
        
        SKSpriteNode *myCircleSprite2 = [ SKSpriteNode spriteNodeWithImageNamed:@"Blue"];
        [myCircleSprite2 setScale: myCircleSpriteScale ];
        [myCircleSprite2 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite2.physicsBody setAffectedByGravity:YES];
        [myCircleSprite2.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite2.physicsBody setContactTestBitMask:0x03];
        myCircleSprite2.position = CGPointMake(CGRectGetMidX(self.frame) - 150 , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite2];
        [myCircleSprite2 runAction:myCircleSpriteAction];
        
        SKSpriteNode *myCircleSprite3 = [ SKSpriteNode spriteNodeWithImageNamed:@"Grey"];
        [myCircleSprite3 setScale: myCircleSpriteScale ];
        [myCircleSprite3 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite3.physicsBody setAffectedByGravity:YES];
        [myCircleSprite3.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite3.physicsBody setContactTestBitMask:0x03];
        myCircleSprite3.position = CGPointMake(CGRectGetMidX(self.frame) - 125 , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite3];
        [myCircleSprite3 runAction:myCircleSpriteAction];
        
        SKSpriteNode *myCircleSprite4 = [ SKSpriteNode spriteNodeWithImageNamed:@"Wood"];
        [myCircleSprite4 setScale: myCircleSpriteScale ];
        [myCircleSprite4 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite4.physicsBody setAffectedByGravity:YES];
        [myCircleSprite4.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite4.physicsBody setContactTestBitMask:0x03];
        myCircleSprite4.position = CGPointMake(CGRectGetMidX(self.frame) - 100 , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite4];
        [myCircleSprite4 runAction:myCircleSpriteAction];
        
        SKSpriteNode *myCircleSprite5 = [ SKSpriteNode spriteNodeWithImageNamed:@"Yellow"];
        [myCircleSprite5 setScale: myCircleSpriteScale ];
        [myCircleSprite5 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite5.physicsBody setAffectedByGravity:YES];
        [myCircleSprite5.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite5.physicsBody setContactTestBitMask:0x03];
        myCircleSprite5.position = CGPointMake(CGRectGetMidX(self.frame) - 75 , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite5];
        [myCircleSprite5 runAction:myCircleSpriteAction];
        
        SKSpriteNode *myCircleSprite6 = [ SKSpriteNode spriteNodeWithImageNamed:@"Red"];
        [myCircleSprite6 setScale: myCircleSpriteScale ];
        [myCircleSprite6 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite6.physicsBody setAffectedByGravity:YES];
        [myCircleSprite6.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite6.physicsBody setContactTestBitMask:0x03];
        myCircleSprite6.position = CGPointMake(CGRectGetMidX(self.frame) - 50 , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite6];
        [myCircleSprite6 runAction:myCircleSpriteAction];
        
        SKSpriteNode *myCircleSprite7 = [ SKSpriteNode spriteNodeWithImageNamed:@"Green"];
        [myCircleSprite7 setScale: myCircleSpriteScale ];
        [myCircleSprite7 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite7.physicsBody setAffectedByGravity:YES];
        [myCircleSprite7.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite7.physicsBody setContactTestBitMask:0x03];
        myCircleSprite7.position = CGPointMake(CGRectGetMidX(self.frame) - 25 , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite7];
        [myCircleSprite7 runAction:myCircleSpriteAction];
        
        SKSpriteNode *myCircleSprite8 = [ SKSpriteNode spriteNodeWithImageNamed:@"Basket"];
        [myCircleSprite8 setScale: myCircleSpriteScale ];
        [myCircleSprite8 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite8.physicsBody setAffectedByGravity:YES];
        [myCircleSprite8.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite8.physicsBody setContactTestBitMask:0x03];
        myCircleSprite8.position = CGPointMake(CGRectGetMidX(self.frame)  , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite8];
        [myCircleSprite8 runAction:myCircleSpriteAction];
        
        SKSpriteNode *myCircleSprite9 = [ SKSpriteNode spriteNodeWithImageNamed:@"Checker"];
        [myCircleSprite9 setScale: myCircleSpriteScale ];
        [myCircleSprite9 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite9.physicsBody setAffectedByGravity:YES];
        [myCircleSprite9.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite9.physicsBody setContactTestBitMask:0x03];
        myCircleSprite9.position = CGPointMake(CGRectGetMidX(self.frame) + 25 , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite9];
        [myCircleSprite9 runAction:myCircleSpriteAction];
        
        
        SKSpriteNode *myCircleSprite10 = [ SKSpriteNode spriteNodeWithImageNamed:@"Swirly"];
        [myCircleSprite10 setScale: myCircleSpriteScale ];
        [myCircleSprite10 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite10.physicsBody setAffectedByGravity:YES];
        [myCircleSprite10.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite10.physicsBody setContactTestBitMask:0x03];
        myCircleSprite10.position = CGPointMake(CGRectGetMidX(self.frame) + 50 , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite10];
        [myCircleSprite10 runAction:myCircleSpriteAction];
        
        
        SKSpriteNode *myCircleSprite11 = [ SKSpriteNode spriteNodeWithImageNamed:@"BrownSwirly"];
        [myCircleSprite11 setScale: myCircleSpriteScale ];
        [myCircleSprite11 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite11.physicsBody setAffectedByGravity:YES];
        [myCircleSprite11.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite11.physicsBody setContactTestBitMask:0x03];
        myCircleSprite11.position = CGPointMake(CGRectGetMidX(self.frame) + 75 , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite11];
        [myCircleSprite11 runAction:myCircleSpriteAction];
        
        
        SKSpriteNode *myCircleSprite12 = [ SKSpriteNode spriteNodeWithImageNamed:@"Rocks"];
        [myCircleSprite12 setScale: myCircleSpriteScale ];
        [myCircleSprite12 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite12.physicsBody setAffectedByGravity:YES];
        [myCircleSprite12.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite12.physicsBody setContactTestBitMask:0x03];
        myCircleSprite12.position = CGPointMake(CGRectGetMidX(self.frame) + 100 , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite12];
        [myCircleSprite12 runAction:myCircleSpriteAction];
        
        
        SKSpriteNode *myCircleSprite13 = [ SKSpriteNode spriteNodeWithImageNamed:@"Paper"];
        [myCircleSprite13 setScale: myCircleSpriteScale ];
        [myCircleSprite13 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite13.physicsBody setAffectedByGravity:YES];
        [myCircleSprite13.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite13.physicsBody setContactTestBitMask:0x03];
        myCircleSprite13.position = CGPointMake(CGRectGetMidX(self.frame) + 125 , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite13];
        [myCircleSprite13 runAction:myCircleSpriteAction];
        
        
        SKSpriteNode *myCircleSprite14 = [ SKSpriteNode spriteNodeWithImageNamed:@"Marble"];
        [myCircleSprite14 setScale: myCircleSpriteScale ];
        [myCircleSprite14 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite14.physicsBody setAffectedByGravity:YES];
        [myCircleSprite14.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite14.physicsBody setContactTestBitMask:0x03];
        myCircleSprite14.position = CGPointMake(CGRectGetMidX(self.frame) + 150 , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite14];
        [myCircleSprite14 runAction:myCircleSpriteAction];
        
        
        SKSpriteNode *myCircleSprite15 = [ SKSpriteNode spriteNodeWithImageNamed:@"Bricks"];
        [myCircleSprite15 setScale: myCircleSpriteScale ];
        [myCircleSprite15 setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:myCircleSpriteSize]];
        [myCircleSprite15.physicsBody setAffectedByGravity:YES];
        [myCircleSprite15.physicsBody setRestitution:myCircleSpriteRestitution];
        [myCircleSprite15.physicsBody setContactTestBitMask:0x03];
        myCircleSprite15.position = CGPointMake(CGRectGetMidX(self.frame) + 175 , CGRectGetMaxY(self.frame) - myYOffset );
        [self addChild:myCircleSprite15];
        [myCircleSprite15 runAction:myCircleSpriteAction];
        
        
        
        
    } // end of loop
}






-(void)update:(CFTimeInterval)currentTime {
    //    NSLog(@"count = %lu",(unsigned long)self.children.count);
    if ( self.children.count > 900) {
        [self enumerateChildNodesWithName:@"colorsprite" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
    }
    
    /* Called before each frame is rendered */
}

//-(void)didSimulatePhysics{
//}

@end
