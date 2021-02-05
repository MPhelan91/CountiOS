import SwiftUI

struct TopOffButton: View {
    let action: (() -> Void)
    
    var body: some View {
        Button(action:self.action){
            VStack{
                Text("Top").font(.system(size: 13)).offset(x:-10, y: 4)
                Text("Off").font(.system(size: 13)).offset(x:10, y:-4)
            }
        }.buttonStyle(BorderlessButtonStyle())
    }
}

struct TopOffButton_View: PreviewProvider {
    static var previews: some View {
        TopOffButton(action: {})
    }
}
