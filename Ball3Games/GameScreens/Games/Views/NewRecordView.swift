import SwiftUI

struct NewRecordView: View {
    
    var best: Int
    
    var body: some View {
        VStack {
            VStack {
                Text("New\nRecord")
                    .foregroundColor(.white)
                    .font(.custom("JosefinSansRoman-Bold", size: 32))
                    .shadow(color: .black, radius: 1, x: -1)
                    .shadow(color: .black, radius: 1, x: 1)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Text("Best:")
                    .foregroundColor(.white)
                    .font(.custom("JosefinSansRoman-Bold", size: 24))
                    .shadow(color: .black, radius: 1, x: -1)
                    .shadow(color: .black, radius: 1, x: 1)
                    .multilineTextAlignment(.center)
                
                Text("\(best)")
                    .foregroundColor(.white)
                    .font(.custom("JosefinSansRoman-Bold", size: 52))
                    .shadow(color: .black, radius: 1, x: -1)
                    .shadow(color: .black, radius: 1, x: 1)
                    .multilineTextAlignment(.center)
                
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
            .frame(width: 300, height: 450)
            .background(
                RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                    .fill(Color.init(red: 157/255, green: 19/255, blue: 205/255))
                    .frame(width: 300, height: 480)
            )
            .background(
                RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                    .stroke(.white, lineWidth: 4)
                    .frame(width: 300, height: 480)
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
    NewRecordView(best: 42)
}
