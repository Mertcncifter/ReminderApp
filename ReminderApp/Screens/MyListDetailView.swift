//
//  MyListDetailView.swift
//  ReminderApp
//
//  Created by mert can çifter on 13.03.2023.
//

import SwiftUI

struct MyListDetailView: View {
    
    @State private var openAddReminder: Bool = false
    @State private var title: String = ""
    
    @ObservedObject private var myListDetailViewModel: MyListDetailViewModel
                
    private var isFormValid: Bool {
        !title.isEmpty
    }
    
    init(vm: MyListDetailViewModel) {
        myListDetailViewModel = vm
    }
    
    var body: some View {
        
        VStack {
           
            ReminderListView(reminders: myListDetailViewModel.reminders)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Yeni Hatırlatıcı") {
                    openAddReminder = true
                }
            }
        }
        .textFieldAlert(isPresented: $openAddReminder, title: "Yeni Hatırlatıcı", text: $title, placeholder: "Başlık...", action: { text in
            if isFormValid {
                myListDetailViewModel.addReminder(myList: myListDetailViewModel.myList, title: title)
            }
        })
    }
}

struct TextFieldAlert: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    @Binding var text: String
    let placeholder: String
    let action: (String) -> Void
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content
                .disabled(isPresented)
            if isPresented {
                VStack {
                    Text(title).font(.headline).padding()
                    TextField(placeholder, text: $text).textFieldStyle(.roundedBorder).padding()
                    Divider()
                    HStack{
                        Spacer()
                        Button(role: .cancel) {
                            withAnimation {
                                isPresented.toggle()
                            }
                        } label: {
                            Text("Kapat")
                        }
                        Spacer()
                        Divider()
                        Spacer()
                        Button() {
                            action(text)
                            withAnimation {
                                isPresented.toggle()
                            }
                        } label: {
                            Text("Kaydet")
                        }
                        Spacer()
                    }
                }
                .background(.background)
                .frame(width: 300, height: 200)
                .cornerRadius(20)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.quaternary, lineWidth: 1)
                }
            }
        }
    }
}

extension View {
    public func textFieldAlert(
        isPresented: Binding<Bool>,
        title: String,
        text: Binding<String>,
        placeholder: String = "",
        action: @escaping (String) -> Void
    ) -> some View {
        self.modifier(TextFieldAlert(isPresented: isPresented, title: title, text: text, placeholder: placeholder, action: action))
    }
}

/*

struct MyListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = CoreDataProvider.shared.persistentContainer.viewContext

        NavigationView {
            MyListDetailView(vm: MyListDetailViewModel(context: viewContext, myList: PreviewData.myList))
                .environment(\.managedObjectContext, viewContext)
        }
        
    }
}
*/
