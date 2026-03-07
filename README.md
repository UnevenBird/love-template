# LOVE Template
Simple template for a game made with the [LÖVE](https://love2d.org/) framework

#### What the template includes
- A scene system that supports scene switching/destruction/suspension
- An event listeners system over LÖVE callbacks: keyboard, mouse, touch, and other events can be subscribed to through handlers
- Regular `update(dt)` and fixed `update_fixed(dt)` with a constant step
- A small set of useful functions, such as clamp, lerp, split, etc., including a simple class implementation
- A ready-made starting scene as an example
- A logging library by rxi

#### Quick start:
* Clone the repository:
```bash
git clone https://github.com/UnevenBird/love-template.git
```
* Download LÖVE 11.5 from the official website: [love2d.org](https://github.com/love2d/love/releases/download/11.5/love-11.5-win64.zip) and unpack it into the `bin` folder in the repository root
* Open the project folder in VS Code
* Run the `Run` task via `Terminal: Run Test Task` in VSCode
-- or --
* Run love manually, specifying the current folder:
```bash
./bin/love --console .
```