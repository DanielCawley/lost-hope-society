import React from "react"
import classes from "./App.module.css"
import wallpaper from "./images/wallpaper.jpg"

import Header from "./components/Header"


function App() {
  return (
    <div style={{
      backgroundImage: `url(${wallpaper})`, backgroundRepeat: "no-repeat", backgroundSize: "cover", height: "100vh", width: "100vw"
    }}>

      <Header />

    </div>
  )
}

export default App;