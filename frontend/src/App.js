import "./App.css";
import Header from "./components/layout/Header";
import Footer from "./components/layout/Footer";
import { Home } from "./components/Home";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
function App() {
  return (
    <Router>
      <div className="scroll-smooth"></div>
      <Header />
      <div>
        <Routes>
          <Route path="/" element={<Home />} />
        </Routes>
      </div>

      <Footer />
    </Router>
  );
}

export default App;
