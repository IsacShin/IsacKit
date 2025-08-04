//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 7/8/25.
//

import Foundation
import SwiftData

@available(iOS 17.0, *)
@MainActor
final public class ISSwiftDataManager {

    private let container: ModelContainer
    private var context: ModelContext { container.mainContext }

    public static func makeShared(for model: any PersistentModel.Type) -> ISSwiftDataManager {
        return ISSwiftDataManager(model: model)
    }

    private init(model: any PersistentModel.Type) {
        do {
            self.container = try ModelContainer(for: model)
        } catch {
            fatalError("SwiftData 초기화 실패: \(error)")
        }
    }
    
    private func save() async {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    // MARK: - Create
    
    public func insert<T: PersistentModel>(_ object: T) async {
        context.insert(object)
        await save()
    }
    
    // MARK: - Update
    
    public func update<T: PersistentModel & Identifiable>(id: UUID, updateBlock: (T) -> Void) async where T.ID == UUID {
        let results = await fetch(with: #Predicate<T> { $0.id == id })
        guard let object = results.first else {
            print("Object not found.")
            return
        }

        updateBlock(object)
        await save()
    }

    // MARK: - Read
    
    public func fetchAll<T: PersistentModel>(
        sortedBy sortDescriptor: SortDescriptor<T>? = nil
    ) async -> [T] {
        var descriptor = FetchDescriptor<T>()
        if let sort = sortDescriptor {
            descriptor = FetchDescriptor<T>(sortBy: [sort])
        }
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Failed to fetch \(T.self): \(error)")
            return []
        }
    }
    
    /**
     # Example
     let manager = SwiftDataManager.makeShared(for: T.self)

     let predicate = #Predicate<T> {
     $0.column >= data
     }
     
     // 정렬 조건
     let sortDescriptor = SortDescriptor<T>(\.column, order: .reverse)
     
     // fetch 호출
     let results = await manager.fetch(with: predicate, sortDescriptors: [sortDescriptor])
     
     */
    public func fetch<T: PersistentModel>(
        with predicate: Predicate<T>,
        sortDescriptors: [SortDescriptor<T>] = []
    ) async -> [T] {
        let descriptor = FetchDescriptor<T>(
            predicate: predicate,
            sortBy: sortDescriptors
        )

        do {
            return try context.fetch(descriptor)
        } catch {
            print("Failed to fetch \(T.self) with predicate: \(error)")
            return []
        }
    }

    // MARK: - Delete
    
    public func delete<T: PersistentModel>(_ object: T) async {
        context.delete(object)
        await save()
    }
    
    public func deleteAll<T: PersistentModel>(_ objects: [T]) async {
        for object in objects {
            context.delete(object)
        }
        await save()
    }
}
