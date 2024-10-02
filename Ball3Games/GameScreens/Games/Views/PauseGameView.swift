import SwiftUI

struct PauseGameView: View {
    var body: some View {
          VStack {
              VStack {
                  Text("Pause")
                      .foregroundColor(.white)
                      .font(.custom("JosefinSansRoman-Bold", size: 32))
                      .shadow(color: .black, radius: 1, x: -1)
                      .shadow(color: .black, radius: 1, x: 1)
                      .multilineTextAlignment(.center)
                  
                  Spacer()
                  
                  Button {
                      NotificationCenter.default.post(name: Notification.Name("resume_action"), object: nil)
                  } label: {
                      Image("bt-Resume")
                  }
                  
                  Button {
                      NotificationCenter.default.post(name: Notification.Name("home_action"), object: nil)
                  } label: {
                      Image("bt-Home")
                  }
                  .padding(.top)
                  
                  Spacer()
                  
              }
              .frame(width: 300, height: 250)
              .background(
                  RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                      .fill(Color.init(red: 15/255, green: 132/255, blue: 149/255))
                      .frame(width: 300, height: 290)
              )
              .background(
                  RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                      .stroke(.white, lineWidth: 4)
                      .frame(width: 300, height: 290)
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
    PauseGameView()
}
