import SpriteKit
import SwiftUI

class CatchBallsFirstGameScene: SKScene, SKPhysicsContactDelegate {
    
    private var btPause: SKSpriteNode!
    // private var btSettings: SKSpriteNode!
    
    private var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    private var scoreLabel: SKLabelNode!
    
    private var ball: SKSpriteNode!
    
    private var objectiveBallTypes: String = ["ball_type_1", "ball_type_2"].randomElement() ?? "ball_type_1"
    
    var toLeftMoving = true
    
    func restartGame() -> CatchBallsFirstGameScene {
        let newScene = CatchBallsFirstGameScene()
        view?.presentScene(newScene)
        return newScene
    }
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 750, height: 1350)
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        let background = SKSpriteNode(imageNamed: "game_1_background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
        
        btPause = SKSpriteNode(imageNamed: "bt-pause")
        btPause.position = CGPoint(x: 100, y: size.height - 100)
        btPause.size = CGSize(width: 90, height: 90)
        addChild(btPause)
        
        scoreLabel = .init(text: "0")
        scoreLabel.fontName = "JosefinSansRoman-Bold"
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 82
        scoreLabel.position = CGPoint(x: size.width / 2, y: 160)
        addChild(scoreLabel)
        
        let ballPhase = SKSpriteNode(imageNamed: "ball_phase")
        ballPhase.position = CGPoint(x: size.width / 2, y: size.height / 2)
        ballPhase.size = CGSize(width: size.width - 100, height: 40)
        addChild(ballPhase)
        
        ball = SKSpriteNode(imageNamed: objectiveBallTypes)
        ball.position = CGPoint(x: size.width / 2, y: size.height / 2)
        ball.size = CGSize(width: 70, height: 60)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.isDynamic = false
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = 1
        ball.physicsBody?.collisionBitMask = 2
        ball.physicsBody?.contactTestBitMask = 2
        addChild(ball)
        
        let actionMoveLeft = SKAction.move(to: CGPoint(x: 90, y: size.height / 2), duration: 0.5)
        let actionRight = SKAction.move(to: CGPoint(x: size.width - 90, y: size.height / 2), duration: 0.7)
        let actionLeft = SKAction.move(to: CGPoint(x: 90, y: size.height / 2), duration: 0.7)
        let seq = SKAction.sequence([actionRight, actionLeft])
        let repeateForever = SKAction.repeatForever(seq)
        let seq2 = SKAction.sequence([actionMoveLeft, repeateForever])
        ball.run(seq2)
        
        startSpawnBalls()
    }
    
    private var spawnTimer = Timer()
    
    private func startSpawnBalls() {
        spawnTimer = .scheduledTimer(withTimeInterval: 0.6, repeats: true, block: { timer in
            if !self.isPaused {
                self.spawnBall()
            }
        })
    }
    
    private func spawnBall() {
        let ballType = ["ball_type_1", "ball_type_2"].randomElement() ?? "ball_type_1"
        
        let angularMove = Bool.random()
        let fromRightPos = Bool.random()
        let randomX = CGFloat.random(in: 150...size.width - 150)
        let angularRandomX = CGFloat.random(in: 100...200)
        
        let ballNode = SKSpriteNode(imageNamed: ballType)
        
        if angularMove {
            if fromRightPos {
                ballNode.position = CGPoint(x: size.width + angularRandomX, y: size.height)
            } else {
                ballNode.position = CGPoint(x: -angularRandomX, y: size.height)
            }
        } else {
            ballNode.position = CGPoint(x: randomX, y: size.height - 100)
        }
        
        ballNode.size = CGSize(width: 50, height: 45)
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: ballNode.size.width / 2)
        ballNode.physicsBody?.isDynamic = true
        ballNode.physicsBody?.affectedByGravity = false
        ballNode.physicsBody?.categoryBitMask = 2
        ballNode.physicsBody?.collisionBitMask = 1
        ballNode.physicsBody?.contactTestBitMask = 1
        ballNode.name = ballType
        
        addChild(ballNode)
        
        var actionMove: SKAction
        if angularMove {
            if fromRightPos {
                actionMove = SKAction.move(to: CGPoint(x: -angularRandomX, y: -100), duration: 3)
            } else {
                actionMove = SKAction.move(to: CGPoint(x: angularRandomX, y: -100), duration: 3)
            }
        } else {
            actionMove = SKAction.move(to: CGPoint(x: randomX, y: -100), duration: 3)
        }
        let seq = SKAction.sequence([actionMove, SKAction.removeFromParent()])
        ballNode.run(seq)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        if (contactA.categoryBitMask == 1 && contactB.categoryBitMask == 2) ||
            (contactA.categoryBitMask == 2 && contactB.categoryBitMask == 1) {
            let catchedBallNode: SKPhysicsBody
            
            if contactA.categoryBitMask == 1 {
                catchedBallNode = contactB
            } else {
                catchedBallNode = contactA
            }
            
            if let ballNode = catchedBallNode.node,
               let nodeName = ballNode.name {
                if nodeName == objectiveBallTypes {
                    ballNode.removeFromParent()
                    score += 1
                } else {
                    spawnTimer.invalidate()
                    isPaused = true
                    NotificationCenter.default.post(name: Notification.Name("game_over"), object: nil, userInfo: ["score": score])
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let locat = touch.location(in: self)
            let obj = atPoint(locat)
            
            if obj == btPause {
                NotificationCenter.default.post(name: Notification.Name("pause_action"), object: nil)
            } else {
                ball.removeAllActions()
                if toLeftMoving {
                    let actionMoveRight = SKAction.move(to: CGPoint(x: size.width - 90, y: size.height / 2), duration: 0.5)
                    let actionLeft = SKAction.move(to: CGPoint(x: 90, y: size.height / 2), duration: 0.7)
                    let actionRight = SKAction.move(to: CGPoint(x: size.width - 90, y: size.height / 2), duration: 0.7)
                    let seq = SKAction.sequence([actionRight, actionLeft])
                    let repeateForever = SKAction.repeatForever(seq)
                    let seq2 = SKAction.sequence([actionMoveRight, repeateForever])
                    ball.run(seq2)
                    toLeftMoving = false
                } else {
                    let actionMoveLeft = SKAction.move(to: CGPoint(x: 90, y: size.height / 2), duration: 0.5)
                    let actionRight = SKAction.move(to: CGPoint(x: size.width - 90, y: size.height / 2), duration: 0.7)
                    let actionLeft = SKAction.move(to: CGPoint(x: 90, y: size.height / 2), duration: 0.7)
                    let seq = SKAction.sequence([actionRight, actionLeft])
                    let repeateForever = SKAction.repeatForever(seq)
                    let seq2 = SKAction.sequence([actionMoveLeft, repeateForever])
                    ball.run(seq2)
                    toLeftMoving = true
                }
            }
        }
        
        
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: CatchBallsFirstGameScene())
            .ignoresSafeArea()
    }
}
