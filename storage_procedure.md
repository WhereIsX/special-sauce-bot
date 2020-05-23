1. read from file
  - gifs = File.open('gifs.json').read
  - (then close file)

2. add to `gifs`:
  - gifs[key] = value

3. write to file ?
  - `json.dump(File)`
  - 
