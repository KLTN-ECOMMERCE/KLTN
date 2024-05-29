import catchAsyncErrors from "../middlewares/catchAsyncErrors.js";
import Order from "../models/order.js";

import Stripe from "stripe";
const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

// Create stripe checkout session   =>  /api/v1/payment/checkout_session
export const stripeCheckoutSession = catchAsyncErrors(
  async (req, res, next) => {
    const body = req?.body;

    const line_items = body?.orderItems?.map((item) => {
      return {
        price_data: {
          currency: "usd",
          product_data: {
            name: item?.name,
            images: [item?.image],
            metadata: { productId: item?.product },
          },
          unit_amount: item?.price * 100,
        },
        tax_rates: ["txr_1PLodrItb7fygiE0sLZSIrXC"],
        quantity: item?.quantity,
      };
    });

    const shippingInfo = body?.shippingInfo;

    const shipping_rate =
      body?.itemsPrice >= 200
        ? "shr_1PLocaItb7fygiE0CAZnC63c"
        : "shr_1PLocCItb7fygiE0wR4Hlzkw";

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ["card"],
      success_url: `${process.env.FRONTEND_URL}/me/orders?order_success=true`,
      cancel_url: `${process.env.FRONTEND_URL}`,
      customer_email: req?.user?.email,
      client_reference_id: req?.user?._id?.toString(),
      mode: "payment",
      metadata: { ...shippingInfo, itemsPrice: body?.itemsPrice },
      shipping_options: [
        {
          shipping_rate,
        },
      ],
      line_items,
    });
    console.log(session.url);
    res.status(200).json({
      url: session.url,
    });
  }
);
// Create stripe payment intent  =>  /api/v1/payment/payment_intent
export const stripeCheckoutIntent = catchAsyncErrors(async (req, res, next) => {
  const body = req.body;

  const line_items = body.orderItems.map((item) => {
    return {
      amount: item.price * 100,
      currency: "usd",
      name: item.name,
      images: [item.image],
      metadata: { productId: item.product },
      quantity: item.quantity,
    };
  });

  const totalAmount = line_items.reduce(
    (total, item) => total + item.amount * item.quantity,
    0
  );

  // Nếu có voucher, giảm giá từ tổng số tiền
  const voucher = body.voucherInfo;
  const discountAmount = voucher ? voucher.discount * 100 : 0;
  const amount = totalAmount - discountAmount;

  const shippingInfo = body.shippingInfo;

  // tự tính
  // const shipping_rate =
  //   body?.itemsPrice >= 200
  //     ? 0
  //     : 500;

  const paymentIntent = await stripe.paymentIntents.create({
    amount: amount + shipping_rate,
    currency: "usd",
    payment_method_types: ["card"],
    metadata: {
      ...shippingInfo,
      itemsPrice: body.itemsPrice,
      orderItems: JSON.stringify(body.orderItems),
      userId: req.user._id.toString(),
      voucherCode: voucher ? voucher.code : null,
    },
    shipping: {
      name: shippingInfo.fullName,
      address: {
        line1: shippingInfo.address,
        city: shippingInfo.city,
        postal_code: shippingInfo.postalCode,
        country: shippingInfo.country,
      },
    },
  });

  res.status(200).json({
    clientSecret: paymentIntent.client_secret,
  });
});

const getOrderItems = async (line_items) => {
  return new Promise((resolve, reject) => {
    let cartItems = [];

    line_items?.data?.forEach(async (item) => {
      const product = await stripe.products.retrieve(item.price.product);
      const productId = product.metadata.productId;

      cartItems.push({
        product: productId,
        name: product.name,
        price: item.price.unit_amount_decimal / 100,
        quantity: item.quantity,
        image: product.images[0],
      });

      if (cartItems.length === line_items?.data?.length) {
        resolve(cartItems);
      }
    });
  });
};

// Create new order after payment   =>  /api/v1/payment/webhook
export const stripeWebhook = catchAsyncErrors(async (req, res, next) => {
  try {
    const signature = req.headers["stripe-signature"];

    const event = stripe.webhooks.constructEvent(
      req.rawBody,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET
    );

    if (event.type === "checkout.session.completed") {
      const session = event.data.object;

      const line_items = await stripe.checkout.sessions.listLineItems(
        session.id
      );

      const orderItems = await getOrderItems(line_items);
      const user = session.client_reference_id;

      const totalAmount = session.amount_total / 100;
      const taxAmount = session.total_details.amount_tax / 100;
      const shippingAmount = session.total_details.amount_shipping / 100;
      const itemsPrice = session.metadata.itemsPrice;

      const shippingInfo = {
        address: session.metadata.address,
        city: session.metadata.city,
        phoneNo: session.metadata.phoneNo,
        zipCode: session.metadata.zipCode,
        country: session.metadata.country,
      };

      const paymentInfo = {
        id: session.payment_intent,
        status: session.payment_status,
      };

      const orderData = {
        shippingInfo,
        orderItems,
        itemsPrice,
        taxAmount,
        shippingAmount,
        totalAmount,
        paymentInfo,
        paymentMethod: "Card",
        user,
      };

      await Order.create(orderData);

      res.status(200).json({ success: true });
    }
  } catch (error) {
    console.log("Error => ", error);
  }
});
