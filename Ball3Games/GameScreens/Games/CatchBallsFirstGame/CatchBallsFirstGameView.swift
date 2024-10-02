import SwiftUI
import SpriteKit

struct CatchBallsFirstGameView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var livesVM: LivesViewModel
    @EnvironmentObject var recordsVM: RecordsViewModel
    
    @State var score: Int = 0
    @State var gameOver: Bool = false
    @State var newRecord: Bool = false
    @State var pausedGame: Bool = false
    @State var livesAvailableAlertVisible: Bool = false
    
    @State var gamescene: CatchBallsFirstGameScene!
    
    var body: some View {
        ZStack {
            if let gamescene = gamescene {
                SpriteView(scene: gamescene)
                    .ignoresSafeArea()
            }
            
            if pausedGame {
                PauseGameView()
            }
            
            if gameOver {
                if newRecord {
                    NewRecordView(best: score)
                } else {
                    LoseGameView(currentScore: score, best: recordsVM.game1Record)
                }
            }
        }
        .onAppear {
            gamescene = CatchBallsFirstGameScene()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("game_over")), perform: { notif in
            guard let info = notif.userInfo as? [String: Any],
                  let score = info["score"] as? Int else { return }
            self.score = score
            if self.score > recordsVM.game1Record {
                recordsVM.game1Record = self.score
                newRecord = true
            }
            livesVM.lives -= 1
            withAnimation(.linear) {
                self.gameOver = true
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("pause_action")), perform: { _ in
            withAnimation(.linear) {
                self.pausedGame = true
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("home_action")), perform: { _ in
            presMode.wrappedValue.dismiss()
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("resume_action")), perform: { _ in
            gamescene.isPaused = false
            withAnimation(.linear) {
                pausedGame = false
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("restart_action")), perform: { _ in
            if livesVM.lives > 0 {
                gamescene = gamescene.restartGame()
                withAnimation(.linear) {
                    gameOver = false
                }
            } else {
                livesAvailableAlertVisible = true
            }
        })
        .alert(isPresented: $livesAvailableAlertVisible) {
            Alert(title: Text("Alert"),
            message: Text("you run out of lives, pick up the bonus on the main screen, or come back later and get lives!"),
                  dismissButton: .default(Text("Ok"), action: {
                presMode.wrappedValue.dismiss()
            }))
        }
    }
}

#Preview {
    CatchBallsFirstGameView()
        .environmentObject(LivesViewModel())
        .environmentObject(RecordsViewModel())
}
