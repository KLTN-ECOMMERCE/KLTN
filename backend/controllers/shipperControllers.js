import catchAsyncErrors from "../middlewares/catchAsyncErrors.js";
import Order from "../models/order.js";
import Shipper from "../models/shipper.js";
import ErrorHandler from "../utils/errorHandler.js";
// get order by shipping unit
export const getOrderByShippingUnit = catchAsyncErrors(
  async (req, res, next) => {
    const userId = req.user._id;

    try {
      const shipper = await Shipper.findOne({ user: userId });
      const shippingUnit = await shipper.shippingUnit.shippingUnitId;
      if (!shippingUnit) {
        return res.status(400).json({ error: "Shipping unit is required" });
      }

      const orders = await Order.find({
        "shippingInfo.shipping.shippingUnit": shippingUnit,
        orderStatus: "Shipped",
      });

      if (!orders.length) {
        return res
          .status(404)
          .json({ message: "No orders found for the given shippingUnit" });
      }

      res.status(200).json({ orders });
    } catch (error) {
      res.status(500).json({ error: "Internal server error" });
    }
  }
);

// add shipper to shipping unit
export const addShippertoShippingUnit = catchAsyncErrors(
  async (req, res, next) => {
    const { shippingUnit } = req.body;
    const shipper = await Shipper.create({
      shippingUnit,
      user: req.user._id,
    });
    res.status(200).json({
      shipper,
    });
  }
);
