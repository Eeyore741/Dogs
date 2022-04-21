# Dogs
Project dispaly collection of dog breeds images with transfer into detail page on select

[View preview](https://thumbs.gfycat.com/DecentFailingBillygoat-mobile.mp4)


## Description
1. App defines own requirements for models as `CollectionItem`. Collection and detail controllers rely on it.

2. App defines abstractions of `dog.ceo` domain.

3. App conforms `dog.ceo` abstractions to own requirements of `CollectionItem` and list providers, working independently from implementation, relying on protocols.


## Features
* Code based layout (no .xib/.nib, no Storyboards)

* MVVM

* Collection infinite scroll

* Collection refresh action

* Random text generation for breed description

* Handling of remote connection issues

* Unit tests covering models public interfaces


## Requirements
* Xcode >= 13.2.1

* iOS >= 15.2 