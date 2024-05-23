import catchAsyncErrors from "../middlewares/catchAsyncErrors.js";
import Order from "../models/order.js";
import Shipper from "../models/shipper.js";
import User from "../models/user.js";
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
    const { shippingUnit, user } = req.body;
    // const user = await user.findOne(req.user._id)
    const shipper = await Shipper.create({
      shippingUnit,
      user,
    });

    const users = await User.findByIdAndUpdate(
      user,
      { role: "shipper" },
      {
        new: true,
      }
    );

    res.status(200).json({
      shipper,
    });
  }
);
// delivered
export const caculatorPrice = catchAsyncErrors(async (req, res, next) => {
  const userId = req.user._id;
  const orders = await Order.find({
    orderStatus: "Delivered",
    paymentMethod: "COD",
  });

  const shipper = await Shipper.findOne({ user: userId });
  const totalAmount = orders.reduce((sum, order) => sum + order.totalAmount, 0);
  shipper.totalPrice = totalAmount;
  await shipper.save();
  res.status(200).json({ order });
});
// order status => Delivered
export const deliveredSuccess = catchAsyncErrors(async (req, res, next) => {
  const id = req.params.id;
  const order = await Order.findByIdAndUpdate(
    id,
    {
      orderStatus: "Delivered",
      "paymentInfo.status": "paid",
    },
    { new: true }
  );
  await order.save();
  res.status(200).json({ order });
});
