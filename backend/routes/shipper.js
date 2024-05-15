import express from "express";
const router = express.Router();

import {
  authorizeRoles,
  isAuthenticatedUser,
  isAuthenticatedMobileUser,
} from "../middlewares/auth.js";
import {
  getOrderByShippingUnit,
  addShippertoShippingUnit,
} from "../controllers/shipperControllers.js";
//app shipping
router
  .route("/shipping/getOrderByShippingUnit")
  .get(isAuthenticatedUser, authorizeRoles("admin"), getOrderByShippingUnit);

router
  .route("/shipper/addShippertoShippingUnit")
  .post(isAuthenticatedUser, authorizeRoles("admin"), addShippertoShippingUnit);
export default router;
