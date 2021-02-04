//
//  ClipBoardVM.swift
//  Count
//
//  Created by Michael Phelan on 2/2/21.
//  Copyright © 2021 MichaelPhelan. All rights reserved.
//

import CoreData

class ClipBoardImpl: ObservableObject{
    private let context: NSManagedObjectContext
    @Published var clipBoard: [LogEntry]
    
    init(context: NSManagedObjectContext){
        self.context = context
        do{
            let cb = try context.fetch(ClipBoard.fetchRequest())
            self.clipBoard = cb.count > 0 ? (cb.first as! ClipBoard).entriesAsArray : []
        } catch {
            self.clipBoard = []
        }
    }
    
    public func copyToClipBoard(entries:[LogEntry]){
        self.clipBoard = entries;
        deleteClipBoardInCoreData()
        saveClipBoardInCoreData()
    }
    
    public func deleteClipBoard(){
        self.clipBoard = [];
        deleteClipBoardInCoreData()
    }
    
    private func deleteClipBoardInCoreData(){
        do{
            let cb = try context.fetch(ClipBoard.fetchRequest()) as! [NSManagedObject]
            cb.forEach({x in context.delete(x)})
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func saveClipBoardInCoreData(){
        do{
            let newCB = ClipBoard(context: self.context)
            newCB.addToEntries(NSSet(array:clipBoard))
            try context.save()
        } catch {
            print(error)
        }
    }
}
