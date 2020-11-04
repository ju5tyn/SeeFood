<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
	<img src="https://i.ibb.co/bKYpPLm/Rectangle.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">SeeFood</h3>

  <p align="center">
	An app utilising CoreML to name objects from a camera feed
	<br />
	<br />
	<a href="https://github.com/ju5tyn/SeeFood">View Demo</a>
	·
	<a href="https://github.com/ju5tyn/SeeFood/issues">Report Bug</a>
	·
	<a href="https://github.com/ju5tyn/SeeFood/issues">Request Feature</a>
  </p>
</p>

<!-- ABOUT THE PROJECT -->
## About The Project
<img src="https://i.ibb.co/KLxzb2W/Thumb-Copy.png" alt="Logo">

Inspired by one of the episodes of the HBO Series 'Silicon Valley', this app uses CoreML to name images input by the user.


<!-- GETTING STARTED -->
## Installation

Setting up and building the project locally requires a few prerequisites.

1. Install CocoaPods if not already installed
```sh
sudo gem install cocoapods
```
2. Clone the repo
```sh
git clone https://github.com/ju5tyn/SeeFood.git
```
3. Install CocoaPod packages in project directory 
```sh
pod install
```

4. Download an MLModel to use with the app. 

[Some useful models can be found here](https://developer.apple.com/machine-learning/models/)

5. Move .mlmodel file to project, and declare in ViewController.swift

```sh
func detect(image: CIImage){

guard let model = try? VNCoreMLModel(for: [PUT MODEL NAME HERE](configuration: MLModelConfiguration()).model) else {
	fatalError("Broken coreml")
}

...
```

The project will now be fully usable.

_NOTE: App will only function on physical iOS devices, due to Simulator not having access to a camera._


<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/ju5tyn/SeeFood/issues) for a list of proposed features (and known issues).


<!-- CONTACT -->
## Contact

Email: justynlive@gmail.com

My Website and Portfolio: [justynhenman.com](https://justynhenman.com)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* [LTMorphingLabel](https://github.com/lexrus/LTMorphingLabel)
* [Silicon Valley](https://www.imdb.com/title/tt2575988/)
