# ams

Is a turnkey financial management and stock control application created for a structure that I will not disclose the name

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
#

creer un ficher env

```
.env
```

vous allez trouvez dans le fichier `exemple.env` le contenue du fichier `.env`

## State Management 






  


