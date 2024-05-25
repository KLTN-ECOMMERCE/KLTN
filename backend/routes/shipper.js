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
  deliveredSuccess,
  getShipper,
} from "../controllers/shipperControllers.js";
//app shipping
router
  .route("/shipping/getOrderByShippingUnit")
  .get(isAuthenticatedUser, authorizeRoles("shipper"), getOrderByShippingUnit);

router
  .route("/shipper/addShippertoShippingUnit")
  .post(isAuthenticatedUser, authorizeRoles("admin"), addShippertoShippingUnit);
router
  .route("/shipper/deliveredSuccess/:id")
  .get(isAuthenticatedUser, authorizeRoles("admin"), deliveredSuccess);
router
  .route("/shipper")
  .get(isAuthenticatedUser, authorizeRoles("shipper"), getShipper);
export default router;
