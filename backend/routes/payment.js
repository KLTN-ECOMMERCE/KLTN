import express from "express";
const router = express.Router();

import {
  isAuthenticatedUser,
  isAuthenticatedMobileUser,
} from "../middlewares/auth.js";
import {
  stripeCheckoutSession,
  stripeWebhook,
  stripeCheckoutIntent,
} from "../controllers/paymentControllers.js";

router
  .route("/payment/checkout_session")
  .post(isAuthenticatedUser, stripeCheckoutSession);

router.route("/payment/webhook").post(stripeWebhook);
router
  .route("/payment/payment_intent")
  .post(isAuthenticatedMobileUser, stripeCheckoutIntent);
export default router;
