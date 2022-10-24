//
//  ClassroomController.swift
//  cyberApp
//
//  Created by Salomon Martinez on 04/10/22.
//

import Foundation

enum ClassroomError: Error, LocalizedError{
    case itemNotFound
}
class ClassroomController{
    let baseString = "http://20.38.4.246:8080/api/espacios/"
    
    
    func fetchReservas() async throws->Classrooms{
        let reservasURL = URL(string: baseString + "?format=json")!
        let (data, response) = try await URLSession.shared.data(from: reservasURL)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ClassroomError.itemNotFound
        }
        let jsonDecoder = JSONDecoder()
        let reservas = try? jsonDecoder.decode(Classrooms.self, from: data)
        return reservas!
        
    }
    
    
    func deleteReserva(deleteReserva:Classroom) async throws -> Void{
        let deleteString = baseString + String(deleteReserva.id) + "/"
        let deleteURL = URL(string: deleteString)!
        var request = URLRequest(url: deleteURL)
        request.httpMethod = "DELETE"
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 else { throw ClassroomError.itemNotFound}
    }
   
    func insertReserva(nuevareserva:Classroom)async throws->Void{
        let insertURL = URL(string: baseString)!
        var request = URLRequest(url: insertURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(nuevareserva)
        request.httpBody = jsonData
        let s = String(data: jsonData!, encoding: .utf8)!
        print("json")
        print(s)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else { throw ClassroomError.itemNotFound}
    }
    
    func updateReserva(updateReserva:Classroom) async throws{
        let updateString = baseString + String(updateReserva.id) + "/"
        let updateURL = URL(string: updateString)!
        var request = URLRequest(url: updateURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(updateReserva)
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw ClassroomError.itemNotFound}
    }
    
    
}
