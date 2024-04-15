"use client";
import React, { useState } from "react";
import {
  HoveredLink,
  Menu,
  MenuItem,
  ProductItem,
} from "../ui/navbar-menu.tsx";
import { cn } from "../../utils/cn.js";
export function NavbarDemo() {
  return (
    <div className="relative w-full flex items-center justify-center">
      <Navbar className="top-2" />
      <p className="text-black dark:text-white"></p>
    </div>
  );
}

function Navbar({ className }) {
  const [active, setActive] = useState(null);
  return (
    <div
      className={cn("fixed top-10 inset-x-0 max-w-2xl mx-auto z-50", className)}
    >
      <Menu setActive={setActive}>
        <MenuItem
          setActive={setActive}
          active={active}
          item="Services"
        ></MenuItem>
        <MenuItem
          setActive={setActive}
          active={active}
          item="Products"
        ></MenuItem>
        <MenuItem
          setActive={setActive}
          active={active}
          item="Pricing"
        ></MenuItem>
      </Menu>
    </div>
  );
}

export default Navbar;