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
  caculatorPrice,
  deliveredSuccess,
} from "../controllers/shipperControllers.js";
//app shipping
router
  .route("/shipping/getOrderByShippingUnit")
  .get(isAuthenticatedUser, authorizeRoles("admin"), getOrderByShippingUnit);

router
  .route("/shipper/addShippertoShippingUnit")
  .post(isAuthenticatedUser, authorizeRoles("admin"), addShippertoShippingUnit);
router
  .route("/shipper/caculatorPrice")
  .get(isAuthenticatedUser, authorizeRoles("admin"), caculatorPrice);

router
  .route("/shipper/deliveredSuccess/:id")
  .get(isAuthenticatedUser, authorizeRoles("admin"), deliveredSuccess);
export default router;
