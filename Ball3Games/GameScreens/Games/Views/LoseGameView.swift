import SwiftUI

struct LoseGameView: View {
    
   var currentScore: Int
   var best: Int
   
   var body: some View {
       VStack {
           VStack {
               Spacer()
               
               Text("You lose")
                   .foregroundColor(.white)
                   .font(.custom("JosefinSansRoman-Bold", size: 32))
                   .shadow(color: .black, radius: 1, x: -1)
                   .shadow(color: .black, radius: 1, x: 1)
                   .multilineTextAlignment(.center)
               
               Spacer()
               
               Text("Best:          \(best)")
                   .foregroundColor(.white)
                   .font(.custom("JosefinSansRoman-Bold", size: 24))
                   .shadow(color: .black, radius: 1, x: -1)
                   .shadow(color: .black, radius: 1, x: 1)
                   .multilineTextAlignment(.leading)
               
               Text("Score:          \(currentScore)")
                   .foregroundColor(.white)
                   .font(.custom("JosefinSansRoman-Bold", size: 24))
                   .shadow(color: .black, radius: 1, x: -1)
                   .shadow(color: .black, radius: 1, x: 1)
                   .multilineTextAlignment(.leading)
               Spacer()
               
               Button {
                   NotificationCenter.default.post(name: Notification.Name("restart_action"), object: nil)
               } label: {
                   Image("bt-Restart")
               }
               
               Button {
                   NotificationCenter.default.post(name: Notification.Name("home_action"), object: nil)
               } label: {
                   Image("bt-Home")
               }
               .padding(.top)
               
               Spacer()
               
           }
           .frame(width: 300, height: 400)
           .background(
               RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                   .fill(Color.init(red: 116/255, green: 116/255, blue: 116/255))
                   .frame(width: 300, height: 420)
           )
           .background(
               RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                   .stroke(.white, lineWidth: 4)
                   .frame(width: 300, height: 420)
           )
       }
       .background(
           Rectangle()
               .fill(.black.opacity(0.5))
               .frame(minWidth: UIScreen.main.bounds.width,
                      minHeight: UIScreen.main.bounds.height)
               .ignoresSafeArea()
       )
   }
}

#Preview {
    LoseGameView(currentScore: 12, best: 42)
}
