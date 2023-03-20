//
//  MyListView.swift
//  ReminderApp
//
//  Created by mert can çifter on 13.03.2023.
//

import SwiftUI

struct MyListView: View {
    
    let myLists: [MyList]
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        if myLists.isEmpty {
            Spacer()
            Text("No Reminders found")
        } else {
            ScrollView(showsIndicators: true) {
                ForEach(myLists) { myList in
                    
                    NavigationLink {
                        MyListDetailView(vm: MyListDetailViewModel(context: viewContext, myList: myList))
                            .navigationTitle(myList.name)
                    } label: {
                        VStack {
                            MyListCellView(myList: myList)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading], 10)
                                .font(.title3)
                                .foregroundColor(colorScheme == .dark ? Color.offWhite: Color.darkGray)
                            Divider()
                        }
                    }
                    .listRowBackground(colorScheme == .dark ? Color.darkGray : Color.offWhite)
                }
            }
        }
    }
}
