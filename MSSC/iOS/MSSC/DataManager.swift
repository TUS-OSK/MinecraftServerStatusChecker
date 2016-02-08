//
//  DataManager.swift
//  MSSC
//
//  Created by wang on 2016/02/07.
//  Copyright © 2016年 wang. All rights reserved.
//

import Foundation

class SaveObject{
    internal var length: Int = 0
    internal var serverArray: [MinecraftServer] = []
    internal func add(server: MinecraftServer){
        serverArray.append(server)
        length += 1
    }
    internal func remove(index:Int){
        serverArray.removeAtIndex(index)
        length -= 1
    }
}
struct MinecraftServer {
    var name:String
    var host:String
    var port:String
}

class DataManager{
    
    private var serverdata: SaveObject = SaveObject()
    private var statusList: [StatusFormat] = []
    
    subscript(index: Int)->(server: MinecraftServer,status: StatusFormat){
        get{
            return (serverdata.serverArray[index],statusList[index])
        }
        set(value){
            serverdata.serverArray[index] = value.server
            statusList[index] = value.status
        }
    }
    
    var length: Int{
        get{
            return serverdata.length
        }
    }
    
    private static var _instance :DataManager?
    private var checker = MinecraftServerStatusChecker()
    
    static var instance :DataManager{
        get{
            if(_instance != nil){
                return _instance!
            }else{
                _instance = DataManager()
                return _instance!
            }
        }
    }
    
    init(){
        serverdata = load()
        updateStatus()
    }
    
    deinit{
        save()
    }
    
    func updateStatus(){
        statusList = checker.getAllStatus(serverdata.serverArray)
    }
    
    func add(server: MinecraftServer){
        serverdata.add(server)
        
        statusList = checker.updateStatus(serverdata.serverArray,statusList: statusList, index: length - 1)
        
        if(server.name == ""){
            let descripton = statusList.last?.description
            if((descripton != nil) && (descripton != "")){
                self[length - 1].server.name = (statusList.last?.description)!
            }else{
                self[length - 1].server.name = "Minecraft Server" + (statusList.last?.version.name)!
            }
        }
        
        save()
    }
    
    func save(){
        save(serverdata)
    }
    
    func save(data :SaveObject){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setObject(data.length, forKey: "length")
        
        for(var i = 0; i < data.length; i++){
            userDefaults.setObject(data.serverArray[i].name, forKey: "name" + String(i))
            userDefaults.setObject(data.serverArray[i].host, forKey: "host" + String(i))
            userDefaults.setObject(data.serverArray[i].port, forKey: "port" + String(i))
        }
    }
    
    func load()->SaveObject{
        serverdata = SaveObject()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        serverdata.length = userDefaults.integerForKey("length")
        
        for(var i = 0; i < serverdata.length; i++){
            let name = userDefaults.stringForKey("name" + String(i))
            let host = userDefaults.stringForKey("host" + String(i))
            let port = userDefaults.stringForKey("port" + String(i))
            serverdata.serverArray.append(MinecraftServer(name:name!,host:host!,port:port!))
        }
        return serverdata
    }
}