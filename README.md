# ams
![1JLDBPvTbcL8_1024_500](https://github.com/saliemmanuel/ams/blob/main/screenshot/screen_1.png)
##
![1JLDBPvTbcL8_1024_500](https://github.com/saliemmanuel/ams/blob/main/screenshot/screen_2.png)

Welcome to the AMS inventory management application! 🚀
        
Our app was designed to simplify and optimize inventory management, providing an efficient and user-friendly solution for multi-store businesses. Whether you own a small business or a chain store, our app makes it easy to manage your inventory with precision and simplicity.
        
Main Features :
        
📦 Multi-store management: Centralize and organize the stocks of several stores within a single platform. AMS enables transparent and efficient management, giving you a complete overview of each location's inventory.
        
🔄 Real-Time Updates: Thanks to real-time updates, always be informed of the current status of your stocks. Avoid stock-outs and maximize operational efficiency.
        
🔒 Security and Privacy: We understand the importance of data security. AMS incorporates robust security features to ensure your information is kept private and your data protected.
        
Developed by: SALI EMMANUEL

## Getting Started
```
flutter pub get 
```
## Firebase structure

### users
```
users 
    | - email
    | - grade
    | - id
    | - idAdmin
    | - messageToken
    | - nom 
    | - prenom
    | - status
    | - telephone
    | - CreateAt
```
### boutique
```
boutique 
    | - dateCreation
    | - id
    | - idAdmin
    | - nomBoutique
    | - quartierBoutique
    | - vendeur: []
    | - villeBoutique
  
```
### article
```
article 
    | - codeEnregistrement
    | - createAt 
    | - designation
    | - id
    | - idAdmin
    | - nomBoutique
    | - prixAchat
    | - prixNonAuto
    | - prixVente
    | - stockActuel
    | - stockCritique
    | - stockNormal
```

### facture

```
facture
    | - createAt 
    | - facture : []
    | - idBoutique
    | - netPayer
    | - nom
    | - telephone
    | - vendeur : Vendeur
```

### code

```
code
    | - hash
    | - id
    | - idUser
```
#

creer un ficher env

```
.env
```

vous allez trouvez dans le fichier `exemple.env` le contenue du fichier `.env`
## organisation des dossier 
- __assets/image/__ 

## State Management 






  


