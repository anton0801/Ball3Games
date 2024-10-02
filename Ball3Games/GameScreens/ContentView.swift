import SwiftUI

func getFormattedDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter.string(from: date)
}

class LivesViewModel: ObservableObject {
    @Published var lives: Int = UserDefaults.standard.integer(forKey: "lives") {
        didSet {
            UserDefaults.standard.set(lives, forKey: "lives")
        }
    }
}

class BonusViewModel: ObservableObject {
    
    @Published var bonusAvailable = false
    
    init() {
        bonusAvailable = checkBonusAvailable()
    }
    
    private func checkBonusAvailable() -> Bool {
        let lastClaimBonusDate = UserDefaults.standard.string(forKey: "last_date_claim") ?? ""
        if lastClaimBonusDate.isEmpty {
            return true
        }
        return lastClaimBonusDate != getFormattedDate(Date())
    }
    
}

struct ContentView: View {
    
    @StateObject var livesViewModel: LivesViewModel = LivesViewModel()
    @StateObject var recordsViewModel: RecordsViewModel = RecordsViewModel()
    @StateObject var bonusViewModel = BonusViewModel()
    @State var selection: Int = 0
    @State var currentBackground = "main_background_bg_1"
    
    @State var claimBonus = false
    @State var settingsVisible = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if claimBonus {
                    VStack {
                        Text("Bonus!")
                            .foregroundColor(.white)
                            .font(.custom("JosefinSansRoman-Bold", size: 62))
                            .shadow(color: .black, radius: 1, x: -1)
                            .shadow(color: .black, radius: 1, x: 1)
                        
                        Image("gift")
                            .padding(.top)
                        
                        Button {
                            withAnimation(.linear(duration: 0.5)) {
                                claimBonus = false
                            }
                        } label: {
                            Image("bt-take")
                        }
                        .padding(.top)
                    }
                    .onAppear {
                        UserDefaults.standard.set(getFormattedDate(Date()), forKey: "last_date_claim")
                        bonusViewModel.bonusAvailable = false
                        livesViewModel.lives += 10
                    }
                } else {
                    VStack {
                        HStack {
                            Button {
                                if bonusViewModel.bonusAvailable {
                                    withAnimation(.linear(duration: 0.5)) {
                                        claimBonus = true
                                    }
                                }
                            } label: {
                                if bonusViewModel.bonusAvailable {
                                    Image("bt-bonus")
                                } else {
                                    Image("bt-bonus")
                                        .opacity(0.6)
                                }
                            }
                            
                            Spacer()
                            
                            Image("live")
                            Text("\(livesViewModel.lives)")
                                .foregroundColor(.white)
                                .font(.custom("JosefinSansRoman-Bold", size: 24))
                                .shadow(color: .black, radius: 1, x: -1)
                                .shadow(color: .black, radius: 1, x: 1)
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.linear) {
                                    settingsVisible = true
                                }
                            } label: {
                                Image("bt-settings")
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Text("Name\nGame")
                            .foregroundColor(.white)
                            .font(.custom("JosefinSansRoman-Bold", size: 62))
                            .shadow(color: .black, radius: 1, x: -1)
                            .shadow(color: .black, radius: 1, x: 1)
                        
                        Spacer()
                        
                        TabView(selection: $selection) {
                            VStack {
                                Text("Record: \(recordsViewModel.game1Record)")
                                    .foregroundColor(.white)
                                    .font(.custom("JosefinSansRoman-Bold", size: 24))
                                    .shadow(color: .black, radius: 1, x: -1)
                                    .shadow(color: .black, radius: 1, x: 1)
                                    .padding(.bottom)
                                Image("game_1")
                                NavigationLink(destination: CatchBallsFirstGameView()
                                    .environmentObject(recordsViewModel)
                                    .environmentObject(livesViewModel)) {
                                    Image("play_btn")
                                }
                                .padding(.top)
                            }
                            .tag(0)
                            
                            VStack {
                                Text("Record: \(recordsViewModel.game2Record)")
                                    .foregroundColor(.white)
                                    .font(.custom("JosefinSansRoman-Bold", size: 24))
                                    .shadow(color: .black, radius: 1, x: -1)
                                    .shadow(color: .black, radius: 1, x: 1)
                                    .padding(.bottom)
                                Image("game_2")
                                NavigationLink(destination: CatchBallsSecondGameView()
                                    .environmentObject(recordsViewModel)
                                    .environmentObject(livesViewModel)) {
                                    Image("play_btn")
                                }
                                .padding(.top)
                            }
                            .tag(1)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                }
                
                if settingsVisible {
                    SettingsDialogView(settingsPopupVisible: $settingsVisible)
                }
            }
            .onChange(of: selection) { newValue in
                withAnimation(.linear(duration: 0.4)) {
                    currentBackground = "main_background_bg_\(newValue + 1)"
                }
            }
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "first_added_lives") {
                    livesViewModel.lives = 10
                    UserDefaults.standard.set(true, forKey: "first_added_lives")
                }
            }
            .background(
                Image(currentBackground)
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct SettingsDialogView: View {
    
    @Binding var settingsPopupVisible: Bool
    @State var musicState = UserDefaults.standard.integer(forKey: "music_state")
    @State var soundsState = UserDefaults.standard.integer(forKey: "sounds_state")
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Text("Music")
                        .foregroundColor(.white)
                        .font(.custom("JosefinSansRoman-Bold", size: 32))
                        .shadow(color: .black, radius: 1, x: -1)
                        .shadow(color: .black, radius: 1, x: 1)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if musicState == 1 {
                                musicState = 0
                            } else {
                                musicState = 1
                            }
                        }
                    } label: {
                        if musicState == 1 {
                            Image("load_full")
                        } else {
                            Image("load_none")
                        }
                    }
                }
                
                Spacer().frame(height: 50)
                
                VStack {
                    Text("Sounds")
                        .foregroundColor(.white)
                        .font(.custom("JosefinSansRoman-Bold", size: 32))
                        .shadow(color: .black, radius: 1, x: -1)
                        .shadow(color: .black, radius: 1, x: 1)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if soundsState == 1 {
                                soundsState = 0
                            } else {
                                soundsState = 1
                            }
                        }
                    } label: {
                        if soundsState == 1 {
                            Image("load_full")
                        } else {
                            Image("load_none")
                        }
                    }
                }
                
                Button {
                    withAnimation(.linear(duration: 0.5)) {
                        settingsPopupVisible.toggle()
                    }
                } label: {
                    Image("bt-Okey")
                }
                .padding(.top, 24)
            }
            .background(
                Image("popup_back")
                    .resizable()
                    .frame(width: 300, height: 400)
            )
        }
        .onChange(of: musicState) { new in
            UserDefaults.standard.set(new, forKey: "music_state")
        }
        .onChange(of: soundsState) { new in
            UserDefaults.standard.set(new, forKey: "sounds_state")
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
    ContentView()
}
