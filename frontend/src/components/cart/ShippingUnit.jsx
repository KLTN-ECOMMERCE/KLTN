import React, { useState, useEffect } from "react";
import CheckoutSteps from "./CheckoutSteps";
import MetaData from "../layout/MetaData";
import { useNavigate } from "react-router-dom";
import { useGetShippingQuery } from "../../redux/api/shipping";
import { useSelector, useDispatch } from "react-redux";
import { saveShippingInfo } from "../../redux/features/cartSlice";

const ShippingUnit = () => {
  const { data, isLoading, error } = useGetShippingQuery();
  const navigate = useNavigate();
  const dispatch = useDispatch();
  const { shippingInfo, cartItems } = useSelector((state) => state.cart);

  const { address, city, phoneNo, zipCode, country } = shippingInfo;
  const handleChangePage = () => {
    dispatch(
      saveShippingInfo({ address, city, phoneNo, zipCode, country, shipping })
    );

    navigate("/confirm_order");
  };
  const [code, setCode] = useState();
  const [shippingUnit, setShippingUnit] = useState();
  const [shipping, setShipping] = useState({
    shippingUnit,
    code,
  });
  const handleClick = (item) => {
    setCode(item.code);
    setShippingUnit(item._id);
  };
  useEffect(() => {
    setShipping({
      shippingUnit,
      code,
    });
  }, [code, shippingUnit]);
  return (
    <>
      <MetaData title={"Shipping Info"} />
      <CheckoutSteps shipping shippingunit />

      <div className="container mx-auto p-4">
        <h2 className="text-2xl font-bold mb-4">Shipping Information</h2>

        <div className="shipping-container flex flex-wrap">
          {/* Map through cartItems to render each product's shipping information */}
          {data &&
            data.shipping.map((item) => (
              <div
                className="bg-white shadow-md rounded-lg overflow-hidden border shipping-card p-4 flex flex-col items-center"
                onClick={() => handleClick(item)}
              >
                <img
                  className="w-48 object-cover mb-4"
                  src={item.image}
                  alt={item.name}
                />
                <h3 className="text-lg font-semibold mb-2">{item.name}</h3>
                <h3 className="text-lg font-semibold mb-2">
                  Price: {item.price}
                </h3>
                <p className="text-gray-600 mb-4">{item.description}</p>
              </div>
            ))}
        </div>
        <button onClick={handleChangePage}>next</button>
      </div>
    </>
  );
};

export default ShippingUnit;
