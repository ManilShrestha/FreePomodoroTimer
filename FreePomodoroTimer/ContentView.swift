


import SwiftUI
import AppKit

struct ContentView: View {
    @State private var timerValue = "25:00"
//    @State private var selectedMode: String?
    @State private var selectedMode: String = "Focus"
    @State private var remainingTime = 1500 // 25 minutes * 60 seconds
    @State private var timer: Timer?
    @State private var isTimerRunning = false
    @State private var showAlert = false
    @State private var timeSlots = [25*60, 5*60, 15*60]
    @State private var focusCounter = 0
    @State private var message: String = ""
    
    var body: some View {
        VStack {
            Text(timerValue)
                .font(.system(size: 48))
                .padding(.bottom, 1)

            HStack(spacing: 20) {
                Button(isTimerRunning ? "Pause" : "Start") {
                        if isTimerRunning {
                            stopTimer()
                            isTimerRunning=false
                        } else {
                            startTimer()
                            isTimerRunning=true
                        }
                    }
                    .buttonStyle(.bordered)
                .padding()
                .font(.title2) // Makes the font larger

                Button("Stop") {
                    if selectedMode == "Focus"{
                        remainingTime=timeSlots[0]
                    }else if selectedMode == "Short Break"{
                        remainingTime=timeSlots[1]
                    }else{
                        remainingTime=timeSlots[2]
                    }
                    timerValue=timeString(from: remainingTime)
                    isTimerRunning=false
                    stopTimer()
                    
                }
                .buttonStyle(.bordered)
                .padding()
                .font(.title2)
            }

            
            HStack(spacing: 10) {
                    Button("Focus         ") {
                        setMode(index: 0)
                    }
                    .buttonStyle(.bordered)
                    .background(selectedMode == "Focus" ? Color.blue : Color.clear)
                    .foregroundColor(selectedMode == "Focus" ? .white : .blue)
                
                    Button("Short Break") {
                        setMode(index: 1)
                    }
                    .buttonStyle(.bordered)
                    .background(selectedMode == "Short Break" ? Color.blue : Color.clear)
                    .foregroundColor(selectedMode == "Short Break" ? .white : .blue)

                    Button("Long Break") {
                        setMode(index: 2)
                    }
                    .buttonStyle(.bordered)
                    .background(selectedMode == "Long Break" ? Color.blue : Color.clear)
                    .foregroundColor(selectedMode == "Long Break" ? .white : .blue)
            }
            .padding(.top, 5)
        }
        .alert(isPresented: $showAlert) { // Alert presentation
            Alert(title: Text("Pomodoro"), message: Text(message), dismissButton: .default(Text("OK")))
        }
        .frame(width: 300, height: 140)
        .padding()
        .border(Color.gray, width: 1)
//        .preferredColorScheme(.dark)
    }
    
    func timeString(from totalSeconds: Int) -> String {
            let minutes = totalSeconds / 60
            let seconds = totalSeconds % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
        
    func startTimer() {
        stopTimer() // Stop any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
                timerValue = timeString(from: remainingTime)
            } else {
                stopTimer()
                
                // Play sound after the time's up
                playSound(name: "chime-sound-7143.mp3", type: "mp3")
                
                showAlert = true // Show alert when time is up
                if selectedMode=="Focus"{
                    focusCounter+=1
                    if focusCounter==3{
                        message = "Great job! 3 focus modes completed. Take a long break."
                        focusCounter=0
                        setMode(index: 2)
                    }else{
                        message = "Bravo! \(focusCounter) focus mode(s) completed. Time for a short break."
                        setMode(index: 1)
                    }
                }else if selectedMode=="Short Break"{
                    message = "Short break completed. Back to the grind!"
                    setMode(index: 0)
                }else{
                    message = "Hope you are rested. Now FOCUS!"
                    setMode(index: 0)
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func playSound(name: String, type: String) {
            if let sound = NSSound(named: name) {
                sound.play()
            } else {
                // Handle the error: sound file not found
                print("Sound file not found.")
            }
        }
    
    func setMode(index: Int){
        // Index 0 is for focus mode, 1 is for short break and 2 is for long break
        let arrayMode = ["Focus", "Short Break", "Long Break"]
        selectedMode = arrayMode[index]
        stopTimer()
        remainingTime = timeSlots[index]
        timerValue = timeString(from: remainingTime)
        isTimerRunning = false
    }
}

struct PomodoroTimerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
