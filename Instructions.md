# Consignes pour le développement de l'application SpaceX App (Flutter)

## Contexte du projet
Développer une application mobile Flutter permettant de consulter les lancements SpaceX via leur API publique.

## API à utiliser
- **Endpoint principal** : `https://api.spacexdata.com/v4/launches`
- **Documentation** : https://github.com/r-spacex/SpaceX-API/tree/master/docs

## Fonctionnalités requises

### 1. Liste des lancements
- Récupérer et afficher les derniers lancements SpaceX depuis l'API
- Proposer deux modes d'affichage :
  - Vue liste
  - Vue grille
- Implémenter un bouton permettant de basculer entre les deux vues

### 2. Détail d'un lancement
Afficher les informations suivantes pour chaque lancement :
- Nom du lancement
- Détails/description
- Date du lancement
- Résultat (succès/échec avec raison de l'échec si applicable)
- Patch (images du lancement)
- Articles liés
- Informations sur la fusée utilisée

### 3. Onboarding utilisateur
- Créer un parcours d'onboarding pour présenter l'application
- L'onboarding doit contenir **au minimum 3 écrans/onglets** informatifs
- Doit s'afficher **uniquement au premier lancement** de l'application
- Les différents onglets doivent être des widgets (pas des pages séparées)
- Expliquer clairement les fonctionnalités de l'application

### 4. Système de favoris
- Permettre à l'utilisateur d'ajouter des lancements en favoris
- Persister les favoris localement (utiliser SharedPreferences ou équivalent)

## Architecture et bonnes pratiques

### Structure du code
- Organiser le projet avec une architecture claire (ex: feature-based ou layered)
- Séparer les responsabilités :
  - Services API (communication réseau)
  - Models (classes de données)
  - Screens/Pages (interface utilisateur)
  - Widgets réutilisables
  - Gestion d'état (Provider, Riverpod, Bloc, ou autre)

### Qualité du code
- Éviter la duplication de code
- Utiliser des noms de variables/fonctions explicites
- Commenter les parties complexes si nécessaire
- Respecter les conventions de nommage Dart/Flutter

### Navigation
- Implémenter une navigation fluide entre les pages
- Utiliser Navigator ou un package de routing (go_router, auto_route, etc.)

### Communication API
- Créer un service dédié pour les appels API
- Gérer correctement les erreurs réseau
- Parser correctement les réponses JSON en objets Dart
- Gérer les états de chargement

## Design et UX

### Principes
- Interface utilisateur **libre et créative**
- Le design doit rester **homogène** dans toute l'application
- S'appuyer sur des **patterns standards** (Material Design ou Cupertino)
- Assurer une bonne expérience utilisateur

### Recommandations
- Utiliser des composants Material 3 natifs
- Implémenter des animations fluides pour les transitions
- Gérer les états vides, de chargement et d'erreur
- Rendre l'application responsive
- Décomposer les widgets en composants indépendant dans leur fichier dédié sous /ui/widgets
- Les pages doivent se trouver dans /ui/screens

## Packages suggérés
- `http` ou `dio` : pour les appels API
- `shared_preferences` : pour persister les données localement
- `provider`, `riverpod` ou `bloc` : pour la gestion d'état
- `cached_network_image` : pour le cache des images
- `intl` : pour le formatage des dates
- `smooth_page_indicator` : pour l'onboarding

## Critères d'évaluation
1. **Respect des exigences fonctionnelles** : toutes les fonctionnalités doivent être implémentées
2. **Qualité du code** : éviter la duplication, bon nommage, lisibilité
3. **Architecture** : structure claire et maintenable
4. **Navigation** : transitions fluides et logiques entre les pages
5. **Communication API** : bonne gestion des appels réseau et des données