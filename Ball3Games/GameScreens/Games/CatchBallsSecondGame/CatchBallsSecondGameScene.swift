import SwiftUI
import SpriteKit

class CatchBallsSecondGameScene: SKScene, SKPhysicsContactDelegate {
    
    private var btPause: SKSpriteNode!
    // private var btSettings: SKSpriteNode!
    
    private var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    private var scoreLabel: SKLabelNode!
    
    private var ball: SKSpriteNode!
    var isMovingClockwise = true
    
    private var spawnBlocks = Timer()
    
    func restartGame() -> CatchBallsSecondGameScene {
        let newScene = CatchBallsSecondGameScene()
        view?.presentScene(newScene)
        return newScene
    }
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 750, height: 1350)
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        let background = SKSpriteNode(imageNamed: "game_2_background")
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
        
        let ballPhase = SKSpriteNode(imageNamed: "game_2_ball_phase")
        ballPhase.position = CGPoint(x: size.width / 2, y: size.height / 2)
        ballPhase.size = CGSize(width: 290, height: 250)
        addChild(ballPhase)
        
        ball = SKSpriteNode(imageNamed: "game_2_ball")
        ball.position = CGPoint(x: size.width / 2, y: size.height / 2 + 95)
        ball.size = CGSize(width: 50, height: 45)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.isDynamic = false
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = 1
        ball.physicsBody?.collisionBitMask = 2 | 3
        ball.physicsBody?.contactTestBitMask = 2 | 3
        addChild(ball)
        
        startMovingBall(clockwise: isMovingClockwise)
        
        spawnBlocks = .scheduledTimer(withTimeInterval: 0.7, repeats: true, block: { _ in
            if !self.isPaused {
                self.spawnBlock()
            }
        })
    }
    
    private func spawnBlock() {
        let randomY = CGFloat.random(in: (size.height / 2 - 150)...(size.height / 2 + 150))
        
        let blockNode = SKSpriteNode(imageNamed: "game_2_block")
        blockNode.size = CGSize(width: 130, height: 40)
        blockNode.position = CGPoint(x: -200, y: randomY)
        blockNode.physicsBody = SKPhysicsBody(rectangleOf: blockNode.size)
        blockNode.physicsBody?.isDynamic = true
        blockNode.physicsBody?.affectedByGravity = false
        blockNode.physicsBody?.categoryBitMask = 2
        blockNode.physicsBody?.collisionBitMask = 1
        blockNode.physicsBody?.collisionBitMask = 1
        
        addChild(blockNode)
        
        let actionMoveRight = SKAction.moveTo(x: size.width + 200, duration: 3)
        blockNode.run(actionMoveRight)
        
        if Bool.random() {
            let ballNode = SKSpriteNode(imageNamed: "game_2_ball")
            ballNode.position = CGPoint(x: -400, y: randomY)
            ballNode.size = CGSize(width: 40, height: 35)
            ballNode.physicsBody = SKPhysicsBody(circleOfRadius: ballNode.size.width / 2)
            ballNode.physicsBody?.isDynamic = true
            ballNode.physicsBody?.affectedByGravity = false
            ballNode.physicsBody?.categoryBitMask = 3
            ballNode.physicsBody?.collisionBitMask = 1
            ballNode.physicsBody?.contactTestBitMask = 1
            addChild(ballNode)
            
            let actionMoveRight2 = SKAction.moveTo(x: size.width + 200, duration: 3.4)
            ballNode.run(actionMoveRight2)
        }
    }
    
    func startMovingBall(clockwise: Bool) {
        // Создаем круговое движение
        let radius: CGFloat = 105 // Радиус круга
        let duration: TimeInterval = 1
        
        // Убедимся, что мяч продолжает движение с текущей позиции
        let currentAngle = atan2(ball.position.y - frame.midY, ball.position.x - frame.midX)// Время полного оборота

        // Создаем круговой путь
        let circularPath = CGMutablePath()
        circularPath.addArc(center: CGPoint(x: frame.midX, y: frame.midY),
                            radius: radius,
                            startAngle: currentAngle,
                            endAngle: currentAngle + (clockwise ? 2 * .pi : -2 * .pi),
                            clockwise: !clockwise)
        
        let followPath = SKAction.follow(circularPath, asOffset: false, orientToPath: false, duration: duration)
        let repeatAction = SKAction.repeatForever(followPath)
        
        ball.removeAllActions()
        ball.run(repeatAction)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
           let locat = touch.location(in: self)
           let obj = atPoint(locat)
           
           if obj == btPause {
               NotificationCenter.default.post(name: Notification.Name("pause_action"), object: nil)
           } else {
               // Меняем направление при нажатии
               isMovingClockwise.toggle()
               startMovingBall(clockwise: isMovingClockwise)
           }
       }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        if (contactA.categoryBitMask == 1 && contactB.categoryBitMask == 2) ||
            (contactA.categoryBitMask == 2 && contactB.categoryBitMask == 1) {
            spawnBlocks.invalidate()
            isPaused = true
            NotificationCenter.default.post(name: Notification.Name("game_over"), object: nil, userInfo: ["score": score])
        }
        
        
        if (contactA.categoryBitMask == 1 && contactB.categoryBitMask == 3) ||
            (contactA.categoryBitMask == 3 && contactB.categoryBitMask == 1) {
            score += 1
            let catchedBallNode: SKPhysicsBody

            if contactA.categoryBitMask == 1 {
                catchedBallNode = contactB
            } else {
                catchedBallNode = contactA
            }
           
            if let ballNode = catchedBallNode.node {
                ballNode.removeFromParent()
            }
        }
        
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: CatchBallsSecondGameScene())
            .ignoresSafeArea()
    }
}
