import React from "react";
import { BentoGridDemo } from "./layout/BentoGridDemo";
import { ImagesSliderDemo } from "./layout/ImagesSliderDemo";
import MetaData from "./layout/MetaData";
export const Home = () => {
  return (
    <>
      <MetaData title="Buy best product online" />
      <div>
        <ImagesSliderDemo />
        <BentoGridDemo />
      </div>
    </>
  );
};
