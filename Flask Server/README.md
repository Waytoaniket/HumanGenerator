<br />
<p align="center">   
  <h1 align="center">Flask Server</h1>
</p>

<!-- GETTING STARTED -->
## Getting Started

#### Create a Virtual Environment.
- Installing virtualenv package of Python.
```
pip install virtualenv
```
- Creating a virtual environment named 'venv'.
```
virtualenv venv
```
- Activate the environment (Windows).
```
venv\Scripts\activate
```

#### Installing Dependencies in Virtual Environment
- Make sure environment is activated. `(env)`
- Using Requirements File. **(Recommended)**
```
pip install -r requirements.txt
```
#### Hosting Flask Server
- Execute Following Command in terminal
```
set FLASK_APP=humanGenerator.py
```
```
set FLASK_ENV=development
```
```
FLASK run --host=<Your IP Address> (Make Sure to change Url in Flutter API)
```
