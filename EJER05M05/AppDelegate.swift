//
//  AppDelegate.swift
//  EJER05M05
//
//  Created by Erick Ayala Delgadillo on 02/04/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Validar CON UNA LLAVE EN USERDEFAULTS si ya se descargó la info
        let ud = UserDefaults.standard
        let bandera = (ud.value(forKey: "infoDescargada") as? Bool) ?? false
        if !bandera {
            obtenerMascotas()
        }
        return true
    }
    
    /*** Se obtienen las mascotas  **/
    func obtenerMascotas(){
        if let url = URL(string: "https://my.api.mockaroo.com/mascotas.json?key=ee082920") {
            do {
                let bytes = try Data(contentsOf: url)
                let tmp   = try JSONSerialization.jsonObject(with: bytes) as! [[String:Any]]
                //llenar la base de datos
                llenarBD(tmp)
                //setter userdefaults
                let ud = UserDefaults.standard
                ud.set(true, forKey: "infoDesscargada")
                ud.synchronize()
            }
            catch {
                print ("no se pudo obtener la información desde el endpoint de mascotas \(error.localizedDescription)")
            }
        }
    }

    // MARK: UISceneSession Lifecycle
    
    /** Llenado de la base de datos */
    func llenarBD(_ arreglo: [[String:Any]]){
        //Paso N. 0: requerimos la descripción de la entidad
        guard let entidad = NSEntityDescription.entity(forEntityName: "Mascota", in: persistentContainer.viewContext)
        else {
            return
        }
        for dict in arreglo {
            //Paso N. 1: Crear objeto Mascota
            let m = NSManagedObject(entity: entidad, insertInto: persistentContainer.viewContext) as! Mascota
            //Paso N. 2: Setear las propiedades del objeto
            m.inicializaCon(dict)
            //Paso N. 3: Salvar el objeto
            saveContext()
        }
    }
    
    /** Obtener todas las mascotas  **/
    func obtenerTodasLasMascotas() -> [Mascota] {
        var resulset = [Mascota]()
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Mascota")
        do {
            let tmp = try persistentContainer.viewContext.fetch(request)
            resulset = tmp as! [Mascota]
        }
        catch{
            print ("fallo el request \(error.localizedDescription)")
        }
        return resulset
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "EJER05M05")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

